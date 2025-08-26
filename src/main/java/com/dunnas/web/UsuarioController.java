package com.dunnas.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import java.beans.PropertyEditorSupport;

import com.dunnas.domain.Usuario;
import com.dunnas.domain.UsuarioTipo;
import com.dunnas.repository.UsuarioRepository;
import com.dunnas.repository.RoleRepository;
import com.dunnas.domain.Role;

import jakarta.validation.Valid;

@Controller
public class UsuarioController {
    @Autowired
    private UsuarioRepository usuarioRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private RoleRepository roleRepository;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(UsuarioTipo.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                setValue(UsuarioTipo.valueOf(text));
            }
        });
    }

    @GetMapping("/usuarios/cadastrar")
    public String form(Model model) {
        model.addAttribute("usuario", new Usuario());
        model.addAttribute("tipos", UsuarioTipo.values());
        return "usuarios_cadastrar";
    }

    @PostMapping("/usuarios/cadastrar")
    public String cadastrar(@Valid @ModelAttribute("usuario") Usuario usuario, BindingResult result, Model model) {
        if (usuarioRepository.findByEmail(usuario.getEmail()).isPresent()) {
            result.rejectValue("email", null, "E-mail já cadastrado");
        }
        if (result.hasErrors()) {
            model.addAttribute("tipos", UsuarioTipo.values());
            return "usuarios_cadastrar";
        }
        usuario.setSenha(passwordEncoder.encode(usuario.getSenha()));
        // Atribui role conforme tipo
        String roleName = usuario.getTipo() == UsuarioTipo.LOCADOR ? "ROLE_LOCADOR" : "ROLE_CLIENTE";
        Role role = roleRepository.findByNome(roleName).orElse(null);
        if (role != null) {
            usuario.getRoles().clear();
            usuario.getRoles().add(role);
        }
        try {
            usuarioRepository.save(usuario);
            model.addAttribute("msg", "Usuário cadastrado com sucesso!");
            model.addAttribute("usuario", new Usuario());
        } catch (Exception e) {
            model.addAttribute("erro", "Erro ao cadastrar usuário: " + e.getMessage());
            model.addAttribute("usuario", usuario);
        }
        model.addAttribute("tipos", UsuarioTipo.values());
        return "usuarios_cadastrar";
    }
}
