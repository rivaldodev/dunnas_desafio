<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><head><title>Erro</title></head><body style="background:#f4f6fa;">

<header class="app-header">
	<nav class="app-nav">
		<div class="app-nav-left">
			   <span class="app-brand">Locadora dunnas</span>
		</div>
	</nav>
</header>
	<nav class="app-nav">
		<div class="app-nav-left">
			   <span class="app-brand">Locadora dunnas</span>
			<a href='${pageContext.request.contextPath}/home'>Home</a>
		</div>
	</nav>
</header>
<main class="container" style="margin-top:32px;">
	<h2>Ocorreu um erro</h2>
	<p>Tente novamente ou volte para a <a href="${pageContext.request.contextPath}/home">Home</a>.</p>
</main>
</body>
</html>
