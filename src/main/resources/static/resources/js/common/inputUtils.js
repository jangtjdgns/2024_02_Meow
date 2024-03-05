/* input과 관련된 유틸리티 */


// form 관련 input, textarea 태그의 값이 변경될 때를 감지하는 이벤트 함수
function bindFormInputEvent(selector, errorClass) {
    $(selector).change(function () {
        $(this).removeClass(errorClass);
        if ($(this).val().trim().length == 0) {
            $(this).addClass(errorClass);
        }
    });
}



// Meow 정규표현식 정리 링크 [https://www.notion.so/b6a4d7b2673f440d8c363ea05094ae48?pvs=4]
const regexPatterns = [
	{
		name: "identifierRE",
		pattern: /^(?=.*[a-zA-Z])(?=.*\d).{8,20}$/,
		failedMassage: "영문자와 숫자를 최소 1개 이상 포함하며, 총 길이는 8~20글자 사이여야 합니다.",
	},
	{
		name: "passwordRE",
		pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+,./<>?={}~\[\]\s-]).{10,30}$/,
		failedMassage: "영문 대문자, 소문자, 숫자, 특수문자 모두 각각 1개 이상을 포함하며, 총 길이는 10~ 30글자 사이여야 합니다.",
	},
	{
		name: "nameRE",
		pattern: /^(?:[가-힣]{2,10}|[a-zA-Z]{2,50})$/,
		failedMassage: "한글 이름은 2~10글자 사이여야합니다. 영문 이름은 2~50글자 사이여야 합니다.",
	},
	{
		name: "nicknameRE",
		pattern: /^[가-힣a-zA-Z0-9]{2,12}$/,
		failedMassage: "닉네임 길이는 2~12글자 사이여야 합니다. 특수문자는 사용불가합니다.",
	},
	{
		name: "ageRE",
		pattern: /^\d{1,3}$|^(?!0{1,3}$)120$/,
		failedMassage: "1~120까지의 숫자만 입력이 가능합니다.",
	},
	{
		name: "cellphoneNumRE",
		pattern: /^010-\d{4}-\d{4}$/,
		failedMassage: "010-XXXX-XXXX 형식의 휴대폰 번호를 입력하세요.",
	},
	{
		name: "emailRE",
		pattern: /^[a-zA-Z0-9._%+-]{1,128}@[a-zA-Z0-9.-]{1,64}\.[a-zA-Z]{2,8}$/,
		failedMassage: "test@test.com 형식의 이메일 주소 형식을 입력하세요.",
	},
];

// 정규 표현식 검증 (Regular Expression)
function validateRegex(value, idx){
	if(regexPatterns[idx].pattern.test(value)) {
		
		return [true, "이상없음"];
	}
	
	return [false, regexPatterns[idx].failedMassage];
}


// 공백 아님을 검증
function validateNotBlank(value, name){
	
	if(value.length > 0) {
		console.log(value)
		return [true, "이상없음"];
	}
	
	return [false, name + "을(를) 입력해주세요."];
}