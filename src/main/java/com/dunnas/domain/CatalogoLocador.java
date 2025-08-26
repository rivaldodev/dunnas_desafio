package com.dunnas.domain;

import java.time.OffsetDateTime;
import java.time.ZoneId;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name="catalogo_locador", uniqueConstraints = {@UniqueConstraint(columnNames = {"locador_id","obra_id"})})
public class CatalogoLocador {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="locador_id", nullable=false)
    private Usuario locador;

    // EAGER para evitar LazyInitialization na view (open-in-view=false) ao acessar titulo/isbn
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name="obra_id", nullable=false)
    private Obra obra;

    @Column(nullable=false)
    private Integer estoque;

    @Column(name="criado_em", nullable=false)
    private OffsetDateTime criadoEm;

    @PrePersist
    void pre() { if (criadoEm==null) criadoEm = OffsetDateTime.now(ZoneId.of("America/Sao_Paulo")); }

    public Long getId() { return id; }
    public Usuario getLocador() { return locador; }
    public void setLocador(Usuario locador) { this.locador = locador; }
    public Obra getObra() { return obra; }
    public void setObra(Obra obra) { this.obra = obra; }
    public Integer getEstoque() { return estoque; }
    public void setEstoque(Integer estoque) { this.estoque = estoque; }
    public OffsetDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(OffsetDateTime criadoEm) { this.criadoEm = criadoEm; }
}
