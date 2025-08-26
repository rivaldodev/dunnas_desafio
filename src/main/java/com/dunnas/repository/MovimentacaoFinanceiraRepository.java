package com.dunnas.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.dunnas.domain.Locacao;
import com.dunnas.domain.MovimentacaoFinanceira;
import com.dunnas.domain.Usuario;

public interface MovimentacaoFinanceiraRepository extends JpaRepository<MovimentacaoFinanceira, Long> {
    List<MovimentacaoFinanceira> findByUsuario(Usuario usuario);

    @Query("select m from MovimentacaoFinanceira m join fetch m.locacao where m.usuario = :u order by m.criadaEm desc")
    List<MovimentacaoFinanceira> findExtrato(@Param("u") Usuario usuario);

    List<MovimentacaoFinanceira> findByLocacao(Locacao locacao);
}
