<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Obras Disponíveis</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body style="background:#f4f6fa;">
<jsp:include page="header.jsp"/>

<main class="container" style="margin-top:32px;">
<h2 style="margin-bottom: 8px;">Obras Disponíveis para Locação</h2>
<div style="display: flex; flex-wrap: wrap; align-items: center; gap: 18px; margin-bottom: 18px;">
    <div style="font-size:15px; color:#444; background:#f3f4f6; padding:8px 18px; border-radius:6px;">
        <b>${username}</b> | Saldo: <c:out value="${saldo}"/>
    </div>
    <form method="get" action="${pageContext.request.contextPath}/locacoes/disponiveis" style="display: flex; gap: 8px; align-items: center; margin:0;">
        <input type="text" name="q" value="${q}" placeholder="Filtrar por título ou ISBN" style="min-width:220px;"/>
        <button type="submit" class="btn btn-secondary">Filtrar</button>
    </form>
    <form method="post" action="${pageContext.request.contextPath}/locacoes" style="display: flex; gap: 8px; align-items: center; margin:0;">
        <input type="number" name="catalogoId" placeholder="ID do Catálogo" required style="width:120px;"/>
        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-primary">Iniciar Locação</button>
    </form>
</div>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<c:if test="${not empty msg}"><div class="alert alert-success">${msg}</div></c:if>
    <style>
    /* table visuals provided by /css/style.css */
    </style>
<table>
<thead>
<tr><th>ID Catálogo</th><th>Locador</th><th>Obra</th><th>ISBN</th><th>Preço</th><th>Estoque</th></tr>
</thead>
<tbody>
<fmt:setLocale value="pt_BR"/>
<c:forEach items="${lista}" var="c">
    <tr>
        <td>${c.id}</td>
        <td>${c.locador.nome}</td>
    <td>${c.obra.titulo}</td>
    <td>${c.obra.isbn}</td>
    <td><fmt:formatNumber value='${c.obra.preco}' type='currency'/></td>
        <td>${c.estoque}</td>
    </tr>
</c:forEach>
</table>
<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</main>
</body>
</html>
