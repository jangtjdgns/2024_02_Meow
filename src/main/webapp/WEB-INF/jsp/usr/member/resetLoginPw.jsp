<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<script src="/js/member/resetLoginPw.js"></script>

<section id="profile-bg" class="py-12 p-mw min-h border-t" style="background: linear-gradient(#EBE8E6, #E5D7D1);">
	<div class="mx-auto max-w-5xl profile-layout">
		<div>
			<div class="bg-white w-72 rounded-3xl p-6 shadow-2xl">
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">
						<i class="fa-solid fa-key pr-1"></i>
						<span>계정찾기</span>
					</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<a href="../find/loginId" class="side-btn btn btn-ghost btn-sm mx-1 ">아이디 찾기</a>
						<a href="../reset/loginPw" class="side-btn btn btn-ghost btn-sm mx-1 btn-active">비밀번호 재설정</a>
					</div>
				</div>
			</div>
		</div>
		
		<div id="section-wrap">
			<div class="bg-white border shadow-2xl rounded-3xl pb-10">
				<div class="pt-14 pb-4 px-20 text-3xl">
					<i class="fa-solid fa-unlock-keyhole"></i>
					<span>비밀번호 재설정</span>
					<div class="text-xs pt-3"><span class="text-red-700">* </span>SNS 회원은 비밀번호 재설정이 불가능합니다.</div>
				</div>
				<div class="pb-4 px-20">
					
					<!-- 이름 -->
					<div class="form-control">
	                    <label class="label">
	                        <span class="label-text">이름</span>
	                    </label>
	                    <input id="name" type="text" placeholder="이름 입력" class="input input-bordered" data-korName="이름" minlength="2" maxlength="50" autocomplete="off" required />
	                </div>
	                
	                <!-- 아이디 -->
					<div class="form-control">
				        <label class="label">
				            <span class="label-text">아이디</span>
				        </label>
					    <input id="loginId" name="loginId" type="text" placeholder="아이디 입력" data-korName="아이디" class="input input-bordered" minlength="8" maxlength="20" autocomplete="off" required />
			        </div>
	                
	                <!-- 이메일 -->
	                <div class="form-control">
	                    <label class="label">
	                        <span class="label-text">이메일</span>
	                    </label>
	                    <div class="flex justify-between gap-2 pb-2">
		                	<input id="email" type="text" placeholder="이메일 입력" class="input input-bordered w-full" data-korName="이메일" minlength="6" maxlength="200" autocomplete="off" required />
			                <button class="btn sendMailBtn" onclick="resetLoginPw()">이메일 인증</button>
		                </div>
		                
		                <div id="authCodeWrap" class="flex gap-2 hidden">
			            	<input id="authCode" type="text" placeholder="이메일 인증코드 입력 6자리" class="input input-bordered w-full" minlength="6" maxlength="6" autocomplete="off" />
			           		<button type="button" class="btn" onclick="checkAuthCode()">확인</button>
			           	</div>
	                </div>
	                
	                <!-- 비밀번호 재설정 -->
	                <div id="resetPwWrap" class="hidden">
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
</section>
<%@ include file="../common/footer.jsp"%>