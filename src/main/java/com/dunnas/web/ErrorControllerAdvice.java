package com.dunnas.web;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ErrorControllerAdvice implements ErrorController {

    @RequestMapping("/error")
    public String handle(HttpServletRequest request) {
        // Forward para uma JSP simples futuramente; por agora reutiliza home
        return "error";
    }
}