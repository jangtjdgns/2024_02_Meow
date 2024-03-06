<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="JOIN" />

<%@ include file="../common/header.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="/js/member/join.js"></script>

<section class="h-body py-5">
	<div class="max-w-xl mx-auto card shrink-0 w-full bg-base-100">
		<form action="doJoin" method="post" class="card-body" onsubmit="joinFormOnSubmit(this); return false;" enctype="multipart/form-data">
			<div class="form-control">
		        <label class="label">
		            <span class="label-text">아이디</span>
		        </label>
				<div class="flex gap-2">
			        <input name="loginId" type="text" placeholder="아이디 입력" data-korName="아이디" id="loginId" class="input input-bordered w-full" minlength="8" maxlength="20" required />
			        <button type="button" class="dupCheckBtn btn">중복확인</button>
			    </div>
	        </div>
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">비밀번호</span>
	            </label>
	            <input name="loginPw" type="password" placeholder="비밀번호 입력" data-korName="비밀번호" class="input input-bordered" minlength="10" maxlength="30" required />
	        </div>
	        
	        <!-- 비밀번호 확인란 -->
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이름</span>
	            </label>
	            <input name="name" type="text" placeholder="이름 입력" data-korName="이름" class="input input-bordered" minlength="2" maxlength="50" required/>
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">닉네임</span>
	            </label>
	            <input name="nickname" type="text" placeholder="닉네임 입력" data-korName="닉네임" class="input input-bordered" minlength="2" maxlength="12" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">나이</span>
	            </label>
	            <input name="age" type="text" placeholder="나이 입력" data-korName="나이" class="input input-bordered" minlength="1" maxlength="3" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">주소</span>
	            </label>
	            <div id="address" class="flex flex-col gap-2">
	            	<input id="addressInput" type="hidden" name="address" data-korName="주소" value="" />
		            <div class="flex gap-2 justify-between items-center">
		            	<div>
			            	<input type="text" id="postcode" placeholder="우편번호" class="input input-bordered w-1/3" readonly />
			            	<button type="button" onclick="getPostInfo()" class="btn">우편번호 찾기</button>
		            	</div>
		            	<button type="button" class="btn btn-circle btn-sm" onclick="resetAddress()"><i class="fa-solid fa-rotate-right"></i></button>
		            </div>
	            	<input type="text" id="roadAddress" placeholder="도로명주소" class="input input-bordered w-full" readonly />
					<input type="text" id="jibunAddress" placeholder="지번주소" class="input input-bordered w-full" readonly />
		            <input type="text" id="detailAddress" placeholder="상세주소" class="input input-bordered w-full" />
	            </div>
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">전화번호</span>
	            </label>
	            <input name="cellphoneNum" type="text" placeholder="전화번호 입력" data-korName="전화번호" class="input input-bordered" maxlength="13" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이메일</span>
	            </label>
	            <input name="email" type="email" placeholder="이메일 입력" data-korName="이메일" class="input input-bordered" minlength="6" maxlength="200" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">프로필 사진</span>
	            </label>
	            <div class="flex items-center gap-2">
		            <input id="profileImage" name="profileImage" type="file" class="file-input file-input-bordered w-full" accept="image/gif, image/jpeg, image/png" />
		            <div class="dropdown dropdown-hover dropdown-top dropdown-end">
					  	<div tabindex="0" role="button" class="btn btn-sm btn-circle bg-white mt-1"><i class="fa-solid fa-image"></i></div>
					  	<ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box w-96">
						    <li><img id="imagePreview" src="" alt="업로드된 이미지 없음"/></li>
					  	</ul>
					</div>
		            <button type="button" class="btn btn-circle btn-sm bg-white" onclick="resetImage()"><i class="fa-solid fa-rotate-right"></i></button>
	            </div>
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">소개말</span>
	            </label>
	            <textarea name="aboutMe" placeholder="자신을 소개해보세요!" rows="5" class="textarea textarea-bordered resize-none" maxlength="100"></textarea>
	        </div>
	        
	        <div class="form-control mt-6">
	            <button class="btn btn-primary">가입</button>
	        </div>
	    </form>
	</div>
</section>
<%@ include file="../common/footer.jsp"%>