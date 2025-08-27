<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Minhas Locações</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body style="background:#f4f6fa;">
<jsp:include page="header.jsp"/>

<main class="container" style="margin-top:32px;">
<h2>Minhas Locações Ativas</h2>
<p>Usuário: ${username} | Saldo: <c:out value="${saldo}"/></p>
<c:if test="${not empty erro}"><div style="color:red">${erro}</div></c:if>
<c:if test="${not empty msg}"><div style="color:green">${msg}</div></c:if>
<style>
        /* table visuals provided by global /css/style.css; keep only small local helpers */
        .btn-sm {
                padding: 6px 12px !important;
                font-size: 13px !important;
        }
</style>

<fmt:setLocale value="pt_BR"/>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Obra</th>
            <th>ISBN</th>
            <th>Status</th>
            <th>Iniciada</th>
            <th>Valor Total</th>
            <th>Parcel. (50%)</th>
            <th>Restante</th>
            <th>Sinal / Restante</th>
            <th>Ações</th>
        </tr>
    </thead>
    <tbody>
<c:forEach items="${locacoes}" var="l">
    <tr>
        <td>${l.id}</td>
        <td>${l.obra.titulo}</td>
    <td>${l.obra.isbn}</td>
    <td>${l.status}</td>
    <td>${dates:format(l.iniciadaEm)}</td>
    <td><fmt:formatNumber value='${l.valorTotal}' type='currency'/></td>
        <td><fmt:formatNumber value='${l.valorTotal * 0.5}' type='currency'/></td>
        <td><fmt:formatNumber value='${l.valorTotal - (l.valorTotal * 0.5)}' type='currency'/></td>
        <td>Sinal: <b><c:out value="${l.sinalPago ? 'OK' : 'PENDENTE'}"/></b><br/>Restante: <b><c:out value="${l.restantePago ? 'OK':'PENDENTE'}"/></b></td>
        <td>
            <c:if test="${l.status != 'FINALIZADA'}">
                <form style="display:inline" method="post" action="${pageContext.request.contextPath}/locacoes/finalizar">
                    <input type="hidden" name="locacaoId" value="${l.id}" />
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                    <button type="submit" class="btn btn-primary btn-sm">Finalizar / Devolver</button>
                </form>
            </c:if>
            <form style="display:inline" method="get" action="${pageContext.request.contextPath}/obras/${l.obra.id}/privada">
                <button type="submit" class="btn btn-secondary btn-sm">Acessar descrição privada</button>
            </form>
        </td>
    </tr>
</c:forEach>
</table>
<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</main>
</body>
</html>
