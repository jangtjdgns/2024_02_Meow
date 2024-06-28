<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="/js/member/delete.js"></script>

<div class="bg-white border shadow-2xl rounded-3xl">
	<div class="p-10 text-3xl">계정 탈퇴</div>
	<div class="p-6 w-4/5 mx-auto">
		<div class="pb-2">*서비스를 더 개선하기 위해 여러분의 소중한 의견을 알려주세요.</div>
		<div class="pb-10">
			<div class="grid grid-cols-3 gap-2">
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden delete-reason" />
			    	<span class="btn btn-outline w-full">콘텐츠 불만족</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden delete-reason" />
			    	<span class="btn btn-outline w-full">부정적인 커뮤니티 경험</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden delete-reason" />
			    	<span class="btn btn-outline w-full">다른 서비스 이용</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden delete-reason" />
			    	<span class="btn btn-outline w-full">이용 빈도 낮음</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden delete-reason" />
			    	<span class="btn btn-outline w-full">서비스 불만족</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden delete-reason" />
			    	<span class="btn btn-outline w-full">직접 입력</span>
			  	</label>
		  	</div>
		  	
		  	<form action="doDelete" method="post" onsubmit="deleteFormSubmit(this); return false;" class="py-2.5 px-1">
		  		<input type="hidden" name="memberId" value="${rq.loginedMemberId }" />
		  		<input type="hidden" name="deletionReasonCode" id="deletionReasonCode" />
		  		<div id="customDeletionReason" class="textarea textarea-bordered h-40 relative hidden">
	            	<textarea name="customDeletionReason" placeholder="탈퇴 이유를 작성해주세요." oninput="checkInputTextLength(this)" class="textarea resize-none absolute top-0 left-0 w-full h-full" maxLength="100" disabled></textarea>
	            	<div class="absolute bottom-0 right-0 border-l border-t rounded-tl-lg p-1 min-w-16 text-center bg-white bg-opacity-70"><span class="inputTextLength">0</span> / 100</div>
	            </div>
			  	
			  	<div class="pb-4">
					<div class="pb-6">
						<div class="label">
						    <span class="label-text">비밀번호 입력</span>
						</div>
						<input id="loginPw" name="loginPw" type="password" placeholder="비밀번호 입력" data-korName="비밀번호" class="input input-bordered w-full" minlength="10" maxlength="30" autocomplete="off" />
						<div class="label hover:underline">
							<button type="button" class="label-text-alt" onclick="getUserAccountJsp(1)">비밀번호 재설정</button>
						</div>
					</div>
					
					<div class="text-right">
						<button class="btn btn-error">탈퇴</button>
					</div>
				</div>
		  	</form>
		</div>
		
		
	</div>
</div>