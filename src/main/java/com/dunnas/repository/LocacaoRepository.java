package com.dunnas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.dunnas.domain.Locacao;
import com.dunnas.domain.Usuario;
import com.dunnas.domain.Obra;
import java.util.List;
import java.util.Optional;

public interface LocacaoRepository extends JpaRepository<Locacao, Long> {
    List<Locacao> findByClienteAndStatus(Usuario cliente, Locacao.Status status);

    @Query("select l from Locacao l join fetch l.obra where l.cliente = :cliente and l.status = :status")
    List<Locacao> findActiveWithObra(@Param("cliente") Usuario cliente, @Param("status") Locacao.Status status);
    Optional<Locacao> findFirstByClienteAndObraAndStatus(Usuario cliente, Obra obra, Locacao.Status status);

    @Query("select l from Locacao l join fetch l.obra o join fetch l.cliente c where l.locador = :locador order by l.iniciadaEm desc")
    List<Locacao> findHistoricoByLocador(@Param("locador") Usuario locador);
}
