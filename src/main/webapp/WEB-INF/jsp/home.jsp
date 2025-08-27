<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Home</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body>
<jsp:include page="header.jsp"/>
<main class="container" style="margin-top:32px;">
    <h2>Bem-vindo!</h2>
    <c:if test="${tipo == 'LOCADOR'}">
        <p>Você é <b>LOCADOR</b>. Gerencie seu catálogo e acompanhe suas locações.</p>
    </c:if>
    <c:if test="${tipo == 'CLIENTE'}">
        <p>Você é <b>CLIENTE</b>. Agora você pode realizar locações normalmente!</p>
    </c:if>
    <h3>Catálogo de Obras (Listagem)</h3>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>ISBN</th>
            <th>Título</th>
            <th>Autor</th>
            <th>Preço</th>
            <th>Desc Pública</th>
            <th>Privada?</th>
            <th>Criado</th>
        </tr>
        </thead>
        <tbody>
        <fmt:setLocale value="pt_BR"/>
        <c:forEach items="${obras}" var="o">
            <tr>
                <td><c:out value='${o.id}'/></td>
                <td><c:out value='${o.isbn}'/></td>
                <td><c:out value='${o.titulo}'/></td>
                <td><c:out value='${o.autor}'/></td>
                <td><fmt:formatNumber value='${o.preco}' type='currency'/></td>
                <td><c:out value='${o.descricaoPublica}'/></td>
                <td>Privada (requer locação)</td>
                <td>${dates:format(o.criadoEm)}</td>
            </tr>
        </c:forEach>
        <c:if test='${empty obras}'>
            <tr><td colspan='8'>Nenhuma obra cadastrada ainda.</td></tr>
        </c:if>
        </tbody>
    </table>
    <script src='${pageContext.request.contextPath}/js/masks.js'></script>
</main>
