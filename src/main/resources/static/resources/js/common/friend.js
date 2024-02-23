
// 친구요청 알림 확인
function checkRequests(loginedMemberId) {
	$.ajax({
		url: '../friend/checkRequests',
	    method: 'GET',
	    data: {
	    	memberId: loginedMemberId,
	    },
	    dataType: 'json',
	    success: function(data) {
			const result = data.data;
			
			$("#notification").text("");
			
			for(let i = result.length - 1; i >= 0; i--) {
				const timeDiffSec = result[i].timeDiffSec;
				
				$("#notification").append(`
					<div class="grid items-center gap-1 my-0.5 p-0.5 text-sm text-center rounded-lg hover:bg-gray-100" style="grid-template-columns: 30px 1fr">
						<div>${i + 1}</div>
						<div class="text-left">${result[i].writerName}님의 친구요청</div>
						<div class=" col-start-2 col-end-3 flex items-center justify-between">
							<div class="text-xs">${getTimeDiff(timeDiffSec)}</div>
							<div class="flex">
								<button class="btn btn-xs btn-ghost w-6" onclick='responseFreind(${result[i].id}, ${result[i].senderId}, "accepted")'><i class="fa-solid fa-check"></i></button>
								<button class="btn btn-xs btn-ghost w-6" onclick='responseFreind(${result[i].id}, ${result[i].senderId}, "refuse")'><i class="fa-solid fa-x"></i></button>
							</div>
						</div>
					</div>
				`);
			}
			
			if(result.length > 0) {
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
				console.log("hi");
                checkRequests($(".loginedMemberId").val());
            }, 1000 * 60 * 5);
        }
	});
}

// 친구요청
function requestFriend(receiverId) {
	const senderId = $(".loginedMemberId").val();
	
	$.ajax({
		url: '../friend/sendRequest',
	    method: 'GET',
	    data: {
	    	senderId: senderId,
	    	receiverId: receiverId,
	    },
	    dataType: 'json',
	    success: function(data) {
			
			if(data.success) {
				alertMsg("친구요청 되었습니다.");
			} else {
				alertMsg(data.msg);
			}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

// 친구요청 응답
function responseFreind(id, senderId, status) {
	const receiverId = $(".loginedMemberId").val();
	
	$.ajax({
		url: '../friend/sendResponse',
	    method: 'GET',
	    data: {
			id: id,
	    	senderId: senderId,
	    	receiverId: receiverId,
	    	status: status,
	    },
	    dataType: 'json',
	    success: function(data) {
			checkRequests(receiverId);
			alertMsg(data.msg);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

// alert 창 띄우기
let alertTimeOut;
function alertMsg(msg) {
	
	if (alertTimeOut) {
		clearTimeout(alertTimeOut);
	}

	const alert = `
	    <div role="alert" class="alert">
	      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-info shrink-0 w-6 h-6">
	        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
	      </svg>
	      <span class="mx-auto">${msg}</span>
	    </div>
	`;

	$("#alert").append(alert);

	alertTimeOut = setTimeout(function() {
		$(alert).empty();
	}, 3000);
}


// 시간차
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


/* 채팅방 기능 */
// 채팅 팝업창 열기
let popup;
function openPop(requesterId, recipientId) {
	if (!popup || popup.closed) {
        let openUrl = `/usr/chat/popUp?requesterId=${requesterId}&recipientId=${recipientId}`;
        let popOption = 'width=500px, height=500px, top=200px, scrollbars=yes';
        popup = window.open(openUrl, 'pop', popOption);
    } else {
        // 팝업이 이미 열려있는 경우, 포커스를 해당 팝업으로 이동
        popup.focus();
    }
}

// 채팅 초대 알림 확인
function checkInviteRoom(loginedMemberId) {
	$.ajax({
		url: '../reqRes/checkRequests',
	    method: 'GET',
	    data: {
	    	memberId: loginedMemberId,
	    },
	    dataType: 'json',
	    success: function(data) {
			console.log(data);
			
			
			if(data.success) {
				const result = data.data;
				console.log(result);
				
				// $("#notification").text("");
				for(let i = 0; i < result.length; i++) {
					const timeDiffSec = result[i].timeDiffSec;
					
					$("#notification").append(`
						<div class="grid items-center gap-1 my-0.5 p-0.5 text-sm text-center rounded-lg hover:bg-gray-100" style="grid-template-columns: 30px 1fr">
							<div>${i + 1}</div>
							<div class="text-left">${result[i].writerName}님의 채팅방 초대</div>
							<div class=" col-start-2 col-end-3 flex items-center justify-between">
								<div class="text-xs">${getTimeDiff(timeDiffSec)}</div>
								<div class="flex">
									<button class="btn btn-xs btn-ghost w-6" onclick='responseChat(${result[i].id}, ${result[i].requesterId}, "accepted")'><i class="fa-solid fa-check"></i></button>
									<button class="btn btn-xs btn-ghost w-6" onclick='responseChat(${result[i].id}, ${result[i].requesterId}, "refuse")'><i class="fa-solid fa-x"></i></button>
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
                checkInviteRoom($(".loginedMemberId").val());
            }, 1000 * 60 * 5);
        }
	});
}

// 채팅방 초대 응답
function responseChat(id, requesterId, status) {
	const recipientId = $(".loginedMemberId").val();
	
	console.log(recipientId);
	
	$.ajax({
		url: '../chat/sendResponse',
	    method: 'GET',
	    data: {
			id: id,
	    	requesterId: requesterId,
	    	recipientId: recipientId,
	    	status: status,
	    },
	    dataType: 'json',
	    success: function(data) {
			// openPop(${result[0].requesterId}, ${result[0].recipientId})
			checkInviteRoom($("#recipientId").val());
			alertMsg(data.msg);
			
			if(data.success) {
				openPop(requesterId, recipientId);
			}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}