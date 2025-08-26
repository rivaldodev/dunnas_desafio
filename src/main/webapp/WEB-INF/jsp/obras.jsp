<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <h2>Catálogo de Obras (Listagem)</h2>
    <c:if test='${pageContext.request.isUserInRole("ROLE_LOCADOR") or pageContext.request.isUserInRole("ROLE_ADMIN")}'>
        <p><a href="<c:url value='/catalogo/obras/gerenciar'/>">Ir para gestão de obras</a></p>
    </c:if>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>ISBN</th>
            <th>Título</th>
            <th>Autor</th>
            <th>Preço</th>
            <th>Público</th>
            <th>Desc Pública</th>
            <th>Privada?</th>
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
                <td><c:out value='${o.descricaoPublica}'/></td>
                <td>Privada (requer locação)</td>
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
