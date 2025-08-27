<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header class="app-header">
    <nav class="app-nav">
        <div class="app-nav-left">
            <span class="app-brand">Locadora dunnas</span>
            <a href='<c:url value="/home"/>'>Catálogo</a>
            <c:if test='${tipo == "LOCADOR"}'>
                <a href='<c:url value="/locador/catalogo"/>'>Meu Catálogo</a>
                <a href='<c:url value="/catalogo/obras/gerenciar"/>'>Gerenciar Obras</a>
                <a href='${pageContext.request.contextPath}/locacoes/historico-locador'>Histórico Locações</a>
            </c:if>
            <c:if test='${tipo == "CLIENTE"}'>
                <a href='${pageContext.request.contextPath}/locacoes/disponiveis'>Obras Disponíveis</a>
                <a href='${pageContext.request.contextPath}/locacoes/minhas'>Minhas Locações</a>
                <a href='${pageContext.request.contextPath}/locacoes/extrato'>Extrato / Saldo</a>
            </c:if>
        </div>
        <div class="app-nav-right">
            <span style="font-size:15px;color:#444;white-space:nowrap;">${username} (Saldo: <fmt:formatNumber value='${saldo}' type='currency'/>)</span>
            <form action="<c:url value='/logout'/>" method="post" style="display:inline">
                <c:if test="${_csrf != null}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>
                <button type="submit" class="btn btn-secondary">Sair</button>
            </form>
        </div>
    </nav>
</header>
