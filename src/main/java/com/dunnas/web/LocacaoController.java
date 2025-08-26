package com.dunnas.web;

import com.dunnas.domain.*;
import com.dunnas.repository.*;
import com.dunnas.service.LocacaoService;
import com.dunnas.service.BusinessException;
import com.dunnas.security.PrivateDescriptionPermissionCache;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/locacoes")
public class LocacaoController {
    private static final Logger log = LoggerFactory.getLogger(LocacaoController.class);
    private final UsuarioRepository usuarioRepository;
    private final CatalogoLocadorRepository catalogoLocadorRepository;
    private final LocacaoRepository locacaoRepository;
    private final LocacaoService locacaoService;
    private final MovimentacaoFinanceiraRepository movRepo;
    private final RecargaSaldoRepository recargaRepo;
    private final PrivateDescriptionPermissionCache permCache;

    public LocacaoController(UsuarioRepository usuarioRepository,
                             CatalogoLocadorRepository catalogoLocadorRepository,
                             LocacaoRepository locacaoRepository,
                             LocacaoService locacaoService,
                             MovimentacaoFinanceiraRepository movRepo,
                             RecargaSaldoRepository recargaRepo,
                             PrivateDescriptionPermissionCache permCache) {
        this.usuarioRepository = usuarioRepository;
        this.catalogoLocadorRepository = catalogoLocadorRepository;
        this.locacaoRepository = locacaoRepository;
        this.locacaoService = locacaoService;
        this.movRepo = movRepo;
        this.recargaRepo = recargaRepo;
        this.permCache = permCache;
    }

    private Usuario current(UserDetails ud){
        return usuarioRepository.findByEmail(ud.getUsername()).orElseThrow(() -> new IllegalStateException("user"));
    }

    @GetMapping("/disponiveis")
    public String disponiveis(@AuthenticationPrincipal UserDetails ud,
                              @RequestParam(value="q", required=false) String termo,
                              Model model){
        model.addAttribute("username", ud.getUsername());
        Usuario u = current(ud);
    model.addAttribute("saldo", u.getSaldo());
        List<CatalogoLocador> disponiveis = catalogoLocadorRepository.findDisponiveisParaCliente(u);
        if(termo != null && !termo.trim().isEmpty()){
            String t = termo.trim().toLowerCase();
            disponiveis.removeIf(c -> {
                String titulo = c.getObra().getTitulo()==null?"":c.getObra().getTitulo().toLowerCase();
                String isbn = c.getObra().getIsbn()==null?"":c.getObra().getIsbn().toLowerCase();
                return !titulo.contains(t) && !isbn.contains(t);
            });
        }
        model.addAttribute("q", termo);
        model.addAttribute("lista", disponiveis);
        return "locacoes_disponiveis";
    }

    public static class NovaLocacaoForm { @NotNull Long catalogoId; public Long getCatalogoId(){return catalogoId;} public void setCatalogoId(Long id){this.catalogoId=id;} }

    @PostMapping
    @Transactional
    public String iniciar(@AuthenticationPrincipal UserDetails ud, @Valid NovaLocacaoForm form, BindingResult result, Model model, RedirectAttributes ra){
        Usuario cliente = current(ud);
        if(!UsuarioTipo.CLIENTE.equals(cliente.getTipo())){
            result.reject("forbidden","Apenas CLIENTE pode iniciar locação");
        }
        Optional<CatalogoLocador> catOpt = form.getCatalogoId()==null?Optional.empty():catalogoLocadorRepository.findById(form.getCatalogoId());
    if(!catOpt.isPresent()){
            result.rejectValue("catalogoId","notfound","Item não encontrado");
        }
        if(result.hasErrors()){
            ra.addFlashAttribute("erro", result.getAllErrors().get(0).getDefaultMessage());
            return "redirect:/locacoes/disponiveis";
        }
        try {
            locacaoService.iniciar(form.getCatalogoId(), cliente);
            ra.addFlashAttribute("msg","Locação iniciada");
        } catch (BusinessException be){
            ra.addFlashAttribute("erro", be.getMessage());
            return "redirect:/locacoes/disponiveis";
        } catch (Exception e){
            log.error("Falha inesperada iniciar locacao", e);
            ra.addFlashAttribute("erro", "Erro inesperado ao iniciar locação");
            return "redirect:/locacoes/disponiveis";
        }
        return "redirect:/locacoes/minhas";
    }

