<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Extrato</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body style="background:#f4f6fa;">
<jsp:include page="header.jsp"/>

<main class="container" style="margin-top:32px;">

<h2 style="margin-bottom: 8px;">Extrato Financeiro</h2>
<fmt:setLocale value="pt_BR"/>
<div style="display: flex; flex-wrap: wrap; align-items: center; gap: 18px; margin-bottom: 18px;">
  <div style="font-size:15px; color:#444; background:#f3f4f6; padding:8px 18px; border-radius:6px;">
    <b>${username}</b> | Saldo Atual: <fmt:formatNumber value='${saldo}' type='currency'/>
  </div>
  <form method="post" action="${pageContext.request.contextPath}/locacoes/recarga" style="display: flex; gap: 8px; align-items: center; margin:0;">
    <input type="text" class="money-mask" name="valor" required placeholder="Valor" style="width:110px;"/>
    <select name="tipo" style="min-width:120px;">
      <option value="PIX">PIX</option>
      <option value="CARTAO_CREDITO">Cartão Crédito</option>
      <option value="CARTAO_DEBITO">Cartão Débito</option>
      <option value="TRANSFERENCIA">Transferência</option>
    </select>
    <input type="hidden" name="_csrf" value="${_csrf.token}" />
    <button type="submit" class="btn btn-primary">Recarregar</button>
  </form>
</div>
<c:if test='${not empty erro}'><div class="alert alert-danger">${erro}</div></c:if>
<c:if test='${not empty msg}'><div class="alert alert-success">${msg}</div></c:if>

<h3>Pagamentos de Locações</h3>
  <style>
  /* table visuals provided by global style.css */
  </style>
<table>
 <tr><th>Data</th><th>Locação</th><th>Tipo</th><th>Valor</th></tr>
 <c:forEach items='${movs}' var='m'>
   <tr>
  <td>${dates:format(m.criadaEm)}</td>
  <td>${m.locacao.id} <c:if test="${not empty m.locacao.obra}">- <c:out value="${m.locacao.obra.titulo}"/></c:if></td>
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

<script src='${pageContext.request.contextPath}/js/masks.js'></script>
</main>
</body>
</html>