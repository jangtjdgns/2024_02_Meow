/**
 * 반려묘 등록, 수정 js
 */

// 등록, 수정 둘다 동일함 
const registerFormOnSubmit = function(form){
	
	if(!validataNotBlank($(form.name))) {
		return form.name.focus();
	}
	
	if(!validataRegex($(form.name), 2)) {
		return form.name.focus();
	}
	
	if(form.aboutCat.value.trim().length > 100) {
		alertMsg("최대 300글자 까지 입력가능합니다.");
		return form.aboutCat.focus();
	}
	
	form.submit();
}

$(function(){
	// 반려묘 등록 시에만 현재 날짜로 변경 
	const today = new Date().toISOString().substring(0,10);
	$('#birthDate-reg').val(today);
	$('#birthDate-reg').attr("max", today);
	
	// 이름 변경시
	$("#name").change(function(){
		const name = $(this).val().trim();
		
		if(validataRegex($(this), 2) && name.length > 0) {
			const fc = msgByFinalConsonant($(this).val().trim(), 1);
			$("#aboutCat").attr("placeholder", `${name}${fc} 소개해보세요!`);
		}
	});
})