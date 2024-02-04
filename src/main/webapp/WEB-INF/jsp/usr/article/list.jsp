<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

  
<section>
	<c:forEach var="article" items="${articles }">
		<div>${article.id }</div>
		<div>${article.regDate }</div>
		<div>${article.updateDate }</div>
		<div><a href="detail?id=${article.id }">${article.title }</a></div>
		<div class="border-b"></div>
	</c:forEach>
	
	<a href="write" class="btn">글작성</a>
</section>

<%@ include file="../common/footer.jsp"%>