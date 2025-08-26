package com.dunnas.security;

import com.dunnas.repository.UsuarioRepository;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.stream.Collectors;
import com.dunnas.domain.Usuario;

@Service
public class UsuarioDetailsService implements UserDetailsService {

    private final UsuarioRepository repo;

    public UsuarioDetailsService(UsuarioRepository repo) { this.repo = repo; }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    Usuario u = repo.findByEmail(username).orElseThrow(() -> new UsernameNotFoundException("nao achei"));
    Set<GrantedAuthority> auths = u.getRoles().stream()
        .map(r -> (GrantedAuthority) new SimpleGrantedAuthority(r.getNome()))
        .collect(Collectors.toSet());
    return new User(u.getEmail(), u.getSenha(), u.isAtivo(), true, true, true, auths);
    }
}
