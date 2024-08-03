// Reaction(반응) js

// 반응 기록 확인
const getReaction = function(relTypeCode, reactionType, relId){
	
	$.ajax({
		url: "../reaction/getReaction",
		method: "get",
		data: {
			"relTypeCode": relTypeCode,
			"relId": relId,
			"reactionType": reactionType,
		},
		dataType: "json",
		success: function(data) {
			let reactionBtn = reactionType == 0 ? `reactionLikeBtn-${relTypeCode}-${relId}` : `reactionDislikeBtn-${relTypeCode}-${relId}`;
			
			$("#" + reactionBtn + ">.reactionCount-" + relTypeCode).text(data.data);
			if(data.success) {
				$('#' + reactionBtn).addClass('btn-active');
			}
		},
		error: function(xhr, status, error){
			console.error("ERROR : " + status + " - " + error);
		}
	})
}

// 반응 등록 & 반응 취소
const doReaction = function(relTypeCode, reactionType, relId) {
	let reactionBtn = reactionType == 0 ? `reactionLikeBtn-${relTypeCode}-${relId}` : `reactionDislikeBtn-${relTypeCode}-${relId}`;
	let reactionStatus = $('#' + reactionBtn).hasClass('btn-active');
	
	/* 좋아요와 싫어요는 동시에 누를 수 없기 때문에 검증 */
	// + 이거 라디오 버튼으로 하면 더 쉬웠지 않았을까.(24.03.19)
	// 이미 반응을 한 상태인지 확인(좋아요 & 싫어요 클릭 했는지 확인)
	const alreadyReacted = $(`.reactionBtn-${relTypeCode}-${relId}`).hasClass("btn-active");
	const alreadyReactedBtnIdx = $(`.reactionBtn-${relTypeCode}-${relId}.btn-active`).index();
	
	// 이미 반응한 경우
	if(alreadyReacted) {
		// 현재 클릭한 반응 타입과, 버튼 인덱스가 동일하지 않음을 확인 (즉, 좋아요 반응을 한 상태에서 싫어요 반응을 하는 상황)
		if(alreadyReactedBtnIdx != -1 && reactionType != alreadyReactedBtnIdx) {
			$.ajax({
				url : "../reaction/doReaction",
				method : "get",
				data : {
					"relId" : relId,
					"relTypeCode" : relTypeCode,
					"reactionType": alreadyReactedBtnIdx,
					"reactionStatus": alreadyReacted,
				},
				dataType : "json",
				success : function(data) {
					$(`.reactionBtn-${relTypeCode}-${relId}`).eq(reactionType == 0 ? 1 : 0).removeClass('btn-active');
					$(`.reactionBtn-${relTypeCode}-${relId}>.reactionCount-${relTypeCode}`).eq(alreadyReactedBtnIdx).text(data.data);
				},
				error : function(xhr, status, error){
					console.error("ERROR : " + status + " - " + error);
				}
			})
		}
	}
	
	$.ajax({
		url : "../reaction/doReaction",
		method : "get",
		data : {
			"relId" : relId,
			"relTypeCode" : relTypeCode,
			"reactionType": reactionType,
			"reactionStatus": reactionStatus,
		},
		dataType : "json",
		success : function(data) {
			$('#' + reactionBtn).toggleClass('btn-active');
			alertMsg(data.msg, "success");
			$(`.reactionBtn-${relTypeCode}-${relId}>.reactionCount-${relTypeCode}`).eq(reactionType).text(data.data);
		},
		error : function(xhr, status, error){
			console.error("ERROR : " + status + " - " + error);
		}
	})
}