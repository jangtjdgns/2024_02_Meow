<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<%@ include file="../common/toastUi.jsp"%>

<section class="h-body mx-auto max-w-4xl">
	<form action="doWrite" method="post"
		onsubmit="submitForm(this); return false;">
		<textarea name="body" class="hidden"></textarea>
		<div class="flex">
			<div>
				<span>제목</span>
				<input name="title" class="input input-bordered input-sm" placeholder="제목을 입력해주세요" type="text">
			</div>
			<div>
				<select name="boardId" id="select-board" class="select select-bordered select-sm text-base mx-1">
					<c:forEach var="board" items="${boards }" begin="${rq.loginedMemberId == 1 ? 1 : 2 }">
						<option value="${board.id }" ${board.id == 2 ? 'selected' : '' }>${board.name }</option>
					</c:forEach>
				</select>
			</div>
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