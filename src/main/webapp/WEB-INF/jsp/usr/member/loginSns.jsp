<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="/js/member/join.js"></script>

<script>
	// 로그인 기록 확인
	function hasLoggedInBefore(snsInfo) {
		$.ajax({
    		url: '/usr/member/sns/checkLogin',
    	    method: 'POST',
    	    data: {
    	    	snsId: snsInfo.snsId,
    	    },
    	    dataType: 'json',
    	    success: function(data) {
    	    	console.log(data);
    	    	// 기록 o
    	    	if(data.success) {
    	    		window.location.replace(`/usr/member/doLogin/sns?snsId=\${snsInfo.snsId}`);
    	    	} 
    	    	// 기록 x
    	    	else {
    	    		$('.sns-join-wrap').show('slow');
    	    		$('#snsType').text(snsInfo.snsType);
    	    		$('#name').val(snsInfo.name);
    	    		$('#cellphoneNum').val(snsInfo.mobile);
    	    		$('#inputEmail').val(snsInfo.email);
    	    		$('#profileImage').val(snsInfo.profileImage);
    	    		$('#imagePreview').attr('src', snsInfo.profileImage);
    	    	}
    		},
    	      	error: function(xhr, status, error) {
    	      	console.error('Ajax error:', status, error);
    		}
    	});
	}
	
	// 
	
	$(function() {
        let snsInfo = JSON.parse($('.snsInfo').text());
        $('.snsInfoJson').val($('.snsInfo').text())
        hasLoggedInBefore(snsInfo);
	})
</script>

<section class="b-mh py-5 border-t bg-gray-50">
	<div class="snsInfo hidden">${snsInfo }</div>
	
	<!-- 회원 가입란 -->
	<div class="sns-join-wrap max-w-xl mx-auto card shrink-0 w-full bg-white shadow-xl border hidden">
		<form action="http://localhost:8085/usr/member/snsDoJoin" method="post" class="card-body" onsubmit="snsJoinFormOnSubmit(this); return false;">
			<input name="snsInfoJson" type="hidden" class="snsInfoJson no-validation" value="" />
			<!-- 이름 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이름</span>
	                <span id="snsType" class="label-text badge badge-accent badge-outline"></span>
	            </label>
	            <input id="name" name="name" type="text" placeholder="이름 입력" data-korName="이름" class="input input-bordered focus:outline-none" minlength="2" maxlength="50" readonly />
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
			            	<input type="text" id="postcode" placeholder="우편번호" class="input input-bordered w-1/3 no-validation focus:outline-none" readonly />
			            	<button type="button" onclick="getPostInfo()" class="btn find-postal-code">우편번호 찾기</button>
		            	</div>
		            	<button type="button" class="btn btn-circle btn-sm" onclick="resetAddress()"><i class="fa-solid fa-rotate-right"></i></button>
		            </div>
	            	<input type="text" id="roadAddress" placeholder="도로명주소" class="input input-bordered w-full no-validation focus:outline-none" readonly />
					<input type="text" id="jibunAddress" placeholder="지번주소" class="input input-bordered w-full no-validation focus:outline-none" readonly />
		            <input type="text" id="detailAddress" placeholder="상세주소" class="input input-bordered w-full no-validation" autocomplete="off" />
	            </div>
	        </div>
	        
	        <!-- 전화번호 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">전화번호</span>
	            </label>
	            <input id="cellphoneNum" name="cellphoneNum" type="text" placeholder="전화번호 입력" data-korName="전화번호" class="input input-bordered" maxlength="13" autocomplete="off" />
	        </div>
	        
	        <!-- 이메일 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이메일</span>
	            </label>
		        <input id="inputEmail" name="email" type="email" placeholder="이메일 입력" data-korName="이메일" class="input input-bordered w-full focus:outline-none" readonly />
	        </div>
	        
	        <!-- 프로필 사진 -->
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">프로필 사진</span>
	                <span class="label-text"><span class="text-red-700">* </span>SNS 프로필 이미지가 연동됩니다.</span>
	            </label>
	            <div class="flex items-center gap-2">
	            	<input type="text" id="profileImage" class="input input-bordered w-full no-validation focus:outline-none" name="profileImage" placeholder="등록된 프로필 이미지가 없습니다." readonly />
		            <div class="dropdown dropdown-hover dropdown-top dropdown-end">
					  	<div tabindex="0" role="button" class="btn btn-sm btn-circle bg-white mt-1"><i class="fa-solid fa-image"></i></div>
					  	<ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box w-96">
						    <li><img id="imagePreview" src="" alt="선택된 이미지가 없음"/></li>
					  	</ul>
					</div>
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
	            <button type="button" class="btn" onclick="history.back()">취소</button>
	        </div>
		</form>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>