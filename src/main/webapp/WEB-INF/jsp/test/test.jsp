<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.6.1/dist/full.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>

<meta charset="UTF-8">
	<title>Chating</title>
	<style>
		*{
			margin:0;
			padding:0;
		}
		.container{
			width: 500px;
			margin: 0 auto;
			padding: 25px
		}
		.container h1{
			text-align: left;
			padding: 5px 5px 5px 15px;
			color: #FFBB00;
			border-left: 3px solid #FFBB00;
			margin-bottom: 20px;
		}
		
		.chating{
			border: 2px solid;
			width: 500px;
			height: 500px;
			overflow: auto;
		}
		
		input{
			width: 330px;
			height: 25px;
		}
		#yourMsg{
			display: none;
		}
	</style>
</head>

<script type="text/javascript">
	var ws;	// 웹소켓 담을 변수
	var message = {			// 웹소캣 메시지 객체
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
		ws.onopen = function(data){
			$("#chating").append("<p>" + $("#roomId").val() + "번 방 입장</p>");
		}
		
		// 웹소켓이 메시지를 수신할 때 호출되는 함수
		ws.onmessage = function(data) {
			var jsonData = JSON.parse(data.data);		// 수신된 데이터에서 메시지를 추출하고, json형태의 문자열을 객체로 변환
			const nickname = jsonData.sender;
			const msg = jsonData.content;
			const type = jsonData.type;
			
			
			if(msg != null && msg.trim() != '' && type == 'send'){		// 메시지가 비어 있지 않으면 화면에 메시지 추가
				$("#chating").append(`
					<div class="chat chat-start">
					    <div class="chat-image avatar">
					        <div class="w-10 rounded-full">
					            <img alt="Tailwind CSS chat bubble component" src="https://daisyui.com/images/stock/photo-1534528741775-53994a69daeb.jpg" />
					        </div>
					    </div>
					    <div class="chat-header">
					        \${nickname}
					        <time class="text-xs opacity-50">12:45</time>
					    </div>
					    <div class="chat-bubble break-all">\${msg}</div>
					    <div class="chat-footer opacity-50">전송됨</div>
					</div>
				`);
			}
			
			if(type != 'send') {
				$("#chating").append(`
					<div class="py-1 flex justify-center">
						<div class="chat-bubble row-start-1 row-end-3 justify-center">\${nickname} \${msg}</div>
					</div>
				`);
			}
		}
		
		// 엔터 클릭 시 메시지 전송
		document.addEventListener("keypress", function(e){
			if(e.keyCode == 13){ //enter press
				send();
			}
		});
	}
	
	
	// 사용자 이름 입력 및 웹소켓 열기
	
	function chatName(roomId){
		var userName = $("#userName").val();			// 사용자 이름
		if(userName == null || userName.trim() == ""){	// 사용자 이름이 비어있으면 이름 입력
			alert("사용자 이름을 입력해주세요.");
			$("#userName").focus();
		}else{											// 사용자 이름이 비어있지 않으면 웹소켓 열기
			wsOpen(roomId);
			//$("#yourName").hide();
			$("#yourMsg").show();
		}
	}
	
	// 메시지 전송 함수
	function send() {
		message.sender = $("#userName").val();		// 사용자 이름
		message.content = $("#chatting").val();		// 내용
		message.type = "send";						// 메시지 타입
		ws.send(JSON.stringify(message));			// 웹소켓을 통해 메시지 전송
		$('#chatting').val("");						// 메시지 입력 폼 초기화
	}
	
	// 웹소켓 종료 함수
	function closeWebSocket() {
		// 채팅방을 나갈 때
		window.location.replace("/");
	}
	
	$(function(){
		$("#roomBtn").click(function(){
			chatName($("#roomId").val());
		});
		
		$(window).on('beforeunload', function() {
			if (ws) {
		        return ' ';
		    }
		});
	})
</script>
<body>
	<div id="container" class="container">
		<h1>채팅</h1>
		<div id="chating" class="chating">
		</div>
		
		<div id="yourMsg">
			<table class="inputTable">
				<tr>
					<th>메시지</th>
					<th><input id="chatting" placeholder="보내실 메시지를 입력하세요."></th>
					<th><button onclick="send()" id="sendBtn">보내기</button></th>
				</tr>
			</table>
		</div>
	</div>
	<button onclick="closeWebSocket();">웹소켓 닫기</button>
	
	<input type="text" name="userName" id="userName" value="${rq.loginedMemberNickname }" />
	<input type="text" id="roomId" value="1"/>
	<button id="roomBtn">연결</button>
</body>
</html>