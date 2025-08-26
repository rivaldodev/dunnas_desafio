package com.dunnas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dunnas.domain.RecargaSaldo;
import com.dunnas.domain.Usuario;
import java.util.List;

public interface RecargaSaldoRepository extends JpaRepository<RecargaSaldo, Long> {
    List<RecargaSaldo> findByUsuarioOrderByCriadaEmDesc(Usuario usuario);
}