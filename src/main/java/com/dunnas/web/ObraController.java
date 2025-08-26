package com.dunnas.web;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.dunnas.domain.Locacao;
import com.dunnas.domain.Obra;
import com.dunnas.domain.Usuario;
import com.dunnas.repository.LocacaoRepository;
import com.dunnas.repository.ObraRepository;
import com.dunnas.repository.UsuarioRepository;
import com.dunnas.security.PrivateDescriptionPermissionCache;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Controller
public class ObraController {

    private final ObraRepository obraRepository;
    private final LocacaoRepository locacaoRepository;
    private final UsuarioRepository usuarioRepository;
    private final PrivateDescriptionPermissionCache permCache;

    public ObraController(ObraRepository obraRepository, LocacaoRepository locacaoRepository, UsuarioRepository usuarioRepository, PrivateDescriptionPermissionCache permCache) {
        this.obraRepository = obraRepository;
        this.locacaoRepository = locacaoRepository;
        this.usuarioRepository = usuarioRepository;
        this.permCache = permCache;
    }

    public static class NovaObraForm {
        @NotBlank @Size(max=20)
        private String isbn;
        @NotBlank @Size(max=200)
        private String titulo;
        @Size(max=160)
        private String autor;
        @NotNull @DecimalMin(value="0.01")
        private Double preco;
        private boolean publico = true;
    @Size(max=500)
    private String descricaoPublica;
    @Size(max=2000)
    private String descricaoPrivada;
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
    }

    @GetMapping("/obras/{id}/privada")
    public String descricaoPrivada(@PathVariable("id") Long id, @AuthenticationPrincipal UserDetails ud, Model model){
        Obra o = obraRepository.findById(id).orElse(null);
        if(o == null){
            model.addAttribute("erro","Obra não encontrada");
            return "error";
        }
        Usuario u = usuarioRepository.findByEmail(ud.getUsername()).orElse(null);
        boolean autorizado = false;
        if(u != null){
            if(u.getTipo() == com.dunnas.domain.UsuarioTipo.LOCADOR){
                autorizado = true;
            } else {
                Long uid = u.getId(); Long oid = o.getId();
                if(permCache.has(uid, oid)) {
                    // still require active locacao to enforce revocation after finalize
                    autorizado = locacaoRepository.findFirstByClienteAndObraAndStatus(u, o, Locacao.Status.ATIVA).isPresent();
                    if(!autorizado) permCache.revoke(uid, oid);
                } else {
                    boolean active = locacaoRepository.findFirstByClienteAndObraAndStatus(u, o, Locacao.Status.ATIVA).isPresent();
                    if(active){
                        permCache.grant(uid, oid);
                        autorizado = true;
                    }
                }
            }
        }
        if(!autorizado){
            model.addAttribute("erro","Descrição privada disponível apenas após locação ativa.");
            return "403";
        }
        model.addAttribute("obra", o);
        model.addAttribute("username", ud.getUsername());
        return "obra_privada";
    }

    @GetMapping("/catalogo/obras")
    public String listar(@AuthenticationPrincipal UserDetails user, Model model) {
        model.addAttribute("username", user.getUsername());
        model.addAttribute("obras", obraRepository.findAll());
        return "obras"; // somente listagem
    }

    @GetMapping("/catalogo/obras/gerenciar")
    public String gerenciar(@AuthenticationPrincipal UserDetails user, Model model) {
        model.addAttribute("username", user.getUsername());
        model.addAttribute("obras", obraRepository.findAll());
        model.addAttribute("form", new NovaObraForm());
        return "obras_gerenciar";
    }

    @PostMapping("/catalogo/obras/gerenciar")
    public String criar(@AuthenticationPrincipal UserDetails user,
                        @Valid NovaObraForm form,
                        BindingResult result,
                        Model model) {
        if(obraRepository.findByIsbn(form.getIsbn()).isPresent()) {
            result.rejectValue("isbn","duplicate","ISBN já cadastrado");
        }
        if(result.hasErrors()) {
            model.addAttribute("username", user.getUsername());
            model.addAttribute("obras", obraRepository.findAll());
            return "obras_gerenciar";
        }
        Obra o = new Obra();
        o.setIsbn(form.getIsbn());
        o.setTitulo(form.getTitulo());
        o.setAutor(form.getAutor());
        o.setPreco(form.getPreco());
        o.setPublico(form.isPublico());
    o.setDescricaoPublica(form.getDescricaoPublica());
    o.setDescricaoPrivada(form.getDescricaoPrivada());
        obraRepository.save(o);
        return "redirect:/catalogo/obras/gerenciar";
    }
}
