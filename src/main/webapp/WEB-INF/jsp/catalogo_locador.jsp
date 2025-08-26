<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Meu Catálogo</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
    <style>
        table { border-collapse: collapse; width:100%; margin-top: 16px; }
        th, td { border:1px solid #ddd; padding:6px; font-size:14px; }
        th { background:#f4f4f4; }
        .erro { color:#b00; font-size:12px; }
        form.inline { display:inline; }
        .flex { display:flex; gap:12px; align-items:flex-end; }
        label { display:block; font-size:12px; text-transform:uppercase; letter-spacing: .5px; }
        select, input[type=number] { padding:4px; }
    </style>
</head>
<body>
<header>
    <nav>
        <span>${username}</span>
        <a href="<c:url value='/'/>">Home</a>
        <a href="<c:url value='/catalogo/obras' />">Obras</a>
        <form action="<c:url value='/logout'/>" method="post" style="display:inline">
            <c:if test="${_csrf != null}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <button type="submit">Sair</button>
        </form>
    </nav>
</header>
<main>
    <h2>Meu Catálogo (Locador)</h2>

    <h3>Adicionar Obra</h3>
    <form action="" method="post" class="flex">
        <c:if test="${_csrf != null}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </c:if>
        <div>
            <label for="obraId">Obra</label>
            <select name="obraId" id="obraId" required>
                <option value="">-- escolha --</option>
                <c:forEach items='${obras}' var='o'>
                    <option value='${o.id}' <c:if test='${form.obraId == o.id}'>selected</c:if>>${o.titulo} (${o.isbn})</option>
                </c:forEach>
            </select>
            <c:if test='${not empty errors and errors["obraId"] != null}'>
                <div class='erro'>${errors["obraId"]}</div>
            </c:if>
        </div>
        <div>
            <label for="estoque">Estoque</label>
            <input type="number" min="0" name="estoque" id="estoque" value='${form.estoque}' required />
            <c:if test='${not empty errors and errors["estoque"] != null}'>
                <div class='erro'>${errors["estoque"]}</div>
            </c:if>
        </div>
        <div>
            <button type="submit">Adicionar</button>
        </div>
    </form>

    <h3>Itens</h3>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Obra</th>
            <th>Estoque</th>
            <th>Criado</th>
        </tr>
        </thead>
        <tbody>
    <fmt:setLocale value="pt_BR"/>
    <c:forEach items='${itens}' var='i'>
            <tr>
                <td>${i.id}</td>
                <td>${i.obra.titulo} (${i.obra.isbn})</td>
                <td>${i.estoque}</td>
                <td>${dates:format(i.criadoEm)}</td>
            </tr>
        </c:forEach>
        <c:if test='${empty itens}'>
            <tr><td colspan='4'>Nenhuma obra no catálogo ainda.</td></tr>
        </c:if>
        </tbody>
    </table>
</main>
</body>
</html>
