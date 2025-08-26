package com.dunnas.web;

import com.dunnas.domain.CatalogoLocador;
import com.dunnas.domain.Obra;
import com.dunnas.domain.Usuario;
import com.dunnas.domain.UsuarioTipo;
import com.dunnas.repository.CatalogoLocadorRepository;
import com.dunnas.repository.ObraRepository;
import com.dunnas.repository.UsuarioRepository;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/locador/catalogo")
public class CatalogoLocadorController {
    private final UsuarioRepository usuarioRepository;
    private final CatalogoLocadorRepository catalogoLocadorRepository;
    private final ObraRepository obraRepository;

    public CatalogoLocadorController(UsuarioRepository usuarioRepository,
                                     CatalogoLocadorRepository catalogoLocadorRepository,
                                     ObraRepository obraRepository) {
        this.usuarioRepository = usuarioRepository;
        this.catalogoLocadorRepository = catalogoLocadorRepository;
        this.obraRepository = obraRepository;
    }

    public static class NovoCatalogoForm {
        @NotNull
        private Long obraId;
        @NotNull @Min(0)
        private Integer estoque;
        public NovoCatalogoForm() {}
        public NovoCatalogoForm(Long obraId, Integer estoque) { this.obraId = obraId; this.estoque = estoque; }
        public Long getObraId() { return obraId; }
        public void setObraId(Long obraId) { this.obraId = obraId; }
        public Integer getEstoque() { return estoque; }
        public void setEstoque(Integer estoque) { this.estoque = estoque; }
    }

    private Usuario current(UserDetails user){
        return usuarioRepository.findByEmail(user.getUsername())
                .orElseThrow(() -> new IllegalStateException("Usuário não encontrado"));
    }

    @GetMapping
    public String listar(@AuthenticationPrincipal UserDetails user, Model model){
        Usuario locador = current(user);
        model.addAttribute("username", user.getUsername());
    List<CatalogoLocador> itens = catalogoLocadorRepository.findWithObraByLocador(locador);
        model.addAttribute("itens", itens);
        model.addAttribute("obras", obraRepository.findAll());
        model.addAttribute("form", new NovoCatalogoForm(null, 0));
        return "catalogo_locador";
    }

    @PostMapping
    public String adicionar(@AuthenticationPrincipal UserDetails user,
                            @Valid NovoCatalogoForm form,
                            BindingResult result,
                            Model model){
        Usuario locador = current(user);
        if(!UsuarioTipo.LOCADOR.equals(locador.getTipo())){
            result.reject("forbidden","Somente LOCADOR pode alterar catálogo");
        }
        Optional<Obra> obraOpt = form.getObraId() == null ? Optional.empty() : obraRepository.findById(form.getObraId());
    if(form.getObraId() != null && !obraOpt.isPresent()){
            result.rejectValue("obraId","notfound","Obra inexistente");
        } else if(obraOpt.isPresent() && catalogoLocadorRepository.findByLocadorAndObra(locador, obraOpt.get()).isPresent()) {
            result.rejectValue("obraId","duplicate","Já cadastrada");
        }
        if(result.hasErrors()){
            model.addAttribute("username", user.getUsername());
            model.addAttribute("itens", catalogoLocadorRepository.findWithObraByLocador(locador));
            model.addAttribute("obras", obraRepository.findAll());
            model.addAttribute("form", form);
            Map<String,String> errors = new HashMap<>();
            result.getFieldErrors().forEach(fe -> errors.put(fe.getField(), fe.getDefaultMessage()));
            model.addAttribute("errors", errors);
            return "catalogo_locador";
        }
        CatalogoLocador c = new CatalogoLocador();
        c.setLocador(locador);
        c.setObra(obraOpt.get());
        c.setEstoque(form.getEstoque());
        catalogoLocadorRepository.save(c);
        return "redirect:/locador/catalogo";
    }
}
