<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><head><title>Minhas Locações</title></head>
<body>
<h2>Minhas Locações Ativas</h2>
<p>Usuário: ${username} | Saldo: <c:out value="${saldo}"/></p>
<c:if test="${not empty erro}"><div style="color:red">${erro}</div></c:if>
<c:if test="${not empty msg}"><div style="color:green">${msg}</div></c:if>
<table border="1">
<tr><th>ID</th><th>Obra</th><th>ISBN</th><th>Status</th><th>Total</th><th>Sinal (50%)</th><th>Restante</th><th>Pagamentos</th><th>Ações</th></tr>
<c:forEach items="${locacoes}" var="l">
    <tr>
        <td>${l.id}</td>
        <td>${l.obra.titulo}</td>
    <td>${l.obra.isbn}</td>
    <td>${l.status}</td>
        <td>${l.valorTotal}</td>
        <td><c:out value="${(l.valorTotal * 0.5)}"/></td>
        <td><c:out value="${(l.valorTotal - (l.valorTotal * 0.5))}"/></td>
        <td>Sinal: <b><c:out value="${l.sinalPago ? 'OK' : 'PENDENTE'}"/></b><br/>Restante: <b><c:out value="${l.restantePago ? 'OK':'PENDENTE'}"/></b></td>
        <td>
            <c:if test="${l.status != 'FINALIZADA'}">
                <form style="display:inline" method="post" action="${pageContext.request.contextPath}/locacoes/finalizar">
                    <input type="hidden" name="locacaoId" value="${l.id}" />
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                    <button type="submit">Finalizar / Devolver</button>
                </form>
            </c:if>
            <form style="display:inline" method="get" action="${pageContext.request.contextPath}/obras/${l.obra.id}/privada">
                <button type="submit">Acessar descrição privada</button>
            </form>
        </td>
    </tr>
</c:forEach>
</table>
<a href="${pageContext.request.contextPath}/home">Home</a>
</body></html>
