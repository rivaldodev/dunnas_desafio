package com.dunnas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dunnas.domain.Obra;
import java.util.Optional;

public interface ObraRepository extends JpaRepository<Obra, Long> {
    Optional<Obra> findByIsbn(String isbn);
}
