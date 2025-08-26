package com.dunnas;

import java.time.ZoneId;
import java.util.TimeZone;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import jakarta.annotation.PostConstruct;

@SpringBootApplication
public class DunnasDesafioApplication {
    public static void main(String[] args) {
        SpringApplication.run(DunnasDesafioApplication.class, args);
    }

    @PostConstruct
    public void init(){
        // Define timezone padrão da aplicação como America/Sao_Paulo (UTC-3, com DST se aplicável)
        TimeZone tz = TimeZone.getTimeZone(ZoneId.of("America/Sao_Paulo"));
        TimeZone.setDefault(tz);
        System.setProperty("user.timezone", tz.getID());
    }
}
