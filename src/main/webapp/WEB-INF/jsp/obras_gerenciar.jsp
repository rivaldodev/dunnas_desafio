<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="dates" uri="http://dunnas/desafio/dates" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Gerenciar Obras</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />" />
</head>
<body>
<jsp:include page="header.jsp"/>
<main class="container" style="margin-top:32px;">
    <h2>Gerenciar Obras</h2>
    <div class="flex" style="gap:16px;margin-bottom:8px;align-items:center;">
        <h3 style="margin:0;">Adicionar Obra</h3>
        <button type="button" class="btn btn-primary btn-sm" onclick="document.getElementById('modalObra').style.display='flex'">Nova Obra</button>
    </div>
    <!-- Modal para cadastro de nova obra -->
    <div id="modalObra" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.25);z-index:1000;align-items:center;justify-content:center;">
        <div style="background:#fff;padding:32px 28px 18px 28px;border-radius:10px;max-width:400px;width:96vw;box-shadow:0 2px 16px rgba(0,0,0,0.13);position:relative;">
            <h3 style="margin-top:0;">Cadastrar Nova Obra</h3>
            <form method="post" action="${pageContext.request.contextPath}/catalogo/obras/gerenciar">
                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                <div style="margin-bottom:10px;">
                    <label for="titulo" style="font-size:13px;">Título</label>
                    <input type="text" name="titulo" id="titulo" required style="width:100%;padding:7px;" />
                </div>
                <div style="margin-bottom:10px;">
                    <label for="isbn" style="font-size:13px;">ISBN</label>
                    <input type="text" name="isbn" id="isbn" required style="width:100%;padding:7px;" />
                </div>
                <div style="margin-bottom:10px;">
                    <label for="autor" style="font-size:13px;">Autor</label>
                    <input type="text" name="autor" id="autor" required style="width:100%;padding:7px;" />
                </div>
                <div style="margin-bottom:10px;">
                    <label for="preco" style="font-size:13px;">Preço</label>
                    <input type="text" class="money-mask" name="preco" id="preco" required style="width:100%;padding:7px;" placeholder="R$ 0,00" />
                </div>
                <div style="margin-bottom:10px;">
                    <label for="descricaoPublica" style="font-size:13px;">Descrição Pública</label>
                    <textarea name="descricaoPublica" id="descricaoPublica" rows="2" style="width:100%;padding:7px;"></textarea>
                </div>
                <div style="margin-bottom:10px;">
                    <label for="descricaoPrivada" style="font-size:13px;">Descrição Privada</label>
                    <textarea name="descricaoPrivada" id="descricaoPrivada" rows="2" style="width:100%;padding:7px;"></textarea>
                </div>
                <div style="display:flex;gap:10px;justify-content:flex-end;">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="document.getElementById('modalObra').style.display='none'">Cancelar</button>
                    <button type="submit" class="btn btn-primary btn-sm">Salvar</button>
                </div>
            </form>
        </div>
    </div>
    <script src='${pageContext.request.contextPath}/js/masks.js'></script>
    <script>
        // Fecha modal ao clicar fora
        document.addEventListener('click', function(e){
            var modal = document.getElementById('modalObra');
            if(modal && modal.style.display!=='none' && !modal.firstElementChild.contains(e.target) && e.target.type!=="button"){
                modal.style.display='none';
            }
        });
    </script>

        <h3>Obras Cadastradas</h3>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>ISBN</th>
                <th>Título</th>
                <th>Autor</th>
                <th>Preço</th>
                <th>Desc Pública</th>
                <th>Privada?</th>
                <th>Criado</th>
            </tr>
            </thead>
            <tbody>
            <fmt:setLocale value="pt_BR"/>
            <c:forEach items="${obras}" var="o">
                <tr>
                    <td><c:out value='${o.id}'/></td>
                    <td><c:out value='${o.isbn}'/></td>
                    <td><c:out value='${o.titulo}'/></td>
                    <td><c:out value='${o.autor}'/></td>
                    <td><fmt:formatNumber value='${o.preco}' type='currency'/></td>
                    <td><c:out value='${o.descricaoPublica}'/></td>
                    <td>Privada (requer locação)</td>
                    <td>${dates:format(o.criadoEm)}</td>
                </tr>
            </c:forEach>
            <c:if test='${empty obras}'>
                <tr><td colspan='8'>Nenhuma obra cadastrada ainda.</td></tr>
            </c:if>
            </tbody>
        </table>
</main>
</body>
</html>
