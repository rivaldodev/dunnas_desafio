package com.dunnas;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

public class BcryptGenTest {
    @Test
    void gerarHashes() {
        PasswordEncoder enc = new BCryptPasswordEncoder();
        String admin = enc.encode("admin");
        String rivs = enc.encode("rivs");
        System.out.println("HASH_ADMIN=" + admin);
        System.out.println("HASH_RIVS=" + rivs);
    }
}
