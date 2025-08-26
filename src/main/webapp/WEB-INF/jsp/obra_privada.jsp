<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Descrição Privada</title>
</head>
<body>
<header>
    <nav>
        <span>${username}</span>
        <a href="<c:url value='/'/>">Home</a>
        <a href="<c:url value='/catalogo/obras'/>">Obras</a>
        <a href="<c:url value='/locacoes/minhas'/>">Minhas Locações</a>
    </nav>
</header>
<main>
    <h2><c:out value='${obra.titulo}'/></h2>
    <p><b>ISBN:</b> <c:out value='${obra.isbn}'/></p>
    <p><b>Autor:</b> <c:out value='${obra.autor}'/></p>
    <p><b>Descrição Pública:</b><br/><c:out value='${obra.descricaoPublica}'/></p>
    <p><b>Descrição Privada:</b><br/><pre style="white-space:pre-wrap;font-family:inherit;background:#f9f9f9;padding:8px;border:1px solid #ddd;"><c:out value='${obra.descricaoPrivada}'/></pre></p>
</main>
</body>
</html>
