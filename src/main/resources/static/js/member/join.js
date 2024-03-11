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


/* 회원가입 */
let validLoginId = '';				// 로그인 아이디 검사용 변수
let isDupChecked = [false, false];	// 중복 확인 되었는지 여부, [아이디, 닉네임]
let isPwConfirmed = false;			// 비밀번호 확인되었는지 여부
let isCodeConfirmed = false;		// 이메일 인증코드 확인 되었는지 여부

// 회원가입 유효성 검사 함수
const joinFormOnSubmit = function(form){
	const formFields = [
		form.loginId,
		form.loginPw,
		form.name,
		form.nickname,
		form.age,
		form.cellphoneNum,
		form.email
	];
	
	for (let i = 0; i < formFields.length; i++) {
	    const field = formFields[i];
		
		// 공백 아님을 검증
	    if(!validataNotBlank($(field))) {
			return field.focus();
		}
		
	    // 정규표현식 검증
	    if(!validataRegex($(field), i)) {
			return field.focus();
		}
  	}
	
	// 우편번호로 주소를 입력했는지 검증, 필수이기 때문
	if(!address.zonecode) {
		alertMsg("주소를 입력해주세요.", "error");
		return $(".find-postal-code").focus();
	}
	
	const addressToJson = JSON.stringify(address);
	form.address.value = addressToJson;
	
	// 중복 확인(로그인 아이디)
	if(!isDupChecked[0]) {
		alertMsg("아이디 중복 확인을 진행해주세요.", "error");
		return formFields[0].focus();
	}
	
	// 중복 확인(닉네임)
	if(!isDupChecked[1]) {
		alertMsg("닉네임 중복 확인을 진행해주세요.", "error");
		return formFields[3].focus();
	}
	
	// 비밀번호 확인
	checkPw();
	if(!isPwConfirmed) {
		alertMsg("비밀번호가 일치하지 않습니다.", "error");
		return $("#loginPwChk").focus();
	}
	
	// 이메일 인증 코드 확인
	if(!isCodeConfirmed) {
		alertMsg("이메일 인증 코드가 일치하지 않습니다.", "error");
		return $("#authCode").focus();
	}
	
	form.submit();
}

// 중복확인
function dupCheck(type, input){
	const inputName = type == 'loginId' ? '아이디' : '닉네임';
	const regIdx = type == 'loginId' ? 0 : 3;
	
	$.ajax({
		url : "../member/duplicationCheck",
		method : "get",
		data : {
			"type": type,
			"inputVal" : input.val().trim(),
		},
		dataType : "json",
		success : function(data){
			const success = data.success;
			
			if(!validataNotBlank(input)){
				return input.focus();
			}
			
			if(!validataRegex(input, regIdx)) {
				return input.focus();
			}
			
			if(type == "loginId") {
				validLoginId = success ? input.val().trim() : '';
				isDupChecked[0] = success;
			} else {
				isDupChecked[1] = success;
			}
			
			const msg = success ? `사용가능한 ${inputName} 입니다.` : `사용할 수 없는 ${inputName} 입니다.`;
			const alertType = success ? 'success' : 'error';
			changeInputBorderColor(input, success, "input-error");
			alertMsg(msg, alertType);
			return input.focus();
		},
		error : function(xhr, status, error){
			console.error("ERROR : " + status + " - " + error);
		}
	})
}

// 비밀번호 확인
function checkPw(){	
	let loginPw = $("#loginPw").val().trim();
	let loginPwChk = $("#loginPwChk").val().trim();
	
	isPwConfirmed = true;
	
	if(loginPw.length != 0 && (loginPw != loginPwChk)) {
		isPwConfirmed = false;
		return alertMsg("비밀번호가 일치하지 않습니다.", "error");
	}
}


// 인증코드 발송 함수
let authCode = "";			// 인증코드
let isEmailSent = false;	// 인증코드를 문제없이 전송했을 때, 인증코드 발송 버튼을 막기위한 변수
function sendMailAuthCode() {
	
	const email = $("#inputEmail");
	const checkEmail = validataRegex(email, 6);
	if(!checkEmail) return email.focus();	// 정규식 통과못하면 return
	
	alertMsg("", "loading");
	$(".senMailBtn").attr("disabled", true);
	
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
				$("#authCodeWrap").removeClass("hidden");
				alertMsg(data.msg, "default");
			} else {
				authCode = "";
				isEmailSent = false;
				alertMsg(data.msg, "warning");
			}
			
			$(".senMailBtn").attr("disabled", isEmailSent);
		},
		error : function(xhr, status, error){
			console.error("ERROR : " + status + " - " + error);
		}
	})
}

// 이메일 인증코드 확인 함수
function checkAuthCode() {
	isCodeConfirmed = true;
	
	if($("#authCode").val() != authCode) {
		isCodeConfirmed = false;
		isEmailSent = false;
		return alertMsg("인증코드가 일치하지 않습니다. 다시 확인해주세요.", "error");
	}
	
	$("#authCode").attr("disabled", true);
	alertMsg("인증되었습니다.", "success");
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

$(function(){
	
	// 중복확인 버튼 클릭 시
	$(".dupCheckBtn").click(function(){
		const type = $(this).attr("data-input");  
		dupCheck(type, $(`#${type}`));
	})
	
	// 중복확인란 값 변경 시
	$(".dupInput").change(function(){
		$(this).attr("id") == 'loginId' ? isDupChecked[0] : isDupChecked[1];
	})
	
	// 비밀번호 확인
	$("#loginPwChk").change(function(){
		checkPw();
	})
	
	// 인풋 태그 변경 감지
	bindFormInputEvent($("input:not(.no-validation)"), "input-error");
	
	// 주소 변경 될 때
	$("#detailAddress").change(function(){
		address.detailAddress = $("#detailAddress").val();
	})
	
	// 이메일이 변경될 때
	$("#inputEmail").change(function(){
		isEmailSent = false;
		$("#authCodeWrap>input").val("");
		$(".senMailBtn").attr("disabled", false);
		$("#authCode").attr("disabled", false);
		$("#authCodeWrap").addClass("hidden");
	})
	
	// 이미지 미리보기
	$("#profileImage").change(function(){
		let imageFiles = $(this)[0].files;
		if (imageFiles.length > 0) {
	        const imageURL = URL.createObjectURL(imageFiles[0]);
	        $("#imagePreview").attr("src", imageURL);
	    }
	})
})