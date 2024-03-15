<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../common/header.jsp"%>
<%@ include file="../common/toastUi.jsp"%>

<script>
	// 댓글 가져오기
	function getReplies() {
		$.ajax({
	        url: "../reply/getReplies",
	        method: "GET",
	        data: {
	        	"relId": $("#relId").val(),
	        },
	        success: function(data) {
	        	if(data.success) {
	        		$("#replies").text("");
	        		
					const replies = data.data;
					
		        	for(let i = 0; i < replies.length; i++) {
		        		const operationBtn = `
							<div class="dropdown dropdown-end">
								<button class="btn btn-circle btn-ghost btn-sm">
							    	<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-5 h-5 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path></svg>
							    </button>
						    	<ul tabindex="0" class="z-[1] p-2 shadow menu menu-sm dropdown-content bg-base-100 rounded-box w-20">
						    		<li><button onclick="replyModifyGetForm(\${replies[i].id});">수정</button></li>
						    		<li><button onclick="replyDoDelete(\${replies[i].id})">삭제</button></li>
						    	</ul>
						    </div>
					    `;
					    
		        		$("#replies").append(`
	        				<div class="flex justify-between border-b py-4" style="min-height: 144px;">
								<div class="avatar px-2">
									<div class="w-10 h-10 rounded-full">
										<img src=\${replies[i].profileImage != null ? replies[i].profileImage : 'http://placehold.it/50x50'} />
									</div>
								</div>
								<div class="w-full px-2">
									<div>
										<span class="font-bold">\${replies[i].writerName }</span>
										<span>| \${replies[i].formatRegDate }</span>
									</div>
									<div id="reply-\${replies[i].id }" class="p-1.5">\${replies[i].convertNToBr }</div>			
								</div>
								
								\${loginedMemberId == replies[i].memberId ? operationBtn : ''}
							</div>
		        		`);
		        	}
		        	$("#replyCnt").text(replies.length);
	        	}
	        },
	        error: function(xhr, status, error) {
	            console.error("ERROR : " + status + " - " + error);
	        }
	    });
	}
	
	//댓글 작성 및 수정
	const replyFormOnSubmit = function(form){
		form.body.value = form.body.value.trim();
		
		if(form.body.value.length < 2) {
			alertMsg('2글자 이상 입력해주세요', "error");
			form.body.focus();
			return;
		}
		
		if(form.body.value.length > 300) {
			alertMsg('최대 300글자까지 입력가능 합니다.', "error");
			form.body.focus();
			return;
		}
		
		$.ajax({
	        url: form.action,
	        method: "POST",
	        data: $(form).serialize(), // 폼 데이터 직렬화 (jquery에서 지원하는 메서드)
	        success: function(data) {
	        	if(data.success) {
	        		alertMsg(data.msg, "success");
		        	$("#replyInput").val("");
		        	getReplies();
	        	} else {
	        		alertMsg(data.msg, "error");
	        	}
	        },
	        error: function(xhr, status, error) {
	            console.error("ERROR : " + status + " - " + error);
	        }
	    });
	}
	
	/* 댓글 수정 폼 생성 */
	// 전역 변수
	let originalForm = null;		// 댓글 수정 전의 form 백업용
	let originalId = null;			// 댓글 수정 전의 댓글 id 백업용
	// 댓글 수정 form 생성 함수
	const replyModifyGetForm = function(replyId){
		
		if (originalForm != null) {				// 백업용 originalForm 변수가 null이 아닌경우, 어떠한 댓글이 백업 되있는 경우
			replyModifyCancle(originalId);		// 수정 취소, 여기선 초기화 용도
		}
		
		$.ajax({
			url : "../reply/getReplyContent",
			method : "get",
			data : {
				"id" : replyId
			},
			dataType : "json",
			success : function(data){
				
				const reply = data.data;
				
				let replyContent = $('#reply-' + replyId);
				
				originalId = replyId;
				originalForm = replyContent.html();
				
				let addHtml = `
					<form action="../reply/doModify" onsubmit="replyFormOnSubmit(this); return false;">
						<input type="hidden" name="id" value="\${reply.id }" />
						<input type="hidden" name="boardId" value="\${ $('#boardId').val() }" />
						<div class="mt-4">
							<textarea id="replyBody" name="body" class="textarea textarea-bordered w-full resize-none" placeholder="댓글을 입력해주세요.">\${reply.convertBrToN}</textarea>
							<div class="flex justify-end pt-2">
								<button class="btn btn-sm mr-1">수정</button>
								<button onclick="replyModifyCancle(\${reply.id});" class="btn btn-sm">취소</button>
							</div>
						</div>
					</form>
				`;
				
				replyContent.empty().html(addHtml);
			},
			error : function(xhr, status, error){
				console.error("ERROR : " + status + " - " + error);
			}
		})
	}
	
	// 수정 취소 함수
	const replyModifyCancle = function(replyId){
		let replyContent = $('#reply-' + replyId)
		
		replyContent.html(originalForm);
		
		originalId = null;
		originalForm = null;
	}
	
	
	// 댓글 삭제
	const replyDoDelete = function(replyId) {
		
		if(!confirm("댓글을 삭제하시겠습니까?")) return false;
		
		$.ajax({
	        url: "../reply/doDelete",
	        method: "GET",
	        data: {
	        	"id": replyId,
	        },
	        success: function(data) {
	        	if(data.success) {
	        		alertMsg(data.msg, "success");
		        	getReplies();
	        	} else {
	        		alertMsg(data.msg, "error");
	        	}
	        },
	        error: function(xhr, status, error) {
	            console.error("ERROR : " + status + " - " + error);
	        }
	    });
	}
	
	
	$(function(){
		getReplies();
	})
