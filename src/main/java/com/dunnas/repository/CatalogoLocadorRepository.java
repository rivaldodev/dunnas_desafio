package com.dunnas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dunnas.domain.CatalogoLocador;
import com.dunnas.domain.Usuario;
import com.dunnas.domain.Obra;
import java.util.Optional;
import java.util.List;

public interface CatalogoLocadorRepository extends JpaRepository<CatalogoLocador, Long> {
    Optional<CatalogoLocador> findByLocadorAndObra(Usuario locador, Obra obra);
    List<CatalogoLocador> findByLocador(Usuario locador);
}
