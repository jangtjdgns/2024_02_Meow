<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<!-- 메인과 팝업은 head 분리가 필요, 기존 head를 사용하면 페이지 이동마다 소켓이 리셋됨 -->
<head>
	<meta charset="UTF-8">
	<title>Meow</title>
	<link rel="icon" href="/images/favicon/cat-pow.ico" type="image/x-icon">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/daisyui@4.6.1/dist/full.min.css" rel="stylesheet" type="text/css" />
	<script src="https://cdn.tailwindcss.com"></script>
	<script src="/js/common/dateTime.js"></script>
	<script src="/js/common/alert.js"></script>
	<script src="/js/chatPopUp.js"></script>
</head>

<body>

<section class="grid" style="width: 100%; height: 500px; grid-template-rows: 3fr 1fr;">
	<div id="chating" class="chating bg-gray-100 py-2 px-3 overflow-y-scroll"></div>
	
	<div id="yourMsg" class="m-2 flex flex-col gap-5 justify-center">
		<div class="flex gap-2">
			<textarea id="content" class="border-2 rounded-lg resize-none w-full h-12 p-2.5 text-base" onkeypress="handleEnterKey(event)" placeholder="메시지를 입력하세요."></textarea>
			<!-- <input id="content" class="input input-bordered join-item w-full" placeholder="메시지를 입력하세요." /> -->
		    <button id="sendBtn" class="btn" onclick="send()">보내기</button>
	    </div>
	    <div class="text-xs text-right">
	    	<kbd class="kbd kbd-xs">shift</kbd>
			<span>+</span>
			<kbd class="kbd kbd-xs">Enter</kbd>
			<span>줄바꿈</span>
	    </div>
	</div>
</section>

<input id="userId" type="hidden" value="${rq.loginedMemberId }" />
<input id="userName" type="hidden" value="${rq.loginedMemberNickname }" />
<input id="requesterId" type="hidden" value="${requesterId }"/>
<input id="recipientId" type="hidden" value="${recipientId }"/>
<input id="roomId" type="hidden" />

</body>
</html>