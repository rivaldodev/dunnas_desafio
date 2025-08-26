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
@Table(name="movimentacao_financeira")
public class MovimentacaoFinanceira {
    public enum Tipo { SINAL, RESTANTE }

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name="usuario_id", nullable=false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name="locacao_id", nullable=false)
    private Locacao locacao;

    @Enumerated(EnumType.STRING)
    private Tipo tipo;

    @Column(nullable=false)
    private Double valor;

    @Column(name="criada_em", nullable=false)
    private OffsetDateTime criadaEm;

    @PrePersist void pre() { if (criadaEm==null) criadaEm = OffsetDateTime.now(ZoneId.of("America/Sao_Paulo")); }

    public Long getId() { return id; }
    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }
    public Locacao getLocacao() { return locacao; }
    public void setLocacao(Locacao locacao) { this.locacao = locacao; }
    public Tipo getTipo() { return tipo; }
    public void setTipo(Tipo tipo) { this.tipo = tipo; }
    public Double getValor() { return valor; }
    public void setValor(Double valor) { this.valor = valor; }
    public OffsetDateTime getCriadaEm() { return criadaEm; }
    public void setCriadaEm(OffsetDateTime criadaEm) { this.criadaEm = criadaEm; }
}
