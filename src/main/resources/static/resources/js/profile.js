$(function(){
	const documentHeight = document.documentElement.scrollHeight;		// 문서의 전체 높이
	const headerHeight = $(".h-mh").css("height");						// 헤더 높이
	
	// 프로필 페이지 사이드바 top 기본(최상위) 위치, (헤더 높이 + 3rem)		3rem == 48px 
	const defaultPos = parseFloat($(".h-mh").css("height")) + 48;
	
	const totalHeight = documentHeight - window.innerHeight;		// 페이지 높이 계산, -50px(여유분)
	
	const profileSideHeight = $("#profile-side").css("height");			// 프로필 사이드바 높이
	
	const profileY = parseInt($("#profile-image-wrap").offset().top);	// 내정보, 프로필 위치
	const aboueMeY = parseInt($("#about-me-wrap").offset().top);		// 내정보, 소개말 위치
	const optionY = parseInt($("#option-wrap").offset().top);			// 내정보, 계정관리 위치

	// 사이드 버튼 클릭
	$(".side-btn").each(function(idx, item){
		$(item).click(function(){
			let scrT = 0;
			if(idx == 0) {
				scrT = profileY;
			} else if(idx == 1) {
				scrT = aboueMeY;
			} else {
				scrT = optionY;
			}
			
			$('html, body').animate({
   				scrollTop: scrT - 50
			}, 800);
		})
	});
	
	// top, bottom 이동 버튼
	$(".top-bot-btn").each(function(idx, item){
		$(item).click(function(){
			const pos = idx == 0 ? 0 : totalHeight;
			
			$('html, body').animate({
	   			scrollTop: pos
			}, 800);
		})
	})
	
	// 스크롤 감지
	$(window).scroll(function() {
        // 현재 스크롤 위치
        const scrollPosition = parseInt($(window).scrollTop());
  
        if(scrollPosition > defaultPos) {
        	parseInt($("#profile-side").css("top", scrollPosition + 50));
        } else {
        	// 현재 스크롤 위치가 0일때
        	parseInt($("#profile-side").css("top", defaultPos));
        }
        
        // 현재 스크롤 위치가 끝부분일 때, calc((현재 스크롤 위치 + 브라우저 높이) - 프로필 사이드바 높이 - padding-bottom)
        if(scrollPosition >= totalHeight) {
        	parseInt($("#profile-side").css("top", `calc(${scrollPosition + window.innerHeight}px - ${profileSideHeight} - 11rem)`));
        }
	});
})