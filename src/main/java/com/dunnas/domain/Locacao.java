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

@Entity
public class Locacao {
    public enum Status { ATIVA, FINALIZADA }

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name="cliente_id", nullable=false)
    private Usuario cliente;

    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name="locador_id", nullable=false)
    private Usuario locador;

    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name="obra_id", nullable=false)
    private Obra obra;

    @Column(name="valor_total", nullable=false)
    private Double valorTotal;

    @Column(name="sinal_pago", nullable=false)
    private boolean sinalPago;

    @Column(name="restante_pago", nullable=false)
    private boolean restantePago;

    @Column(name="iniciada_em", nullable=false)
    private OffsetDateTime iniciadaEm;

    @Column(name="devolvida_em")
    private OffsetDateTime devolvidaEm;

    @Enumerated(EnumType.STRING)
    private Status status;

    @PrePersist void pre() {
    if (iniciadaEm==null) iniciadaEm = OffsetDateTime.now(ZoneId.of("America/Sao_Paulo"));
        if (status==null) status = Status.ATIVA;
    }

    public Long getId() { return id; }
    public Usuario getCliente() { return cliente; }
    public void setCliente(Usuario cliente) { this.cliente = cliente; }
    public Usuario getLocador() { return locador; }
    public void setLocador(Usuario locador) { this.locador = locador; }
    public Obra getObra() { return obra; }
    public void setObra(Obra obra) { this.obra = obra; }
    public Double getValorTotal() { return valorTotal; }
    public void setValorTotal(Double valorTotal) { this.valorTotal = valorTotal; }
    public boolean isSinalPago() { return sinalPago; }
    public void setSinalPago(boolean sinalPago) { this.sinalPago = sinalPago; }
    public boolean isRestantePago() { return restantePago; }
    public void setRestantePago(boolean restantePago) { this.restantePago = restantePago; }
    public OffsetDateTime getIniciadaEm() { return iniciadaEm; }
    public void setIniciadaEm(OffsetDateTime iniciadaEm) { this.iniciadaEm = iniciadaEm; }
    public OffsetDateTime getDevolvidaEm() { return devolvidaEm; }
    public void setDevolvidaEm(OffsetDateTime devolvidaEm) { this.devolvidaEm = devolvidaEm; }
    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }
}
