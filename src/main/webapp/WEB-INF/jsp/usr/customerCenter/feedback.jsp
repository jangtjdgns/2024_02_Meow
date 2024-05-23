<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script>
	bindFormInputEvent($("#input-feedback"), "textarea-error");
	$(function(){
		$("#input-feedback").on({
			focus: function(){
				$(this).addClass("h-40");
			},
			blur: function(){
				$(this).removeClass("h-40");
			}
		})
	})
	
	function doWriteFeedback(){
		let content = $("#input-feedback").val();
		
		if(content.trim().length == 0) {
			alertMsg("내용을 입력해주세요.", "warning");
			return $("#input-feedback").focus();
		}
		
		$.ajax({
			url: '../customer/doWriteFeedback',
		    method: 'GET',
		    data: {
		    	memberId: loginedMemberId,
		    	content: content,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	if(data.success) {
		    		const result = data.data;
		    		
		    		const setContent = `
		    			<div id="feedback-\${result.id }"  class="border-b [min-height:120px] flex flex-col justify-center gap-2 px-2">
		    				<div class="feedback-header flex justify-between text-sm">
		    					<div class="flex items-center h-6">		    					
			    					<div class="[min-width:12px]">\${result.id }</div>
			    					<span class="border border-black h-1/2 ml-1 mr-2"></span>
			    					<div>\${result.nickname }</div>
		    					</div>
		    					<div class="pr-2">						
									<button class="btn btn-xs btn-ghost" onclick="modifyContent(\${result.id })"><i class="fa-solid fa-pen-clip"></i></button>
								</div>
		    				</div>
		    				<div class="feedback-body p-1">
		    					<div class="feedback-content">\${result.content }</div>
		    				</div>
		    				<div class="feedback-footer">
		    					<div class="text-sm text-gray-500">\${result.formattedRegDate }</div>
		    				</div>
		    			</div>
		    		`;
		    		
		    		$("#feedback-wrap").prepend(setContent);
		    		$("#input-feedback").val("");
		    		alertMsg("피드백이 작성되었습니다.", "default");
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
</script>

<!-- 피드백 수정용 js -->
<script>
	let originalContent = null;		// 수정 전의 엘리먼트 백업용
	let originalId = null;			// 수정 전의 피드백 id 백업용
	
	// 수정을 위한 textarea 생성
	function modifyContent(feedbackId) {
		
		if (originalContent != null) {
			return modifyCancle(originalId);		// 수정 취소, return 빼는게 더 자연스러울 수도(단, 빼면 수정 이미지 토글 안됌)
		}
		
		let feedback = `#feedback-\${feedbackId}`;
		originalContent = $(feedback).find('.feedback-body').html().trim();		// 해당 컨텐츠 바디 백업
		originalId = feedbackId;												// 해당 컨텐츠 id 백업
		const text = $(feedback).find('.feedback-content').text().trim();		// 해당 컨텐츠 실제 내용

		$(feedback).find('.feedback-body').html(`
			<div class="text-right py-1ㅋ">
				<textarea id="modify-feedback" class="textarea textarea-bordered resize-none w-full h-20" placeholder="수정하실 내용을 입력해주세요!">\${text}</textarea>
				<div id="button-wrap" class="py-4">
					<button class="btn btn-sm" onclick="doModifyFeedback(\${feedbackId})">수정</button>
					<button class="btn btn-sm" onclick="modifyCancle(\${feedbackId})">취소</button>
				</div>
			</div>
		`)
	}
	
	// 수정 취소 함수
	function modifyCancle(feedbackId) {
		const feedback = `#feedback-\${feedbackId}`;
		let feedbackContent = $(feedback).find('.feedback-body');
		
		feedbackContent.html(originalContent);
		
		console.log(originalContent)
		originalContent = null;
		originalId = null;
	}
	
	// 수정 함수
	function doModifyFeedback(feedbackId) {
		let content = $("#modify-feedback").val();
		
		if(content.trim().length == 0) {
			alertMsg("수정하실 내용을 입력해주세요.", "warning");
			return $("#modify-feedback").focus();
		}
		
		$.ajax({
			url: '../customer/doModifyFeedback',
		    method: 'GET',
		    data: {
		    	feedbackId: feedbackId,
		    	content: content,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	if(data.success) {
		    		alertMsg("수정 되었습니다.", "default");
		    		
		    		// 이 부분 조금 보완하면 좋을듯
		    		const feedback = `#feedback-\${feedbackId}`;
		    		const modifyContent = `<div class="feedback-content">\${content}</div>`
		    		
		    		$(feedback).find('.feedback-body').html(modifyContent);
		    		
		    		originalContent = null;
		    		originalId = null;
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
</script>

<div class="bg-white border-2 shadow-xl rounded-2xl p-10">
	<div class="[max-height:60vh] text-right">
		<textarea id="input-feedback" class="textarea textarea-bordered resize-none w-full h-20" style="transition: height .2s;" placeholder="고객님의 소중한 의견은 저희에게 큰 도움이 됩니다. 언제든지 편하게 개선사항이나 피드백을 남겨주세요!"></textarea>
		<button class="btn my-4" onclick="doWriteFeedback()">작성</button>
	</div>
	
	<!-- 최신 20개만 표시되도록 제한할까? | 페이지네이션? | 맨 아래로 갔을때 이어서 나오게할까? -->
	<div id="feedback-wrap" class="[max-height:60vh] border-t border-b overflow-y-scroll">
		<c:if test="${feedback.size() == 0 }">	
			<div class="text-center py-4">현재 등록된 피드백이 없습니다.</div>
		</c:if>
		
		<c:forEach var="fb" items="${feedback }" varStatus="status">
			<div id="feedback-${fb.id }" class="${status.last ? '' : 'border-b' } flex flex-col p-2">
				<div class="feedback-header flex justify-between text-sm">
					<div class="flex items-center h-6">
						<div class="[min-width:12px]">${fb.id }</div>
						<span class="border border-black h-1/2 ml-1 mr-2"></span>
						<div>${fb.nickname }</div>
					</div>
					<div class="pr-2">
						<c:if test="${fb.memberId == rq.loginedMemberId }">							
							<button class="btn btn-xs btn-ghost" onclick="modifyContent(${fb.id })"><i class="fa-solid fa-pen-clip"></i></button>
						</c:if>
					</div>
				</div>
				<div class="feedback-body p-1">
					<div class="feedback-content">${fb.content }</div>
				</div>
				<div class="feedback-footer">
					<div class="text-sm text-gray-500">${fb.formattedRegDate }</div>
				</div>
			</div>
		</c:forEach>
	</div>
</div>