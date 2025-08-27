package com.dunnas.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dunnas.domain.Role;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByNome(String nome);
}
