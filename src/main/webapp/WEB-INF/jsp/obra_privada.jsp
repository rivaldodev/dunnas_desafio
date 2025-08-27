<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Descrição Privada</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body style="background:#f7f7f7;">
<jsp:include page="header.jsp"/>
<main class="container" style="margin-top:32px;">
    <h2><c:out value='${obra.titulo}'/></h2>
    <p><b>ISBN:</b> <c:out value='${obra.isbn}'/></p>
    <p><b>Autor:</b> <c:out value='${obra.autor}'/></p>
    <p><b>Descrição Pública:</b><br/><c:out value='${obra.descricaoPublica}'/></p>
    <p><b>Descrição Privada:</b><br/><pre style="white-space:pre-wrap;font-family:inherit;background:#f9f9f9;padding:8px;border:1px solid #ddd;"><c:out value='${obra.descricaoPrivada}'/></pre></p>
</main>
</body>
</html>
