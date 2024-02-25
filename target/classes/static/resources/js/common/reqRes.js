// 초대 알림 확인
function checkRequests(loginedMemberId) {
	
	$.ajax({
		url: '../reqRes/checkRequests',
	    method: 'GET',
	    data: {
	    	memberId: loginedMemberId,
	    },
	    dataType: 'json',
	    success: function(data) {
			$("#notification").text("");
			
			if(data.success) {
				const result = data.data;
				
				for(let i = 0; i < result.length; i++) {
					const timeDiffSec = result[i].timeDiffSec;
					
					$("#notification").append(`
						<div class="grid items-center gap-1 my-0.5 p-0.5 text-sm text-center rounded-lg hover:bg-gray-100" style="grid-template-columns: 30px 1fr">
							<div>${i + 1}</div>
							<div class="text-left">${result[i].writerName}님의 ${result[i].code == 'friend' ? '친구' : '채팅방 초대'} 요청</div>
							<div class=" col-start-2 col-end-3 flex items-center justify-between">
								<div class="text-xs">${getTimeDiff(timeDiffSec)}</div>
								<div class="flex">
									<button class="btn btn-xs btn-ghost w-6" onclick='sendResponse(${result[i].id}, ${result[i].requesterId}, "accepted", "${result[i].code}")'><i class="fa-solid fa-check"></i></button>
									<button class="btn btn-xs btn-ghost w-6" onclick='sendResponse(${result[i].id}, ${result[i].requesterId}, "refuse", "${result[i].code}")'><i class="fa-solid fa-x"></i></button>
								</div>
							</div>
						</div>
					`);
				}
				
				$("#notification-count").removeClass("hidden");
				$("#notification-count").text(result.length);
			} else {
				$("#notification-count").addClass("hidden");
				$("#notification").append(`
					<div class="text-center">현재 알림이 없습니다.</div>
				`)
			}
		},
	    error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
		complete: function() {
            // 일정 시간 간격으로 주기적으로 다시 요청
            setTimeout(function() {
                checkRequests(loginedMemberId);
            }, 1000 * 60 * 5);
        }
	});
}

// 요청
function sendRequest(recipientId, code) {
	const requesterId = loginedMemberId;
	
	$.ajax({
		url: '../reqRes/sendRequest',
	    method: 'GET',
	    data: {
	    	requesterId: requesterId,
	    	recipientId: recipientId,
	    	code: code,
	    },
	    dataType: 'json',
	    success: function(data) {
			alertMsg(data.msg);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

// 응답
function sendResponse(id, requesterId, status, code) {
	const recipientId = loginedMemberId;
	
	$.ajax({
		url: '../reqRes/sendResponse',
	    method: 'GET',
	    data: {
			id: id,
	    	requesterId: requesterId,
	    	recipientId: recipientId,
	    	status: status,
	    	code: code,
	    },
	    dataType: 'json',
	    success: function(data) {
			// openPop(${result[0].requesterId}, ${result[0].recipientId})
			checkRequests($("#recipientId").val());
			alertMsg(data.msg);
			
			if(status == 'accepted' && code == 'chat') {
				openPop(requesterId, recipientId);
			}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}


// 시간차 계산 (요청 시간)
function getTimeDiff(time) {
    let timeDiffSec;
    const minute = 60;				// 분
    const hour = 60 * minute;		// 시간
    const day = 24 * hour;			// 일

	timeDiffSec = parseInt(time / minute)+ "분 전";
	
	if (time >= hour) {
        timeDiffSec = parseInt(time / hour) + "시간 전";
    }
    
    if (time >= day) {
        timeDiffSec = parseInt(time / day) + "일 전";
    }

    return timeDiffSec;
}


// 채팅 팝업창 열기 (채팅 요청 수락)
let popup;
function openPop(requesterId, recipientId) {
    let openUrl = `/usr/chat/popUp?requesterId=${requesterId}&recipientId=${recipientId}`;
    let popOption = 'width=500px, height=500px, top=200px, scrollbars=yes';
    popup = window.open(openUrl, 'pop', popOption);
}