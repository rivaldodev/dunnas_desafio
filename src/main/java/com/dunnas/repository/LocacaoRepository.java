package com.dunnas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dunnas.domain.Locacao;
import com.dunnas.domain.Usuario;
import com.dunnas.domain.Obra;
import java.util.List;
import java.util.Optional;

public interface LocacaoRepository extends JpaRepository<Locacao, Long> {
    List<Locacao> findByClienteAndStatus(Usuario cliente, Locacao.Status status);
    Optional<Locacao> findFirstByClienteAndObraAndStatus(Usuario cliente, Obra obra, Locacao.Status status);
}
