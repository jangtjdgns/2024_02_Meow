<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>
<%@ include file="../common/toastUi.jsp"%>

<section class="b-mh mw border-t pb-40">
	<div class="mx-auto [max-width:1024px]">
		<div class="text-3xl pt-16 pb-6">
			<div class="inline-block py-4">게시글 작성</div>
		</div>
		
		<form action="doWrite" method="post" onsubmit="submitForm(this); return false;">
			<textarea name="body" id="body" class="hidden"></textarea>
			
			<!-- 제목 -->
			<div class="grid w-full" style="grid-template-columns:1fr 836px">
				<div class="bg-gray-50 w-full h-full flex items-center justify-center border-b-2 border-white py-4 rounded-tl-lg">제목</div>
				<div class="w-full p-1 border-2 border-l-0 [border-color:#F9FAFB] rounded-tr-lg">
					<input name="title" class="input input-sm w-full h-full focus:outline-none focus:border-0" placeholder="제목을 입력해주세요" type="text" minlength="2" maxlength="50" autocomplete="off" />
				</div>
			</div>
			
			<!-- 게시판 -->
			<div class="grid w-full" style="grid-template-columns:1fr 836px">
				<div class="bg-gray-50 w-full h-full flex items-center justify-center border-b-2 border-white py-4">게시판</div>
				<div class="w-full p-1 border-r-2 [border-color:#F9FAFB] flex justify-between">
					<select name="boardId" id="select-board" class="select select-sm focus:outline-none w-24 h-full">
						<c:forEach var="board" items="${boards }" begin="${rq.loginedMemberId == 1 ? 1 : 2 }">
							<option value="${board.id }" ${board.id == 2 ? 'selected' : '' }>${board.name }</option>
						</c:forEach>
					</select>
					<span class="text-xs text-red-600">* 게시글 작성후 게시판 수정은 불가능 합니다.</span>
				</div>
			</div>
			
			<!-- 내용 -->
			<div class="grid w-full" style="grid-template-columns:1fr 836px">
				<div class="bg-gray-50 w-full h-full flex flex-col items-center justify-center rounded-bl-lg">
					<div>내용</div>
					<div class="text-xs text-blue-600">(사이즈: 784 * n)</div>
				</div>
				<div id="editor" class="toast-ui-editor [width:836px] rounded-br-lg">
					<script type="text/x-template"></script>
				</div>
			</div>
			
			<!-- 버튼 -->
			<div class="grid gap-2 py-2 justify-right" style="grid-template-columns:1fr 836px">
				<div></div>
				<div class="text-right">
					<button class="btn btn-sm w-16 h-10">작성</button>
					<button type="button" class="btn btn-sm w-16 h-10" onclick="history.back();">취소</button>
				</div>
			</div>
		</form>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>