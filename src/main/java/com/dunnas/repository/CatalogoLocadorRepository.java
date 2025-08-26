package com.dunnas.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.dunnas.domain.CatalogoLocador;
import com.dunnas.domain.Obra;
import com.dunnas.domain.Usuario;

public interface CatalogoLocadorRepository extends JpaRepository<CatalogoLocador, Long> {
    Optional<CatalogoLocador> findByLocadorAndObra(Usuario locador, Obra obra);
    List<CatalogoLocador> findByLocador(Usuario locador);

    @Query("select c from CatalogoLocador c join fetch c.obra where c.locador = :locador")
    List<CatalogoLocador> findWithObraByLocador(@Param("locador") Usuario locador);

    // Catálogo disponível para um cliente (estoque > 0) excluindo obras do próprio usuário (caso ele também seja locador)
    @Query("select c from CatalogoLocador c join fetch c.obra o join fetch c.locador l where c.estoque > 0 and (:cliente is null or c.locador <> :cliente)")
    List<CatalogoLocador> findDisponiveisParaCliente(@Param("cliente") Usuario cliente);
}
