package com.dunnas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dunnas.domain.MovimentacaoFinanceira;
import com.dunnas.domain.Usuario;
import java.util.List;

public interface MovimentacaoFinanceiraRepository extends JpaRepository<MovimentacaoFinanceira, Long> {
    List<MovimentacaoFinanceira> findByUsuario(Usuario usuario);
}
