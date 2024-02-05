<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../common/header.jsp"%>

<%@ include file="../common/toastUi.jsp"%>

<section class="h-body mx-auto max-w-4xl">
	<textarea id="body" class="hidden">${article.body}</textarea>
	<div>${article.id }</div>
	<div>${article.regDate }</div>
	<div>${article.updateDate }</div>
	<div>${article.title }</div>
	<div id="viewer"></div>
	
	<div>
		<a href="doDelete?id=${article.id }" class="btn">삭제</a>
		<a href="modify?id=${article.id }" class="btn">수정</a>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>