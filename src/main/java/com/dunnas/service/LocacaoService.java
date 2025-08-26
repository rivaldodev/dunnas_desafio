package com.dunnas.service;

import com.dunnas.domain.*;
import com.dunnas.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LocacaoService {
    private final CatalogoLocadorRepository catalogoRepo;
    private final LocacaoRepository locacaoRepo;

    public LocacaoService(CatalogoLocadorRepository catalogoRepo, LocacaoRepository locacaoRepo) {
        this.catalogoRepo = catalogoRepo;
        this.locacaoRepo = locacaoRepo;
    }

    @Transactional
    public Locacao iniciar(Long catalogoId, Usuario cliente) {
        if (catalogoId == null) throw new BusinessException("CatalogoId obrigatório");
        CatalogoLocador cat = catalogoRepo.findById(catalogoId)
                .orElseThrow(() -> new BusinessException("Item de catálogo não encontrado"));
        if (cat.getEstoque() == null || cat.getEstoque() <= 0) {
            throw new BusinessException("Estoque indisponível");
        }
        Locacao l = new Locacao();
        l.setCliente(cliente);
        l.setLocador(cat.getLocador());
        l.setObra(cat.getObra());
        l.setValorTotal(cat.getObra().getPreco());
        try {
            return locacaoRepo.save(l);
        } catch (Exception e){
            String baseMsg = e.getMessage();
            Throwable c = e.getCause();
            if(c != null && c.getMessage()!=null) baseMsg = c.getMessage();
            throw new BusinessException("Falha ao persistir locação: " + baseMsg, e);
        }
    }
}
