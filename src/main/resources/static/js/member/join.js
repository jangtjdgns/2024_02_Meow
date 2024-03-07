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

// 주소 초기화
function resetAddress() {
	$("#postcode").val("");
    $("#roadAddress").val("");
    $("#jibunAddress").val("");
    $("#detailAddress").val("");
}

// 이미지 초기화
function resetImage(){
	$("#profileImage").val("");
	$("#imagePreview").attr("src", "");
}


// 로그인 아이디 검사용 변수
let validLoginId = '';
// 서브밋 가능 여부
let canSubmit = true;

// 회원가입 유효성 검사 함수
const joinFormOnSubmit = function(form){
	const formFields = [
		form.loginId
		, form.loginPw
		, form.name
		, form.nickname
		, form.age
		, form.cellphoneNum
		, form.email
	];
	
	canSubmit = true;
	
	$(formFields).each(function(idx, field){
		
		// 정규표현식 검증
		const checkRegex = validateRegex($(field).val().trim(), idx);
	  	if (!checkRegex[0]) {
	  		canSubmit = false;
	  		alertMsg(checkRegex[1], "error");
	  		return field.focus();
	  	}
	  	
	  	// 공백 아님을 검증
	  	// (정규표현식에서 길이 검사도 하는데 이거 굳이 필요한가??)
	  	const checkNotBlank = validateNotBlank($(field).val().trim(), $(field).attr('data-korName'));
	  	if (!checkNotBlank[0]){
			canSubmit = false;
			alertMsg(checkNotBlank[1], "error");
	  		return field.focus();
		}
	})
	
	// 우편번호로 주소를 입력했는지 검증, 필수이기 때문
	if(!address.zonecode) {
		alert("주소를 입력해주세요.");
		return;
	}
	
	const addressToJson = JSON.stringify(address);
	form.address.value = addressToJson;
	
	if(canSubmit) {		
		form.submit();
	}
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

// 인증코드 발송 함수
let authCode = "";			// 인증코드
let isEmailSent = false;	// 인증코드를 문제없이 전송했을 때, 인증코드 발송 버튼을 막기위한 변수
function sendMailAuthCode() {
	
	const email = $("#inputEmail");
	
	const checkEmail = validateRegex(email.val().trim(), 6);
	
	if(!checkEmail[0]) {
		alertMsg(checkEmail[1], "error");
		return email.focus();
	}
	
	$("#authCodeWrap").removeClass("hidden");
	
	alertMsg("인증코드를 발송중입니다.", "default");
	
	$.ajax({
		url : "../sendMail/join",
		method : "post",
		data : {
			"email" : email.val().trim(),
		},
		dataType : "json",
		success : function(data){
			if(data.success){
				authCode = data.data;
				isEmailSent = true;
				alertMsg("발송되었습니다. 이메일을 확인해주세요.", "default");
			} else {
				authCode = "";
				isEmailSent = false;
			}
		},
		error : function(xhr, status, error){
			console.error("ERROR : " + status + " - " + error);
		}
	})
}

// 이메일 인증코드 확인 함수
function checkAuthCode() {
	if($("#authCode").val() != authCode) {
		canSubmit = false;
		isEmailSent = false;
		return alertMsg("인증코드가 일치하지 않습니다. 다시 확인해주세요.", "error");
	}
	
	alertMsg("인증되었습니다.", "success");
}

$(function(){
	$(".dupCheckBtn").click(function(){
		dupCheck($("#loginId"));
	})
	
	bindFormInputEvent($("input:not(#address input, #profileImage, #authCode)"), "input-error");
	
	$("#detailAddress").change(function(){
		address.detailAddress = $("#detailAddress").val();
	})
	
	// 이미지 미리보기
	$("#profileImage").change(function(){
		let imageFiles = $(this)[0].files;
		if (imageFiles.length > 0) {
	        const imageURL = URL.createObjectURL(imageFiles[0]);
	        console.log(imageURL);
	        $("#imagePreview").attr("src", imageURL);
	    }
	})
})