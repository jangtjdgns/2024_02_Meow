<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="/js/member/resetLoginPw.js"></script>

<div class="bg-white border shadow-2xl rounded-3xl">
	<div id="section-wrap">
		<div class="bg-white border shadow-2xl rounded-3xl pb-10">
			<div class="pt-14 pb-4 px-20 text-3xl">
				<i class="fa-solid fa-unlock-keyhole"></i>
				<span>비밀번호 재설정 (로그인 전용)</span>
				<div class="text-xs pt-3"><span class="text-red-700">* </span>SNS 회원은 비밀번호 재설정이 불가능합니다.</div>
			</div>
			<div class="pb-4 px-20">
                <!-- 비밀번호 재설정 -->
                <div id="resetPwWrap">
                	<!-- 변경할 비밀번호 -->
	                <div class="form-control">
				        <label class="label">
				            <span class="label-text">재설정할 비밀번호</span>
				        </label>
					    <input id="resetPw" type="password" placeholder="재설정 비밀번호 입력" data-korName="재설정비밀번호" class="input input-bordered" minlength="10" maxlength="30" autocomplete="off" required />
			        </div>
			        
			        <!-- 변경할 비밀번호 확인 -->
	                <div class="form-control">
				        <label class="label">
				            <span class="label-text">재설정할 비밀번호 확인</span>
				        </label>
					    <input id="resetPwChk" type="password" placeholder="재설정 비밀번호 확인란" data-korName="재설정비밀번호" class="input input-bordered" minlength="10" maxlength="30" autocomplete="off" required />
			        </div>
			        
			        <div class="text-right pt-6">
				        <button class="btn btn-wide resetPwBtn" onclick="doResetPw()" disabled>변경</button>
			        </div>
		        </div>
			</div>
		</div>
	</div>
</div>