/** 
 * 비밀번호 재설정 js
 */

let memberId = 0;
// 비밀번호 재설정 이메일 인증 코드 발송
let authCode = "";			// 인증코드
let isEmailSent = false;	// 인증코드를 문제없이 전송했을 때, 인증코드 발송 버튼을 막기위한 변수
function resetLoginPw(){
    if (!validataNotBlank($("#name")) || !validataNotBlank($("#loginId")) || !validataNotBlank($("#email"))) return;	// 공백 검증
	if (!validataRegex($("#name"), 2) || !validataRegex($("#loginId"), 0) || !validataRegex($("#email"), 6)) return;	// 정규표현식 검증
	
	$(".findBtn").attr("disabled", true);
	
	alertMsg("", "loading");
	
	$.ajax({
		url: '../sendMail/resetPassword',
	    method: 'GET',
	    data: {
	    	"name": $("#name").val().trim(),
	    	"loginId": $("#loginId").val().trim(),
			"email": $("#email").val().trim(),
	    },
	    dataType: 'json',
	    success: function(data) {
	    	const alertType = data.success ? "success" : "error";
	    	
	    	$(".findBtn").attr("disabled", false);
	    	
			isEmailSent = true;

			if(data.success){
				const result = data.data;
				authCode = result.authCode;
				memberId = result.id;
				isEmailSent = true;
				$("#authCodeWrap").removeClass("hidden");
				$(".resetPwBtn").attr("disabled", true);
			} else {
				authCode = "";
				memberId = 0;
				isEmailSent = false;
			}
			
			alertMsg(data.msg, alertType);
			$(".sendMailBtn").attr("disabled", isEmailSent);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

// 이메일 인증코드 확인 함수
function checkAuthCode() {
	
	if($("#authCode").val() != authCode) {
		isEmailSent = false;
		isPwConfirmed = false;
		$("#resetPwWrap").addClass("hidden");
		return alertMsg("인증코드가 일치하지 않습니다. 다시 확인해주세요.", "error");
	}
	
	$("#authCode").attr("disabled", true);
	alertMsg("인증되었습니다.", "success");
	$("#resetPwWrap").removeClass("hidden");
}

// 비밀번호 확인
isPwConfirmed = false;
function checkPw(){	
	let resetPw = $("#resetPw").val().trim();
	let resetPwChk = $("#resetPwChk").val().trim();
	
	isPwConfirmed = true;
	
	if(resetPw.length != 0 && (resetPw != resetPwChk)) {
		isPwConfirmed = false;
		alertMsg("비밀번호가 일치하지 않습니다.", "error");
	}
	
	$(".resetPwBtn").attr("disabled", !isPwConfirmed);
}


// 비밀번호 재설정 함수
function doResetPw() {
	checkPw();
	
    if(!validataRegex($("#resetPw"), 1) || !validataRegex($("#resetPwChk"), 1)) return isPwConfirmed = false;
	if(!isPwConfirmed) return;
	
	$.ajax({
		url: '../doReset/loginPw',
	    method: 'POST',
	    data: {
			memberId: memberId,
			resetLoginPw: $("#resetPw").val().trim(),
	    },
	    dataType: 'json',
	    success: function(data) {
			console.log(data);
			
			if(data.success) {
				alert(data.msg);
				location.replace("/");
			} else {
				alertMsg(data.msg, "error");
				isPwConfirmed = false;
				$("#resetPwWrap>input").val("");
			}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}


$(function(){
	bindFormInputEvent($(".input"), "input-error");
	
	// 비밀번호 확인
	$("#resetPwChk").change(function(){
		
		checkPw();
	})
	
	// 이메일이 변경될 때
	$("#email").change(function(){
		isEmailSent = false;
		isPwConfirmed = false;
		$("#authCodeWrap>input").val("");
		$(".senMailBtn").attr("disabled", false);
		$("#authCode").attr("disabled", false);
		$("#authCodeWrap").addClass("hidden");
		$("#resetPwWrap").addClass("hidden");
		$("#resetPwWrap>input").val("");
	})
})