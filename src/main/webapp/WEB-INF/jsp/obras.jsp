<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Catálogo de Obras</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 6px; font-size: 14px; }
        th { background: #f4f4f4; text-align: left; }
        tbody tr:hover { background:#fafafa; }
        form.inline { display:inline; }
        .erro { color:#b00; font-size:12px; }
        fieldset { border:1px solid #ccc; padding:10px; margin-bottom:16px; }
        fieldset legend { font-size:14px; font-weight:bold; }
        label { display:block; margin-top:6px; font-size:12px; text-transform:uppercase; }
        input[type=text], input[type=number] { width:280px; max-width:100%; padding:4px; }
    </style>
</head>
<body>
<header>
    <nav>
        <span>${username}</span>
        <a href="<c:url value='/'/>">Home</a>
        <form action="<c:url value='/logout'/>" method="post" style="display:inline">
            <c:if test="${_csrf != null}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <button type="submit">Sair</button>
        </form>
    </nav>
</header>
<main>
    <h2>Catálogo de Obras</h2>
    <fieldset>
        <legend>Nova Obra</legend>
        <form action="" method="post">
            <c:if test="${_csrf != null}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <label>ISBN
                <input type="text" name="isbn" value="${form.isbn}" required maxlength="20" />
            </label>
            <c:if test='${not empty errors and errors["isbn"] != null}'><div class='erro'>${errors["isbn"]}</div></c:if>
            <label>Título
                <input type="text" name="titulo" value="${form.titulo}" required maxlength="200" />
            </label>
            <label>Autor
                <input type="text" name="autor" value="${form.autor}" maxlength="160" />
            </label>
            <label>Preço
                <input type="number" min="0.01" step="0.01" name="preco" value="${form.preco}" required />
            </label>
            <label>
                <input type="checkbox" name="publico" <c:if test='${form.publico}'>checked</c:if> /> Público
            </label>
            <div style="margin-top:8px;">
                <button type="submit">Salvar</button>
            </div>
        </form>
    </fieldset>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>ISBN</th>
            <th>Título</th>
            <th>Autor</th>
            <th>Preço</th>
            <th>Público</th>
            <th>Criado</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${obras}" var="o">
            <tr>
                <td><c:out value='${o.id}'/></td>
                <td><c:out value='${o.isbn}'/></td>
                <td><c:out value='${o.titulo}'/></td>
                <td><c:out value='${o.autor}'/></td>
                <td><c:out value='${o.preco}'/></td>
                <td><c:out value='${o.publico}'/></td>
                <td><c:out value='${o.criadoEm}'/></td>
            </tr>
        </c:forEach>
        <c:if test='${empty obras}'>
            <tr><td colspan='7'>Nenhuma obra cadastrada ainda.</td></tr>
        </c:if>
        </tbody>
    </table>
</main>
</body>
</html>
