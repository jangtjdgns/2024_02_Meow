$(function(){
	var delReasons;
	
	$(".checkbox").change(function(){
		const checkBoxIdx = $(this).parent().index();
		
	    if ($(this).is(":checked")) {
	        delReasonsArr.push(checkBoxIdx + 1);
	    } else {
	        const idx = delReasonsArr.indexOf(checkBoxIdx + 1);
	        console.log(idx)
	        if (idx !== -1) {
	            delReasonsArr.splice(idx, 1);
	        }
	    }
		
		$(this).next().toggleClass("btn-active");
		
		if($(this).parent().index() == 5) {
			$("#customDeletionReason").toggleClass("hidden");
			$("#customDeletionReason").attr("disabled", function(idx, attr){
				$("#customDeletionReason").val("");
				return attr !== 'disabled';
			});
		}
		
		delReasons = delReasonsArr.join(',');
		$("#deletionReasonCode").val(delReasons);
	})
})

var delReasonsArr = [];

function deleteFormSubmit(form){
	form.deletionReasonCode.value = form.deletionReasonCode.value.trim();
	
	if(form.deletionReasonCode.value.length == 0) {
		alert("탈퇴 이유를 선택해주세요.");
		return;
	}
	
	if(form.customDeletionReason.value.length != 0) {
		form.customDeletionReason.value = form.customDeletionReason.value.trim();
	}
	
	form.submit();
}