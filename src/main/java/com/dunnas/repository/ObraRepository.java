package com.dunnas.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dunnas.domain.Obra;

public interface ObraRepository extends JpaRepository<Obra, Long> {
    Optional<Obra> findByIsbn(String isbn);
}
