<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="JOIN" />

<%@ include file="../common/header.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>

// 주소
function getPostInfo() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
               extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            
            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraRoadAddr !== ''){
                extraRoadAddr = ' (' + extraRoadAddr + ')';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("roadAddress").value = roadAddr;
            document.getElementById("jibunAddress").value = data.jibunAddress;
            
            // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
            /* if(roadAddr !== ''){
                document.getElementById("extraAddress").value = extraRoadAddr;
            } else {
                document.getElementById("extraAddress").value = '';
            } */
        }
    }).open();
}

let validLoginId = '';
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
		/* alert(form.loginId.value + '은(는) 사용할 수 없는 아이디입니다'); */
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
	
	form.address.value = `\${ $("#roadAddress").val() } \${ $("#detailAddress").val() }\${ $("#extraAddress").val() }`;
	console.log(form.address.value);
	if (form.address.value.length == 0) {
		alert('주소를 입력해주세요');
		form.address.focus();
		return;
	}
	
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
})
</script>

<section class="h-body py-5">
	<div class="max-w-xl mx-auto card shrink-0 w-full bg-base-100 font-NanumSquareNeo">
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
	            	<input type="hidden" name="address" value="" />
		            <div class="flex gap-2">
		            	<input type="text" id="postcode" placeholder="우편번호" class="input input-bordered w-1/3 readonly">
		            	<button type="button" onclick="getPostInfo()" class="btn">우편번호 찾기</button>
		            </div>
	            	<input type="text" id="roadAddress" placeholder="도로명주소" class="input input-bordered w-full readonly">
					<input type="text" id="jibunAddress" placeholder="지번주소" class="input input-bordered w-full readonly">
		            <div class="flex gap-2">
			            <input type="text" id="detailAddress" placeholder="상세주소" class="input input-bordered w-3/5">
						<input type="text" id="extraAddress" placeholder="참고항목" class="input input-bordered w-2/5 readonly">
		            </div>
	            </div>
	            <!-- <input name="address" type="text" placeholder="Address" class="input input-bordered" required /> -->
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