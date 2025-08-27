<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <meta charset="UTF-8" />
    <h2>Catálogo de Obras (Listagem)</h2>
    <c:if test='${pageContext.request.isUserInRole("ROLE_LOCADOR") or pageContext.request.isUserInRole("ROLE_ADMIN")}'>
        <p><a href="<c:url value='/catalogo/obras/gerenciar'/>">Ir para gestão de obras</a></p>
    </c:if>

    <style>
        /* local helpers only; table visuals from global style.css */
    </style>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>ISBN</th>
            <th>Título</th>
            <th>Autor</th>
            <th>Preço</th>
            <th>Público</th>
            <th>Desc Pública</th>
            <th>Privada?</th>
            <th>Criado</th>
        </tr>
        </thead>
        <tbody>
    <fmt:setLocale value="pt_BR"/>
    <c:forEach items="${obras}" var="o">
<head>
            <tr>
                <td><c:out value='${o.id}'/></td>
                <td><c:out value='${o.isbn}'/></td>
                <td><c:out value='${o.titulo}'/></td>
                <td><c:out value='${o.autor}'/></td>
                <td><fmt:formatNumber value='${o.preco}' type='currency'/></td>
                <td><c:out value='${o.publico}'/></td>
                <td><c:out value='${o.descricaoPublica}'/></td>
                <td>Privada (requer locação)</td>
                <td>${dates:format(o.criadoEm)}</td>
            </tr>
        </c:forEach>
        <c:if test='${empty obras}'>
            <tr><td colspan='7'>Nenhuma obra cadastrada ainda.</td></tr>
        </c:if>
        </tbody>
    </table>
</main>
<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</body>
<html lang="pt-BR">
<head>
        <meta charset="UTF-8" />
</head>
    <nav class="app-nav">
        <div class="app-nav-left">
            <span class="app-brand">Locadora dunnas</span>
            <a href='<c:url value="/home"/>'>Catálogo</a>
            <c:if test='${pageContext.request.isUserInRole("ROLE_LOCADOR") || pageContext.request.isUserInRole("ROLE_ADMIN") }'>
                <a href="<c:url value='/catalogo/obras/gerenciar'/>">Gestão de Obras</a>
            </c:if>
        </div>
        <div class="app-nav-right">
            <span style="font-size:15px;color:#444;">${username}</span>
            <form action="<c:url value='/logout'/>" method="post" style="display:inline">
                <c:if test="${_csrf != null}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>
                <button type="submit" class="btn btn-secondary">Sair</button>
            </form>
        </div>
    </nav>
<jsp:include page="header.jsp"/>
<main class="container" style="margin-top:32px;">
        <h2>Catálogo de Obras (Listagem)</h2>
        <c:if test='${pageContext.request.isUserInRole("ROLE_LOCADOR") or pageContext.request.isUserInRole("ROLE_ADMIN")}'><p><a href="<c:url value='/catalogo/obras/gerenciar'/>">Ir para gestão de obras</a></p></c:if>
        <table>
                <thead>
                <tr>
                        <th>ID</th>
                        <th>ISBN</th>
                        <th>Título</th>
                        <th>Autor</th>
                        <th>Preço</th>
                        <th>Público</th>
                        <th>Desc Pública</th>
                        <th>Privada?</th>
                        <th>Criado</th>
<body style="background:#f4f6fa;">
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
                                <td><c:out value='${o.publico}'/></td>
                                <td><c:out value='${o.descricaoPublica}'/></td>
                                <td>Privada (requer locação)</td>
                                <td>${dates:format(o.criadoEm)}</td>
                        </tr>
                </c:forEach>
                <c:if test='${empty obras}'>
                        <tr><td colspan='7'>Nenhuma obra cadastrada ainda.</td></tr>
                </c:if>
                </tbody>
        </table>
</main>
<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</body>
</html>
