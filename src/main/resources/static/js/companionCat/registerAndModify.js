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

// 이미지 초기화
function resetImage(){
	$("#profileImage").val("");
	$("#imagePreview").attr("src", "");
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
	
	// 이미지 미리보기
	$("#profileImage").change(function(){
		let imageFiles = $(this)[0].files;
		if (imageFiles.length > 0) {
	        const imageURL = URL.createObjectURL(imageFiles[0]);
	        $("#imagePreview").attr("src", imageURL);
	    }
	})
})