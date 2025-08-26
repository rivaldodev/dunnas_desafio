<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Entrar</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body class="login-page">
<div class="login-box">
    <h1>Acesso</h1>
    <form action="<c:url value='/login' />" method="post">
        <div>
            <label for="username">Usuário</label>
            <input id="username" name="username" type="text" autofocus required />
        </div>
        <div>
            <label for="password">Senha</label>
            <input id="password" name="password" type="password" required />
        </div>
        <c:if test="${_csrf != null}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </c:if>
        <div>
            <button type="submit">Entrar</button>
        </div>
        <c:if test="${param.error != null}">Credenciais inválidas</c:if>
        <c:if test="${param.logout != null}">Sessão encerrada</c:if>
    </form>
</div>
</body>
</html>
