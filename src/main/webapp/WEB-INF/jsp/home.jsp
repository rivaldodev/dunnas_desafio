<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Home</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body>
<header>
    <nav>
    <fmt:setLocale value="pt_BR"/>
    <span>${username} (Saldo: <fmt:formatNumber value='${saldo}' type='currency'/>)</span>
        <a href="<c:url value='/catalogo/obras' />">Catálogo</a>
        <c:if test="${tipo == 'LOCADOR'}">
            <a href="<c:url value='/locador/catalogo' />">Meu Catálogo</a>
            <a href="${pageContext.request.contextPath}/locacoes/historico-locador">Histórico Locações</a>
        </c:if>
        <c:if test="${tipo == 'CLIENTE'}">
            <a href="${pageContext.request.contextPath}/locacoes/disponiveis">Obras Disponíveis</a>
            <a href="${pageContext.request.contextPath}/locacoes/minhas">Minhas Locações</a>
            <a href="${pageContext.request.contextPath}/locacoes/extrato">Extrato / Saldo</a>
        </c:if>
        <form action="<c:url value='/logout'/>" method="post" style="display:inline">
            <c:if test="${_csrf != null}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <button type="submit">Sair</button>
        </form>
    </nav>
</header>
<main>
    <h2>Bem vindo</h2>
    <c:if test="${tipo == 'LOCADOR'}">
        <p>Você é LOCADOR. Gerencie seu catálogo.</p>
    </c:if>
    <c:if test="${tipo == 'CLIENTE'}">
        <p>Você é CLIENTE. Em breve poderá iniciar locações.</p>
    </c:if>
</main>
<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</body>
</html>
