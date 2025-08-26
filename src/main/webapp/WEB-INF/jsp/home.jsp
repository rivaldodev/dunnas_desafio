<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Home</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body>
<header>
    <nav>
        <span>${username}</span>
        <form action="<c:url value='/logout'/>" method="post" style="display:inline">
            <c:if test="${_csrf != null}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <button type="submit">Sair</button>
        </form>
    </nav>
</header>
<main>
    <h2>Bem vindo</h2>
</main>
</body>
</html>
