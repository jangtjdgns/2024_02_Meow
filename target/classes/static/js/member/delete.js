$(function(){
	let delReasons;
	
	$(".delete-reason").change(function(){
		const checkBoxIdx = $(this).parent().index();
		
	    if ($(this).is(":checked")) {
	        delReasonsArr.push(checkBoxIdx + 1);
	    } else {
	        const idx = delReasonsArr.indexOf(checkBoxIdx + 1);
	        if (idx !== -1) {
	            delReasonsArr.splice(idx, 1);
	        }
	    }
	    
		$(this).next().toggleClass("btn-active");
		
		if($(this).parent().index() == 5) {
			$("#customDeletionReason").toggleClass("hidden");
			$("#customDeletionReason>textarea").attr("disabled", function(idx, attr){
				$("#customDeletionReason>textarea").val("");
				return attr !== 'disabled';
			});
		}
		
		delReasons = delReasonsArr.join(',');
		$("#deletionReasonCode").val(delReasons);
	})
})

var delReasonsArr = [];

function deleteFormSubmit(form){
	
	if(!confirm('정말 탈퇴하시겠습니까?')) {
		return false;
	}
	
	// 공백 아님을 검증
    if(!validataNotBlank($(form.loginPw))) {
		form.loginPw.focus();
		return false;
	}
	
    // 정규표현식 검증
    if(!validataRegex($(form.loginPw), 1)) {
		form.loginPw.focus();
		return false;
	}
	
	form.loginPw.value = form.loginPw.value.trim();
	form.deletionReasonCode.value = form.deletionReasonCode.value.trim();
	
	if(form.deletionReasonCode.value.length == 0) {
		alertMsg("탈퇴 이유를 선택해주세요.", "warning");
		return false;
	}
	
	if($('.delete-reason').last().is(':checked') && form.customDeletionReason.value.length == 0) {
		alertMsg("탈퇴 이유를 작성해주세요.", "warning");
		form.customDeletionReason.focus();
		return false;
	} else {
		form.customDeletionReason.value = form.customDeletionReason.value.trim();
	}
	
	form.submit();
}