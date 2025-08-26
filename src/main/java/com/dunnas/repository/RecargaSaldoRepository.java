package com.dunnas.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dunnas.domain.RecargaSaldo;
import com.dunnas.domain.Usuario;

public interface RecargaSaldoRepository extends JpaRepository<RecargaSaldo, Long> {
    List<RecargaSaldo> findByUsuarioOrderByCriadaEmDesc(Usuario usuario);
}