    @GetMapping("/minhas")
    public String minhas(@AuthenticationPrincipal UserDetails ud, Model model){
        Usuario cliente = current(ud);
        model.addAttribute("username", ud.getUsername());
    model.addAttribute("saldo", cliente.getSaldo());
        model.addAttribute("locacoes", locacaoRepository.findActiveWithObra(cliente, Locacao.Status.ATIVA));
        return "locacoes_minhas";
    }

    @GetMapping("/extrato")
    public String extrato(@AuthenticationPrincipal UserDetails ud, Model model){
        Usuario cliente = current(ud);
        model.addAttribute("username", ud.getUsername());
        model.addAttribute("saldo", cliente.getSaldo());
        model.addAttribute("movs", movRepo.findExtrato(cliente));
        model.addAttribute("recargas", recargaRepo.findByUsuarioOrderByCriadaEmDesc(cliente));
        return "extrato";
    }

    @GetMapping("/historico-locador")
    public String historicoLocador(@AuthenticationPrincipal UserDetails ud, Model model){
        Usuario u = current(ud);
        if(!UsuarioTipo.LOCADOR.equals(u.getTipo())) {
            return "403";
        }
        model.addAttribute("username", ud.getUsername());
        List<Locacao> locs = locacaoRepository.findHistoricoByLocador(u);
        model.addAttribute("locacoes", locs);
        return "locacoes_historico_locador";
    }

    public static class RecargaForm { @NotNull Double valor; @NotNull RecargaSaldo.Tipo tipo; public Double getValor(){return valor;} public void setValor(Double v){this.valor=v;} public RecargaSaldo.Tipo getTipo(){return tipo;} public void setTipo(RecargaSaldo.Tipo t){this.tipo=t;} }

    @PostMapping("/recarga") @Transactional
    public String recarga(@AuthenticationPrincipal UserDetails ud, @Valid RecargaForm form, BindingResult br, RedirectAttributes ra){
        Usuario cliente = current(ud);
        if(form.getValor()==null || form.getValor()<=0){ br.rejectValue("valor","invalido","Valor deve ser > 0"); }
        if(br.hasErrors()){
            ra.addFlashAttribute("erro", br.getAllErrors().get(0).getDefaultMessage());
            return "redirect:/locacoes/extrato";
        }
        RecargaSaldo r = new RecargaSaldo();
        r.setUsuario(cliente); r.setValor(form.getValor()); r.setTipo(form.getTipo());
        recargaRepo.save(r); // trigger credita saldo
        ra.addFlashAttribute("msg","Recarga registrada");
        return "redirect:/locacoes/extrato";
    }


    @PostMapping("/finalizar")
    @Transactional
    public String finalizar(@AuthenticationPrincipal UserDetails ud, @RequestParam("locacaoId") Long locacaoId, RedirectAttributes ra){
        Usuario cliente = current(ud);
        Locacao l = locacaoRepository.findById(locacaoId).orElse(null);
        if(l == null){
            ra.addFlashAttribute("erro", "Locação não encontrada");
            return "redirect:/locacoes/minhas";
        }
        if(!l.getCliente().getId().equals(cliente.getId())){ ra.addFlashAttribute("erro","Não permitido"); return "redirect:/locacoes/minhas"; }
        l.setStatus(Locacao.Status.FINALIZADA); // triggers validarão pagamentos, debitarão saldo e devolverão estoque
        try {
            locacaoRepository.save(l);
            // revoga acesso privado após finalização
            permCache.revoke(cliente.getId(), l.getObra().getId());
            ra.addFlashAttribute("msg","Locação finalizada");
        } catch (org.springframework.dao.DataIntegrityViolationException dive){
            String msg = dive.getMostSpecificCause()!=null? dive.getMostSpecificCause().getMessage(): dive.getMessage();
            ra.addFlashAttribute("erro","Não foi possível finalizar: "+msg);
        } catch (Exception ex){
            ra.addFlashAttribute("erro","Falha ao finalizar: "+ex.getMessage());
        }
        return "redirect:/locacoes/minhas";
    }
}
