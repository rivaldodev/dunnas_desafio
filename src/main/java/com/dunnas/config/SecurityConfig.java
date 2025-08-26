package com.dunnas.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                        .requestMatchers("/css/**", "/login", "/usuarios/cadastrar", "/usuarios/cadastrar/**").permitAll()
                        .requestMatchers("/catalogo/obras/gerenciar", "/catalogo/obras/gerenciar/**").hasAnyRole("LOCADOR","ADMIN")
                        .requestMatchers(HttpMethod.POST, "/catalogo/obras/gerenciar").hasAnyRole("LOCADOR","ADMIN")
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/home", true)
                        .permitAll()
                )
                .logout(logout -> logout.logoutUrl("/logout").logoutSuccessUrl("/login?logout"))
                .exceptionHandling(ex -> ex.accessDeniedPage("/403"))
                .csrf(Customizer.withDefaults());
        return http.build();
    }

    @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
    }
}
