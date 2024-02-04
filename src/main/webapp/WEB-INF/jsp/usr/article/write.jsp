<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<%@ include file="../common/toastUi.jsp"%>

<section class="">
	<form action="doWrite" method="post" onsubmit="submitForm(this); return false;">
		<textarea name="body" class="hidden"></textarea>
		<div>
			<span>제목</span> <input name="title" placeholder="제목을 입력해주세요" type="text">
		</div>
		<div>
			<span>내용</span>
			<div id="editor" class="toast-ui-editor">
				<script type="text/x-template"></script>
			</div>
		</div>
		<div>
			<button>작성</button>
		</div>
	</form>
</section>

<%@ include file="../common/footer.jsp"%>