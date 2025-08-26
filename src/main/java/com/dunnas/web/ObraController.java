package com.dunnas.web;

import com.dunnas.repository.ObraRepository;
import com.dunnas.domain.Obra;
import jakarta.validation.constraints.*;
import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;

@Controller
public class ObraController {

    private final ObraRepository obraRepository;

    public ObraController(ObraRepository obraRepository) {
        this.obraRepository = obraRepository;
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
    }

    @GetMapping("/catalogo/obras")
    public String listar(@AuthenticationPrincipal UserDetails user, Model model) {
        model.addAttribute("username", user.getUsername());
        model.addAttribute("obras", obraRepository.findAll());
        model.addAttribute("form", new NovaObraForm());
        // reutiliza user tipo se necessário futuramente (buscar diretamente via repository opcional)
        return "obras";
    }

    @PostMapping("/catalogo/obras")
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
            return "obras";
        }
        Obra o = new Obra();
        o.setIsbn(form.getIsbn());
        o.setTitulo(form.getTitulo());
        o.setAutor(form.getAutor());
        o.setPreco(form.getPreco());
        o.setPublico(form.isPublico());
        obraRepository.save(o);
        return "redirect:/catalogo/obras";
    }
}
