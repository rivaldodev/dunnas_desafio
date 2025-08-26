<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<html><head><title>Histórico de Locações (Locador)</title></head>
<body>
<h2>Histórico de Locações - Eu como Locador</h2>
<p>Usuário: ${username}</p>
<table border='1'>
 <tr><th>ID</th><th>Obra</th><th>Cliente</th><th>Status</th><th>Iniciada</th><th>Devolvida</th><th>Sinal</th><th>Restante</th><th>Valor Total</th></tr>
 <fmt:setLocale value="pt_BR"/>
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
</table>
<a href='${pageContext.request.contextPath}/home'>Home</a>
<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</body></html>
