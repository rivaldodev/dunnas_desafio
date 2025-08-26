<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<html><head><title>Extrato</title></head>
<body>
<h2>Extrato Financeiro</h2>
<fmt:setLocale value="pt_BR"/>
<p>Usuário: ${username} | Saldo Atual: <b><fmt:formatNumber value='${saldo}' type='currency'/></b></p>
<c:if test='${not empty erro}'><div style='color:red'>${erro}</div></c:if>
<c:if test='${not empty msg}'><div style='color:green'>${msg}</div></c:if>

<h3>Recarga de Saldo</h3>
<form method="post" action="${pageContext.request.contextPath}/locacoes/recarga">
  <label>Valor: <input type="text" class="money-mask" name="valor" required></label>
  <label>Tipo: <select name="tipo">
    <option value="PIX">PIX</option>
    <option value="CARTAO_CREDITO">Cartão Crédito</option>
    <option value="CARTAO_DEBITO">Cartão Débito</option>
    <option value="TRANSFERENCIA">Transferência</option>
  </select></label>
  <input type="hidden" name="_csrf" value="${_csrf.token}" />
  <button type="submit">Recargar</button>
 </form>

<h3>Pagamentos de Locações</h3>
<table border='1'>
 <tr><th>Data</th><th>Locação</th><th>Tipo</th><th>Valor</th></tr>
 <c:forEach items='${movs}' var='m'>
   <tr>
  <td>${dates:format(m.criadaEm)}</td>
     <td>${m.locacao.id}</td>
     <td>${m.tipo}</td>
  <td><fmt:formatNumber value='${m.valor}' type='currency'/></td>
   </tr>
 </c:forEach>
</table>

<h3>Recargas</h3>
<table border='1'>
 <tr><th>Data</th><th>Tipo</th><th>Valor</th></tr>
 <c:forEach items='${recargas}' var='r'>
   <tr>
  <td>${dates:format(r.criadaEm)}</td>
     <td>${r.tipo}</td>
  <td><fmt:formatNumber value='${r.valor}' type='currency'/></td>
   </tr>
 </c:forEach>
</table>

<a href='${pageContext.request.contextPath}/home'>Home</a>
<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</body></html>