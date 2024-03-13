/** 
 * 아이디 찾기 js
 */

// 아이디 찾기
function findLoginId(){
    if (!validataNotBlank($("#name")) || !validataNotBlank($("#email"))) return;	// 공백 검증
	if (!validataRegex($("#name"), 2) || !validataRegex($("#email"), 6)) return;	// 정규표현식 검증
	
	$(".findBtn").attr("disabled", true);
	
	alertMsg("", "loading");
	
	$.ajax({
		url: '../doFind/loginId', 
	    method: 'GET',
	    data: {
	    	"name": $("#name").val().trim(),
			"email": $("#email").val().trim(),
	    },
	    dataType: 'json',
	    success: function(data) {
	    	const alertType = data.success ? "success" : "error";
	    	alertMsg(data.msg, alertType);
	    	$(".findBtn").attr("disabled", false);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

$(function(){
	bindFormInputEvent($(".input"), "input-error");
})