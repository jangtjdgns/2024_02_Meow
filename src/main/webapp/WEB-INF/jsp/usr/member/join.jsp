<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="JOIN" />

<%@ include file="../common/header.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="/js/member/join.js"></script>

<section class="h-body py-5 border-t bg-gray-50">
	<div class="max-w-xl mx-auto card shrink-0 w-full bg-white shadow-xl border">
		<form action="doJoin" method="post" class="card-body" onsubmit="joinFormOnSubmit(this); return false;" enctype="multipart/form-data">
			
			<!-- 아이디 -->
			<div class="form-control">
		        <label class="label">
		            <span class="label-text">아이디</span>
		        </label>
				<div class="flex gap-2">
			        <input id="loginId" name="loginId" type="text" placeholder="아이디 입력" data-korName="아이디" class="input input-bordered w-full dupInput" minlength="8" maxlength="20" autocomplete="off" />
			        <button type="button" class="dupCheckBtn btn" data-input="loginId">중복확인</button>
			    </div>
	        </div>
	        
	        <!-- 비밀번호 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">비밀번호</span>
	            </label>
	            <input id="loginPw" name="loginPw" type="password" placeholder="비밀번호 입력" data-korName="비밀번호" class="input input-bordered" minlength="10" maxlength="30" autocomplete="off" />
	        </div>
	        
	        <!-- 비밀번호 확인란 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">비밀번호 확인</span>
	            </label>
	            <input id="loginPwChk" type="password" placeholder="비밀번호 확인 입력" data-korName="비밀번호확인" class="input input-bordered no-validation" minlength="10" maxlength="30" autocomplete="off" />
	        </div>
	        
	        <!-- 이름 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이름</span>
	            </label>
	            <input name="name" type="text" placeholder="이름 입력" data-korName="이름" class="input input-bordered" minlength="2" maxlength="50" autocomplete="off"/>
	        </div>
	        
	        <!-- 닉네임 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">닉네임</span>
	            </label>
	            <div class="flex gap-2">
		            <input id="nickname" name="nickname" type="text" placeholder="닉네임 입력" data-korName="닉네임" class="input input-bordered w-full dupInput" minlength="2" maxlength="12" autocomplete="off" />
			        <button type="button" class="dupCheckBtn btn" data-input="nickname">중복확인</button>
			    </div>
	        </div>
	        
	        <!-- 나이 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">나이</span>
	            </label>
	            <input name="age" type="text" placeholder="나이 입력" data-korName="나이" class="input input-bordered" minlength="1" maxlength="3" autocomplete="off" />
	        </div>
	        
	        <!-- 주소 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">주소</span>
	            </label>
	            <div id="address" class="flex flex-col gap-2">
	            	<input name="address" type="hidden" id="addressInput" data-korName="주소" class="no-validation"/>
		            <div class="flex gap-2 justify-between items-center">
		            	<div>
			            	<input type="text" id="postcode" placeholder="우편번호" class="input input-bordered w-1/3 no-validation" readonly />
			            	<button type="button" onclick="getPostInfo()" class="btn find-postal-code">우편번호 찾기</button>
		            	</div>
		            	<button type="button" class="btn btn-circle btn-sm" onclick="resetAddress()"><i class="fa-solid fa-rotate-right"></i></button>
		            </div>
	            	<input type="text" id="roadAddress" placeholder="도로명주소" class="input input-bordered w-full no-validation" readonly />
					<input type="text" id="jibunAddress" placeholder="지번주소" class="input input-bordered w-full no-validation" readonly />
		            <input type="text" id="detailAddress" placeholder="상세주소" class="input input-bordered w-full no-validation" autocomplete="off" />
	            </div>
	        </div>
	        
	        <!-- 전화번호 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">전화번호</span>
	            </label>
	            <input name="cellphoneNum" type="text" placeholder="전화번호 입력" data-korName="전화번호" class="input input-bordered" maxlength="13" autocomplete="off" />
	        </div>
	        
	        <!-- 이메일 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이메일</span>
	                <span class="label-text"><span class="text-red-700">* </span>입력한 이메일을 변경할 시 재인증이 필요합니다.</span>
	            </label>
	            <div class="flex gap-2 pb-2">
		            <input id="inputEmail" name="email" type="email" placeholder="이메일 입력" data-korName="이메일" class="input input-bordered w-full" minlength="6" maxlength="200" autocomplete="off" />
	            	<button type="button" class="btn senMailBtn no-validation" onclick="sendMailAuthCode()">인증코드 발송</button>
	            </div>
	            
	            <div id="authCodeWrap" class="flex gap-2 hidden">
	            	<input id="authCode" type="text" placeholder="이메일 인증코드 입력 6자리" class="input input-bordered w-full" minlength="6" maxlength="6" autocomplete="off" />
	           		<button type="button" class="btn" onclick="checkAuthCode()">확인</button>
	           	</div>
	        </div>
	        
	        <!-- 프로필 사진 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">프로필 사진</span>
	            </label>
	            <div class="flex items-center gap-2">
		            <input id="profileImage" name="profileImage" type="file" class="file-input file-input-bordered w-full no-validation" accept="image/gif, image/jpeg, image/png" />
		            <div class="dropdown dropdown-hover dropdown-top dropdown-end">
					  	<div tabindex="0" role="button" class="btn btn-sm btn-circle bg-white mt-1"><i class="fa-solid fa-image"></i></div>
					  	<ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box w-96">
						    <li><img id="imagePreview" src="" alt="선택된 이미지가 없음"/></li>
					  	</ul>
					</div>
		            <button type="button" class="btn btn-circle btn-sm bg-white" onclick="resetImage()"><i class="fa-solid fa-rotate-right"></i></button>
	            </div>
	        </div>
	        
	        <!-- 소개말 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">소개말</span>
	            </label>
	            <textarea name="aboutMe" placeholder="자신을 소개해보세요!" rows="5" class="textarea textarea-bordered resize-none" maxlength="100"></textarea>
	        </div>
	        
	        <!-- 가입, 취소 버튼 -->
	        <div class="grid grid-cols-2 gap-4 mt-6">
	            <button class="btn btn-primary">가입</button>
	            <button type=button class="btn">취소</button>
	        </div>
	    </form>
	</div>
</section>
<%@ include file="../common/footer.jsp"%>