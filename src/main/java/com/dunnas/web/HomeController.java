package com.dunnas.web;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.dunnas.domain.Usuario;
import com.dunnas.repository.ObraRepository;
import com.dunnas.repository.UsuarioRepository;

@Controller
public class HomeController {

    private final UsuarioRepository usuarioRepository;
    private final ObraRepository obraRepository;

    public HomeController(UsuarioRepository usuarioRepository, ObraRepository obraRepository){
        this.usuarioRepository = usuarioRepository;
        this.obraRepository = obraRepository;
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping({"/", "/home"})
    public String home(@AuthenticationPrincipal UserDetails user, Model model) {
        model.addAttribute("username", user.getUsername());
        Usuario u = usuarioRepository.findByEmail(user.getUsername()).orElse(null);
        if(u != null){
            model.addAttribute("tipo", u.getTipo());
            model.addAttribute("saldo", u.getSaldo());
        }
        // Adiciona lista de obras para o catálogo na home
        model.addAttribute("obras", obraRepository.findAll());
        return "home";
    }

    @GetMapping("/403")
    public String acessoNegado(){
        return "403";
    }
}
