<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<%@ include file="../common/toastUi.jsp"%>

<section class="h-body mx-auto max-w-4xl">
	<form action="doModify" method="post" onsubmit="submitForm(this); return false;">
		<input name="id" type="hidden" value="${article.id }" />
		<textarea name="body" class="hidden">${article.body }</textarea>
		
		<div class="flex">
			<div>
				<span>제목</span> <input name="title" placeholder="제목을 입력해주세요" type="text" value="${article.title }">
			</div>
			<div>
				<select readonly name="boardId" id="select-board" class="select select-bordered select-sm text-base mx-1">
					<c:forEach var="board" items="${boards }" begin="${rq.loginedMemberId == 1 ? 1 : 2 }">
						<option value="${board.id }" ${boardId == board.id ? 'selected' : '' }>${board.name }</option>
					</c:forEach>
				</select>
			</div>
		</div>
		
		<div>
			<span>내용</span>
			<div id="editor" class="toast-ui-editor">
				<script type="text/x-template">
					
				</script>
			</div>
		</div>
		<div>
			<button>작성</button>
		</div>
	</form>
</section>


<%@ include file="../common/footer.jsp"%>