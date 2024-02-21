let ws;	// 웹소켓 담을 변수
let message = {			// 웹소캣 메시지 객체
  	sender: '',
 	content: '',
 	type: '',
};

// 웹 소켓 오픈 함수
function wsOpen(roomId){
	// 현재 호스트와 "/chating/{roomId}" 엔드포인트에 대한 웹소켓 생성
	ws = new WebSocket("ws://" + location.host + "/chating/" + roomId);
	
	// 웹소켓 이벤트 함수 호출
	wsEvt();
}

// 웹소켓 이벤트 함수
function wsEvt() {
	
	// 웹소켓이 열릴 때 호출되는 함수
	ws.onopen = function(data) {
		const msg = 1 + "번 방 입장";
		$("#chating").append(`
			<div class="flex justify-center p-2">
				<div class="badge badge-neutral">${msg}</div>
			</div>
		`);
	}
	
	// 웹소켓이 메시지를 수신할 때 호출되는 함수
	ws.onmessage = function(data) {
		const jsonData = JSON.parse(data.data);		// 수신된 데이터에서 메시지를 추출하고, json형태의 문자열을 객체로 변환
		const nickname = jsonData.sender;
		let msg = jsonData.content.replace(/\n/g, '<br>');	// 줄바꿈 감지
		const type = jsonData.type;		
		
		if(type == 'send'){		// 메시지가 비어 있지 않으면 화면에 메시지 추가
			
			// 내가 보낸 메시지인지 확인
			const startEnd = nickname == $("#userName").val() ? "end" : "start";
			
			$("#chating").append(`
				<div class="chat chat-${startEnd}">
				    <div class="chat-image avatar">
				        <div class="w-10 rounded-full">
				            <img alt="Tailwind CSS chat bubble component" src="https://daisyui.com/images/stock/photo-1534528741775-53994a69daeb.jpg" />
				        </div>
				    </div>
				    <div class="chat-header">
				        ${nickname}
				    </div>
				    <div class="chat-bubble break-all msg">${msg}</div>
				    <div class="chat-footer opacity-50">
						<time class="text-xs opacity-50">${getDateTime('hours')}:${getDateTime('minutes')}</time>
					</div>
				</div>
			`);
			
			// 메시지 작성 때마다 스크롤 맨 아래로 내리기
			$("#chating").animate({ scrollTop: $("#chating")[0].scrollHeight }, "slow");
		}
		
		if(type != 'send') {
			$("#chating").append(`
				<div class="py-1 flex justify-center">
					<div class="chat-bubble row-start-1 row-end-3 justify-center">${nickname} ${msg}</div>
				</div>
			`);
		}
	}
}


// 사용자 이름 입력 및 웹소켓 열기
function chatName(roomId){
	let userName = $("#userName").val();			// 사용자 이름
	if(userName == null || userName.trim() == ""){	// 사용자 이름이 비어있으면 이름 입력
		alert("사용자 이름을 입력해주세요.");
		$("#userName").focus();
	} else {										// 사용자 이름이 비어있지 않으면 웹소켓 열기
		wsOpen(roomId);
		//$("#yourName").hide();
		$("#yourMsg").show();
	}
}

// 메시지 전송 함수
function send() {
	let content = $("#content").val();			// 내용
	
	// 입력 안했을떄 검증
	if(content.trim().length == 0) {
		return;
	}
	
	message.sender = $("#userName").val();		// 사용자 이름
	message.content = content;
	message.type = "send";						// 메시지 타입
	ws.send(JSON.stringify(message));			// 웹소켓을 통해 메시지 전송
	$('#content').val("");						// 메시지 입력 폼 초기화
}

// 메시지 입력 검사
function msgLengthCheck(){
	const isEmpty = $("#content").val().length == 0 ? true : false;
	$("#sendBtn").attr("disabled", isEmpty);
}

// textarea 줄바꿈 (엔터키 감지)
function handleEnterKey(event) {
	if (event.key === 'Enter' && event.shiftKey) {		// shift + enter = 줄바꿈
        let content = $("#content").val();
        content += '\n';
        $("#content").val(content);
        event.preventDefault();
    } else if (event.key === 'Enter') {					// enter = 메시지 전송
		send();
        event.preventDefault();
    }
}

$(function(){
	wsOpen("1");
	
	// 채팅방(팝업)을 닫을 때
	$(window).on('beforeunload', function() {
		if (ws) {
	        return ' ';
	    }
	});
	
	// 메시지 입력 감지
	msgLengthCheck();
	$('#content').on('input', function() {
    	msgLengthCheck();
  	});
	
})