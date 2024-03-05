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
	
	let canSubmit = true;
	
	$(formFields).each(function(idx, field){
		
		// 정규표현식 검증
		const checkRegex = validateRegex($(field).val().trim(), idx);
	  	if (!checkRegex[0]) {
	  		canSubmit = false;
	  		alertMsg(checkRegex[1], "error");
	  		return field.focus();
	  	}
	  	
	  	// 공백 아님을 검증
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

$(function(){
	$(".dupCheckBtn").click(function(){
		dupCheck($("#loginId"));
	})
	
	bindFormInputEvent($("input:not(#address input, #profileImage)"), "input-error");
	
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