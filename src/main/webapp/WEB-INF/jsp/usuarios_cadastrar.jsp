<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastrar Usuário</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body class="login-page">
<div class="login-box">
    <h2 style="margin-top:0; font-size:20px; text-align:center;">Cadastrar Usuário</h2>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>
    <c:if test="${not empty erro}">
        <div class="alert alert-danger">${erro}</div>
    </c:if>
    <form:form method="post" modelAttribute="usuario">
        <div style="margin-bottom:12px;">
            <label for="nome">Nome</label>
            <form:input path="nome" cssClass="form-control" id="nome"/>
            <form:errors path="nome" cssClass="text-danger"/>
        </div>
        <div style="margin-bottom:12px;">
            <label for="email">E-mail</label>
            <form:input path="email" cssClass="form-control" id="email"/>
            <form:errors path="email" cssClass="text-danger"/>
        </div>
        <div style="margin-bottom:12px;">
            <label for="senha">Senha</label>
            <form:password path="senha" cssClass="form-control" id="senha"/>
            <form:errors path="senha" cssClass="text-danger"/>
        </div>
        <div style="margin-bottom:12px; display: flex; flex-direction: column;">
            <label for="tipo">Tipo</label>
            <form:select path="tipo" cssClass="form-control" id="tipo" style="width:100%;padding:8px;">
                <form:options items="${tipos}"/>
            </form:select>
            <form:errors path="tipo" cssClass="text-danger"/>
        </div>
    <button type="submit" class="btn btn-primary" style="width:100%;">Cadastrar</button>
    </form:form>
    <div style="margin-top: 16px; text-align: center;">
    <a href="<c:url value='/'/>" class="btn btn-secondary" style="width:100%;text-align:center;">Voltar</a>
    </div>
</div>
</body>
</html>
