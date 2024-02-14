<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="JOIN" />

<%@ include file="../common/header.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
// 주소 정보를 담을 객체
let address = {
		zonecode: '',
		sido: '',
		sigungu: '',
		bname: '',
		jibunAddress: '',
		roadAddress: '',
		detailAddress: '',
}

// 주소 API
function getPostInfo() {
    new daum.Postcode({
        oncomplete: function(data) {
            var roadAddr = data.roadAddress; // 도로명 주소 변수

            // 우편번호와 주소 정보를 해당 필드에 기입
            $("#postcode").val(data.zonecode);
            $("#roadAddress").val(data.roadAddress);
            $("#jibunAddress").val(data.jibunAddress);
            
            // 주소 객체에 값 추가
           	address.zonecode = data.zonecode;
            address.sido = data.sido;
            address.sigungu = data.sigungu;
            address.bname = data.bname;
            address.jibunAddress = data.jibunAddress;
            address.roadAddress = data.roadAddress;
        }
    }).open();
}

// 로그인 아이디 검사용 변수
let validLoginId = '';

// 회원가입 유효성 검사 함수
const joinFormOnSubmit = function(form){
	form.loginId.value = form.loginId.value.trim();
	form.loginPw.value = form.loginPw.value.trim();
	form.name.value = form.name.value.trim();
	form.nickname.value = form.nickname.value.trim();
	form.cellphoneNum.value = form.cellphoneNum.value.trim();
	form.email.value = form.email.value.trim();
	
	if (form.loginId.value.length == 0) {
		alert('아이디를 입력해주세요');
		form.loginId.focus();
		return;
	}
	
	if (form.loginId.value != validLoginId) {
		alert(form.loginId.value + '은(는) 사용할 수 없는 아이디입니다');
		alert("중복확인을 진행해주세요");
		form.loginId.value = '';
		form.loginId.focus();
		return;
	}
	
	if (form.loginPw.value.length == 0) {
		alert('비밀번호를 입력해주세요');
		form.loginPw.focus();
		return;
	}
	
	if (form.name.value.length == 0) {
		alert('이름을 입력해주세요');
		form.name.focus();
		return;
	}
	
	if (form.nickname.value.length == 0) {
		alert('닉네임을 입력해주세요');
		form.nickname.focus();
		return;
	}
	
	if (form.age.value.length == 0) {
		alert('나이를 입력해주세요');
		form.age.focus();
		return;
	}
	
	
	// 우편번호로 주소를 입력했는지 검증, 필수이기 때문
	if(!address.zonecode) {
		alert("주소를 입력해주세요.");
		$("#postcode").focus();
		return;
	}
	
	const addressToJson = JSON.stringify(address);
	form.address.value = addressToJson;
	
	if (form.cellphoneNum.value.length == 0) {
		alert('전화번호를 입력해주세요');
		form.cellphoneNum.focus();
		return;
	}
	
	if (form.email.value.length == 0) {
		alert('이메일을 입력해주세요');
		form.email.focus();
		return;
	}
	
	form.submit();
}  

function dupCheck(loginId){
	$.ajax({
		url : "../member/duplicationCheck",
		method : "get",
		data : {
			"loginId" : loginId.val().trim(),
		},
		dataType : "json",
		success : function(data){
			if(data.success){
				loginId.removeClass("input-error");
				validLoginId = loginId.val().trim();
			} else {
				loginId.addClass("input-error");
				validLoginId = '';
			}
		},
		error : function(xhr, status, error){
			console.error("ERROR : " + status + " - " + error);
		}
	})
}


$(function(){
	$(".dupCheckBtn").click(function(){
		dupCheck($("#loginId"));
	})
	
	$("input:not(#address input, #profileImage)").blur(function(){
		if($(this).val().trim().length == 0){
			$(this).addClass("input-error");
		} else {
			$(this).removeClass("input-error");
		}
	})
	
	$("#detailAddress").change(function(){
		address.detailAddress = $("#detailAddress").val();
	})
})
</script>

<section class="h-body py-5">
	<div class="max-w-xl mx-auto card shrink-0 w-full bg-base-100">
		<form action="doJoin" method="post" class="card-body" onsubmit="joinFormOnSubmit(this); return false;">
			<div class="form-control">
		        <label class="label">
		            <span class="label-text">아이디</span>
		        </label>
				<div class="flex gap-2">
			        <input name="loginId" type="text" placeholder="LoginId" id="loginId" class="input input-bordered w-full" required />
			        <button type="button" class="dupCheckBtn btn">중복확인</button>
			    </div>
	        </div>
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">비밀번호</span>
	            </label>
	            <input name="loginPw" type="password" placeholder="Password" class="input input-bordered" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이름</span>
	            </label>
	            <input name="name" type="text" placeholder="Name" class="input input-bordered" required/>
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">닉네임</span>
	            </label>
	            <input name="nickname" type="text" placeholder="Nickname" class="input input-bordered" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">나이</span>
	            </label>
	            <input name="age" type="text" placeholder="Age" class="input input-bordered" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">주소</span>
	            </label>
	            <div id="address" class="flex flex-col gap-2">
	            	<input id="addressInput" type="hidden" name="address" value="" />
		            <div class="flex gap-2">
		            	<input type="text" id="postcode" placeholder="우편번호" class="input input-bordered w-1/3" readonly>
		            	<button type="button" onclick="getPostInfo()" class="btn">우편번호 찾기</button>
		            </div>
	            	<input type="text" id="roadAddress" placeholder="도로명주소" class="input input-bordered w-full" readonly>
					<input type="text" id="jibunAddress" placeholder="지번주소" class="input input-bordered w-full" readonly>
		            <input type="text" id="detailAddress" placeholder="상세주소" class="input input-bordered w-full">
	            </div>
	            </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">전화번호</span>
	            </label>
	            <input name="cellphoneNum" type="text" placeholder="Mobile" class="input input-bordered" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이메일</span>
	            </label>
	            <input name="email" type="email" placeholder="Email" class="input input-bordered" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">프로필 사진</span>
	            </label>
	            <input id="profileImage" name="profileImage" type="file" class="file-input file-input-bordered w-full" accept="image/gif, image/jpeg, image/png" />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">소개말</span>
	            </label>
	            <textarea name="aboutMe" placeholder="Introduce me" rows="5" class="textarea textarea-bordered resize-none"></textarea>
	        </div>
	        
	        <div class="form-control mt-6">
	            <button class="btn btn-primary">가입</button>
	        </div>
	    </form>
	</div>
</section>
<%@ include file="../common/footer.jsp"%>