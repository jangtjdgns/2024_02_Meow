<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script>
	function scrollToBottom(topBot) {
		const posY = topBot == 'top' ? 0 : document.body.scrollHeight;
	    $('html, body').animate({
				scrollTop: posY,
		}, 800);
	}
</script>

<div class="fixed bottom-6 right-10 flex flex-col z-50 bg-white bg-opacity-70">
	<button class="btn btn-sm btn-outline rounded-b-none border-b-0" onclick="scrollToBottom('top')"><i class="fa-solid fa-angle-up"></i></button>
	<button class="btn btn-sm btn-outline rounded-t-none" onclick="scrollToBottom('bot')"><i class="fa-solid fa-angle-down"></i></button>
</div>