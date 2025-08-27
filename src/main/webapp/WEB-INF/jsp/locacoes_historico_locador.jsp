<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Histórico de Locações (Locador)</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body style="background:#f4f6fa;">
<jsp:include page="header.jsp"/>
<main class="container" style="margin-top:32px;">
<h2>Histórico de Locações - Eu como Locador</h2>
<p>Usuário: ${username}</p>
<!-- table visuals are provided by global /css/style.css; removed inline rules to standardize grids -->
<fmt:setLocale value="pt_BR"/>
<table>
  <thead>
    <tr>
      <th>ID</th>
      <th>Obra</th>
      <th>Cliente</th>
      <th>Status</th>
      <th>Iniciada</th>
      <th>Devolvida</th>
      <th>Sinal</th>
      <th>Restante</th>
      <th>Valor Total</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach items='${locacoes}' var='l'>
      <tr>
        <td>${l.id}</td>
        <td>${l.obra.titulo}</td>
        <td>${l.cliente.nome}</td>
        <td>${l.status}</td>
        <td>${dates:format(l.iniciadaEm)}</td>
        <td><c:if test='${l.devolvidaEm != null}'>${dates:format(l.devolvidaEm)}</c:if></td>
        <td><c:out value='${l.sinalPago?"OK":"PEND"}'/></td>
        <td><c:out value='${l.restantePago?"OK":"PEND"}'/></td>
        <td><fmt:formatNumber value='${l.valorTotal}' type='currency'/></td>
      </tr>
    </c:forEach>

    <c:if test='${empty locacoes}'>
      <tr><td colspan='9'>Nenhuma locação ainda.</td></tr>
    </c:if>
  </tbody>
</table>
<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</main>
</body>
</html>
