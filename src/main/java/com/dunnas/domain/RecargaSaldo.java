package com.dunnas.domain;

import java.time.OffsetDateTime;
import java.time.ZoneId;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name="recarga_saldo")
public class RecargaSaldo {
    public enum Tipo { PIX, CARTAO_CREDITO, CARTAO_DEBITO, TRANSFERENCIA }

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name="usuario_id", nullable=false)
    private Usuario usuario;

    @Enumerated(EnumType.STRING)
    private Tipo tipo;

    @Column(nullable=false)
    private Double valor;

    @Column(name="criada_em", nullable=false)
    private OffsetDateTime criadaEm;

    @PrePersist void pre(){ if(criadaEm==null) criadaEm = OffsetDateTime.now(ZoneId.of("America/Sao_Paulo")); }

    public Long getId(){ return id; }
    public Usuario getUsuario(){ return usuario; }
    public void setUsuario(Usuario u){ this.usuario = u; }
    public Tipo getTipo(){ return tipo; }
    public void setTipo(Tipo t){ this.tipo = t; }
    public Double getValor(){ return valor; }
    public void setValor(Double v){ this.valor = v; }
    public OffsetDateTime getCriadaEm(){ return criadaEm; }
}