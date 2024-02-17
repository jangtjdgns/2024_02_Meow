<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="/resources/js/member/delete.js"></script>

<div class="bg-white border shadow-2xl rounded-3xl">
	<div class="p-10 text-3xl">계정 탈퇴</div>
	<div class="p-6 w-4/5 mx-auto">
		<div class="pb-2">*서비스를 더 개선하기 위해 여러분의 소중한 의견을 알려주세요.</div>
		<div class="pb-10 mb-10">
			<div class="grid grid-cols-3 gap-2">
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden" />
			    	<span class="btn btn-outline w-full">콘텐츠 불만족</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden" />
			    	<span class="btn btn-outline w-full">부정적인 커뮤니티 경험</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden" />
			    	<span class="btn btn-outline w-full">다른 서비스 이용</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden" />
			    	<span class="btn btn-outline w-full">이용 빈도 낮음</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden" />
			    	<span class="btn btn-outline w-full">서비스 불만족</span>
			  	</label>
			  	<label class="cursor-pointer label">
			    	<input type="checkbox" class="checkbox hidden" />
			    	<span class="btn btn-outline w-full">직접 입력</span>
			  	</label>
		  	</div>
		  	
		  	<form action="doDelete" method="post" onsubmit="deleteFormSubmit(this); return false;" class="py-2.5 px-1">
		  		<input type="hidden" name="memberId" value="${rq.loginedMemberId }" />
		  		<input type="hidden" name="deletionReasonCode" id="deletionReasonCode" />
			  	<textarea name="customDeletionReason" id="customDeletionReason" placeholder="직접입력" class="resize-none w-full h-20 border border-black rounded-xl p-2 text-sm hidden" disabled></textarea>
			  	<div class="text-right">
					<button class="btn btn-error">탈퇴</button>
				</div>
		  	</form>
		</div>
		<!-- <div class="pb-4 w-2/3 mx-auto">
			<div class="pb-6">
				<div class="label">
				    <span class="label-text">비밀번호 확인</span>
				</div>
				<input name="loginPw" type="password" placeholder="Password" class="input input-bordered w-full" required />
				<div class="label hover:underline">
					<a href="" class="label-text-alt">비밀번호를 잊으셨냐요?</a>
				</div>
			</div>
			<div class="text-right">
				<a href="" class="btn btn-error">탈퇴</a>
			</div>
		</div> -->
	</div>
</div>