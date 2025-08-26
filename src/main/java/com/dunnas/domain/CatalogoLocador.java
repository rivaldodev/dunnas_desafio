package com.dunnas.domain;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name="catalogo_locador", uniqueConstraints = {@UniqueConstraint(columnNames = {"locador_id","obra_id"})})
public class CatalogoLocador {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="locador_id", nullable=false)
    private Usuario locador;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="obra_id", nullable=false)
    private Obra obra;

    @Column(nullable=false)
    private Integer estoque;

    @Column(name="criado_em", nullable=false)
    private OffsetDateTime criadoEm;

    @PrePersist
    void pre() { if (criadoEm==null) criadoEm = OffsetDateTime.now(); }

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
