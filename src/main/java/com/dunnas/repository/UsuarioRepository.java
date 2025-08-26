package com.dunnas.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dunnas.domain.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByEmail(String email);
}
