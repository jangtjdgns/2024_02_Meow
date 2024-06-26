<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../common/header.jsp"%>
<%@ include file="../common/toastUi.jsp"%>
<script src="/js/common/reaction.js"></script>

<script>
	// 댓글 가져오기
	function getReplies() {
		$.ajax({
	        url: "../reply/getReplies",
	        method: "GET",
	        data: {
	        	"relId": $("#articleId").val(),
	        },
	        success: function(data) {
	        	if(data.success) {
	        		$("#replies").text("");
	        		
					const replies = data.data;
					
					if(replies.length == 0) {
						return $("#replies").append(`
	        				<div class="flex items-center justify-center border-b text-base text-center" style="min-height: 144px;">
	        					첫 댓글을 입력해보세요!
	        				</div>
		        		`);
					}
					
		        	for(let i = 0; i < replies.length; i++) {
		        		
		        		// 옵션 버튼(수정, 삭제)
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
					    
					    // 신고 버튼
					    const reportBtn = `
					    	<button class="btn btn-xs btn-ghost btn-circle" onclick="showReportModal('reply', \${replies[i].id}, 0)">
								<i class="fa-solid fa-circle-exclamation" style="color: #FFD43B"></i>
							</button>
					    `;
					    
		        		$("#replies").append(`
		        			<div class="border-b">
	        					<div class="flex justify-between pt-4 [min-height:144px]">
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
									\${loginedMemberId != replies[i].memberId ? reportBtn : ''}
									
								</div>
								<div class="flex justify-end gap-2 px-14 pb-4">
									<button id="reactionLikeBtn-reply-\${replies[i].id}" class="btn btn-xs btn-outline btn-info reactionBtn-reply-\${replies[i].id}" onclick="doReaction('reply', 0, \${replies[i].id})" \${loginedMemberId != 0 ? '' : 'disabled'}>
										<i class="fa-solid fa-thumbs-up"></i> <span class="reactionCount-reply"></span>
									</button>
									<button id="reactionDislikeBtn-reply-\${replies[i].id}" class="btn btn-xs btn-outline btn-secondary reactionBtn-reply-\${replies[i].id}" onclick="doReaction('reply', 1, \${replies[i].id})" \${loginedMemberId != 0 ? '' : 'disabled'}>
										<i class="fa-solid fa-thumbs-down"></i> <span class="reactionCount-reply"></span>
									</button>
								</div>
							</div>
		        		`);
		        		
		        		getReaction("reply", 0, replies[i].id);
			        	getReaction("reply", 1, replies[i].id);
		        	}
		        	$(".replyCnt").text(replies.length);
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
	
	// 전역변수 (게시글ID, 댓글ID)
	let articleId;
	$(function() {
		articleId = $("#articleId").val();
		getReplies();
		getReaction("article", 0, articleId);
		getReaction("article", 1, articleId);
	})
</script>

<section class="mw b-mh">
	<div class="relative h-full">
		<div class="border w-full [height:480px] absolute top-0 z-10">
			<img src="https://img.freepik.com/free-vector/cats-doodle-pattern-background_53876-100663.jpg?w=900&t=st=1710412076~exp=1710412676~hmac=a3b9244e4cb10307314db65461bb7052aa5e39285a4ff512399bfca4beb1a042" class="w-full h-full object-cover">
		</div>
		
		<div class="mx-auto max-w-4xl w-full bg-white p-14 absolute top-20 left-1/2 z-20 -translate-x-1/2 bg-opacity-95 rounded">
			<div class="pb-2 flex items-center justify-between">
				<div class="boardName"><a href="list?boardId=${article.boardId }" class="text-blue-600 hover:font-bold">${board.name }</a></div>
				<div class="text-sm flex justify-between gap-2">
					<div class="flex gap-2">
						<!-- 게시글 작성자 -->
						<div>
							<span class="text-xs"><i class="fa-regular fa-user"></i></span>
							<div class="dropdown dropdown-right">
							  	<div tabindex="0" role="button"><span class="text-gray-600 font-bold">${article.writerName }</span></div>
							  	<ul tabindex="0" class="dropdown-content z-[1] menu p-2 border shadow-lg bg-base-100 rounded-box w-32">
									<li><a href="../member/profile?memberId=${article.memberId }">프로필 보기</a></li>
									<c:if test="${rq.loginedMemberId != article.memberId }">
										<li><button onclick="sendRequest(${article.memberId }, 'friend')">친구추가</button></li>
										<li><button onclick="openPop(${rq.loginedMemberId }, ${article.memberId });">채팅</button></li>
										<li><button onclick="showReportModal('member', ${article.memberId }, 0)">신고</button></li>
									</c:if>
								</ul>
							</div>
						</div>
						
						<!-- 게시글 작성일 -->
						<div class="px-2">
							<span class="text-xs"><i class="fa-regular fa-clock"></i></span>
							<span class="text-gray-600">${article.regDate }</span>
						</div>
						
						<!-- 게시글 조회수 -->
						<div>
							<span class="text-xs"><i class="fa-regular fa-eye"></i></span>
							<span class="text-gray-600">${article.hitCnt }</span>
						</div>
						
						<!-- 게시글 좋아요수 -->
						<div>
							<span class="text-xs"><i class="fa-regular fa-thumbs-up"></i></span>
							<span class="text-gray-600 reactionLikeCnt">${article.reactionLikeCnt }</span>
						</div>
						
						<!-- 게시글 댓글수 -->
						<div>
							<span class="text-xs"><i class="fa-regular fa-comment-dots"></i></span>
							<span class="text-gray-600 replyCnt">${article.replyCnt }</span>
						</div>
					</div>
					
					<div>
						<c:if test="${rq.loginedMemberId == article.memberId }">
							<div class="dropdown dropdown-bottom dropdown-end">
								<div tabindex="0" role="button" class="btn btn-xs btn-ghost btn-circle">
									<i class="fa-solid fa-gear text-gray-700"></i>
								</div>
								<ul tabindex="0" class="menu dropdown-content z-[1] p-2 [flex-direction:row] flex-nowrap items-center gap-1 mt-1 p-1 shadow rounded-xl bg-white">
									<li>
										<a href="modify?id=${article.id }&boardId=${article.boardId }" class="btn btn-sm btn-ghost w-8 text-green-600">
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
			
			<!-- 게시글 제목, 내용 -->
			<div>
				<div class="text-3xl font-LINESeed pb-5">${article.title }</div>
				<textarea id="body" class="hidden">${article.body}</textarea>
				<div id="viewer" class="[min-height:30vh] mb-5"></div>
			</div>
			
			<!-- 게시글 좋아요 & 싫어요 -->
			<div class="flex justify-center gap-2">
				<button id="reactionLikeBtn-article-${article.id }" class="btn [min-width:7rem] reactionBtn-article-${article.id }" onclick="doReaction('article', 0, ${article.id})" ${rq.loginedMemberId != 0 ? '' : 'disabled'}>
					<i class="fa-solid fa-thumbs-up"></i> <span class="reactionCount-article"></span>
				</button>
				
				<button id="reactionDislikeBtn-article-${article.id }" class="btn [min-width:7rem] reactionBtn-article-${article.id }" onclick="doReaction('article', 1, ${article.id})" ${rq.loginedMemberId != 0 ? '' : 'disabled'}>
					<i class="fa-solid fa-thumbs-down"></i> <span class="reactionCount-article"></span>
				</button>
			</div>
			
			<!-- 댓글 -->
			<div class="w-full pt-4">
				<div class="border-b-2 pb-4">
					<div class="flex items-end justify-between pb-2">
						<div>댓글 (<span class="replyCnt">${article.replyCnt }</span>)</div>
						<div>
							<button class="btn btn-xs btn-error rounded-none text-white" onclick="showReportModal('article', ${article.id }, 0)">신고</button>
							<a href="list" class="btn btn-xs btn-neutral rounded-none">목록</a>
							<button class="btn btn-xs btn-neutral rounded-none" onclick="history.back();">뒤로가기</button>
						</div>
					</div>
					
					<!-- 댓글 입력 form -->
					<form action="../reply/doWrite" onsubmit="replyFormOnSubmit(this); return false;">
						<input type="hidden" id="articleId" name="relId" value="${article.id }"/>
						<input type="hidden" name="relTypeCode" value="article"/>
						<input type="hidden" id="boardId" name="boardId" value="${article.boardId }" />
						<textarea name="body" id="replyInput" class="textarea textarea-bordered w-full h-24 resize-none" placeholder="댓글을 입력해주세요." ${rq.loginedMemberId == 0 ? "disabled" : "" } ></textarea>
						<div class="flex justify-end pt-2">
							<button class="btn btn-sm w-20" ${rq.loginedMemberId == 0 ? "disabled" : "" }>작성</button>
						</div>
					</form>
				</div>
				
				<!-- 댓글들이 표시되는 곳 -->
				<div id="replies" class="text-sm px-1.5"></div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../common/scrollButtons.jsp"%>