</script>

<section class="mw b-mh relative">
	<div class="border w-full [height:480px] absolute top-0 z-10">
		<img src="https://img.freepik.com/free-vector/cats-doodle-pattern-background_53876-100663.jpg?w=900&t=st=1710412076~exp=1710412676~hmac=a3b9244e4cb10307314db65461bb7052aa5e39285a4ff512399bfca4beb1a042" class="w-full h-full object-cover">
	</div>
	
	<div class="mx-auto max-w-4xl w-full bg-white p-14 absolute top-20 left-1/2 z-20 -translate-x-1/2 bg-opacity-95 rounded">
		<div class="pb-2 flex items-center justify-between">
			<div><a href="" class="text-blue-600 hover:font-bold">공지사항</a></div>
			<div class="text-sm flex justify-between gap-2">
				<div>
					<span class="text-xs"><i class="fa-regular fa-clock"></i></span>
					<span class="text-gray-600">${article.regDate }</span>
				</div>
				
				<div>
					<c:if test="${rq.loginedMemberId == article.memberId }">
						<div class="dropdown dropdown-bottom dropdown-end">
							<div tabindex="0" role="button" class="btn btn-xs btn-ghost btn-circle">
								<i class="fa-solid fa-gear text-gray-700"></i>
							</div>
							<ul tabindex="0" class="menu dropdown-content z-[1] p-2 [flex-direction:row] flex-nowrap items-center gap-1 mt-1 p-1 shadow rounded-xl bg-white">
								<li>
									<a href="modify?id=${article.id }&boardId=${boardId }" class="btn btn-sm btn-ghost w-8 text-green-600">
										<i class="fa-regular fa-pen-to-square"></i>
									</a>
								</li>
								<li>
									<a href="doDelete?id=${article.id }" class="btn btn-sm btn-ghost w-8 text-red-600" onclick="if(!confirm('정말 삭제하시겠습니까?')) return false;">
										<i class="fa-regular fa-trash-can"></i>
									</a>
								</li>
							</ul>
						</div>
					</c:if>
				</div>
			</div>
		</div>
		
		<div class="">
			<div class="text-3xl font-LINESeed pb-5">${article.title }</div>
			<textarea id="body" class="hidden">${article.body}</textarea>
			<div id="viewer" class="[min-height:30vh] mb-5"></div>
		</div>
		
		<!-- 댓글 -->
		<div class="w-full pt-4">
			<div class="border-b-2 pb-4">
				<div>댓글 (<span id="replyCnt">${article.replyCnt }</span>)</div>
				
				<!-- 댓글 입력 form -->
				<form action="../reply/doWrite" onsubmit="replyFormOnSubmit(this); return false;">
					<input type="hidden" id="relId" name="relId" value="${article.id }"/>
					<input type="hidden" name="relTypeCode" value="article"/>
					<input type="hidden" id="boardId" name="boardId" value="${article.boardId }" />
					<textarea name="body" id="replyInput" class="textarea textarea-bordered textarea-md w-full resize-none" placeholder="댓글을 입력해주세요." ${rq.loginedMemberId == 0 ? "disabled" : "" } ></textarea>
					<div class="flex justify-end pt-2">
						<button class="btn btn-sm w-20" ${rq.loginedMemberId == 0 ? "disabled" : "" }>작성</button>
					</div>
				</form>
			</div>
			
			<div id="replies" class="text-sm px-1.5">
				<c:forEach var="reply" items="${replies }">
					<div class="flex justify-between border-b py-4" style="min-height: 144px;">
						<div class="avatar px-2">
							<div class="w-10 h-10 rounded-full">
								<img src=${reply.profileImage != null ? reply.profileImage : 'http://placehold.it/50x50'} />
							</div>
						</div>
						<div class="w-full px-2">
							<div>
								<span class="font-bold">${reply.writerName }</span>
								<span>| ${reply.formatRegDate }</span>
							</div>
							<div id="${reply.id }" class="p-1.5">${reply.convertNToBr }</div>			
						</div>
						
						 <c:if test="${rq.loginedMemberId == reply.memberId }">
							<div class="dropdown dropdown-end">
								<button class="btn btn-circle btn-ghost btn-sm">
							    	<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-5 h-5 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path></svg>
							    </button>
						    	<ul tabindex="0" class="z-[1] p-2 shadow menu menu-sm dropdown-content bg-base-100 rounded-box w-24">
						    		<li><button onclick="replyModifyGetForm(${reply.id});">수정</button></li>
						    		<li><a href="../reply/doDelete?id=${reply.id }&boardId=${article.boardId}" onclick="if(!confirm('정말 삭제하시겠습니까?')) return false;">삭제</a></li>
						    	</ul>
						    </div>
						</c:if>
					</div>
				</c:forEach>
			</div>
		</div>
		
		<div>
			<a href="list" class="btn">목록</a>
			<button class="btn" onclick="history.back();">뒤로가기</button>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>