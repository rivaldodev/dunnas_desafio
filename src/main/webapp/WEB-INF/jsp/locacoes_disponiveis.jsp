<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><head><title>Obras Disponíveis</title></head>
<body>
<h2>Obras Disponíveis para Locação</h2>
<p>Usuário: ${username} | Saldo: <c:out value="${saldo}"/></p>
<c:if test="${not empty erro}"><div style="color:red">${erro}</div></c:if>
<c:if test="${not empty msg}"><div style="color:green">${msg}</div></c:if>
<form method="get" action="${pageContext.request.contextPath}/locacoes/disponiveis">
    <input type="text" name="q" value="${q}" placeholder="Filtrar por título ou ISBN" />
    <button type="submit">Filtrar</button>
</form>
<form method="post" action="${pageContext.request.contextPath}/locacoes">
    <label>Catalogo ID: <input type="number" name="catalogoId" required/></label>
    <button type="submit">Iniciar Locação</button>
    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
</form>
<table border="1">
<tr><th>ID Catalogo</th><th>Locador</th><th>Obra</th><th>ISBN</th><th>Preço</th><th>Estoque</th></tr>
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
<a href="${pageContext.request.contextPath}/home">Home</a>
</body></html>
