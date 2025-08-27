<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Acesso Negado</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body style="background:#f7f7f7;">
<header class="app-header">
    <nav class="app-nav">
    </nav>
</header>
    <nav class="app-nav">
        <div class="app-nav-left">
            <span class="app-brand">Locadora dunnas</span>
            <a href='<c:url value="/"/>'>Home</a>
            <a href='<c:url value="/catalogo/obras"/>'>Obras</a>
        </div>
    </nav>
</header>
<main class="container" style="margin-top:32px;">
    <h2>Acesso negado</h2>
    <p>Você não tem permissão para executar esta ação.</p>
</main>
</body>
</html>
