package com.dunnas.domain;

import java.time.OffsetDateTime;
import java.time.ZoneId;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;

@Entity
public class Obra {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable=false, unique=true, length=20)
    private String isbn;
    @Column(nullable=false, length=200)
    private String titulo;
    @Column(length=160)
    private String autor;
    @Column(nullable=false)
    private Double preco; // manter simples na app; precisão garantida no banco
    @Column(nullable=false)
    private boolean publico = true;
    // campos de descrição: parte pública e parte privada (revelada só após locação)
    @Column(name="desc_publica", length=500)
    private String descricaoPublica;
    @Column(name="desc_privada", length=2000)
    private String descricaoPrivada;
    @Column(name="criado_em", nullable=false)
    private OffsetDateTime criadoEm;

    @PrePersist
    void pre() { if (criadoEm==null) criadoEm = OffsetDateTime.now(ZoneId.of("America/Sao_Paulo")); }

    public Long getId() { return id; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }
    public Double getPreco() { return preco; }
    public void setPreco(Double preco) { this.preco = preco; }
    public boolean isPublico() { return publico; }
    public void setPublico(boolean publico) { this.publico = publico; }
    public String getDescricaoPublica() { return descricaoPublica; }
    public void setDescricaoPublica(String d) { this.descricaoPublica = d; }
    public String getDescricaoPrivada() { return descricaoPrivada; }
    public void setDescricaoPrivada(String d) { this.descricaoPrivada = d; }
    public OffsetDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(OffsetDateTime criadoEm) { this.criadoEm = criadoEm; }
}
