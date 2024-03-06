$(function(){
	// 프로필 페이지 사이드바 top 기본(최상위) 위치, (헤더 높이 + 3rem)		3rem == 48px 
	const defaultPos = parseFloat($(".h-mh").css("height")) + 48;
	
	const documentHeight = document.documentElement.scrollHeight;		// 문서의 전체 높이
	const totalHeight = documentHeight - window.innerHeight;			// 페이지 높이 계산
	const profileSideHeight = $("#profile-side").css("height");			// 프로필 사이드바 높이
	
	const profileContentY = [];
	
	$(".profile-content").each(function(idx, item){
		profileContentY.push(parseInt($(item).offset().top));
	});
	
	$(".side-btn").eq(0).css("backgroundColor", "oklch(0.278078 0.029596 256.848 / 0.2)");
	
	// 사이드 버튼 클릭
	$(".side-btn").each(function(idx, item){
		$(item).click(function(){
			$(".side-btn").css("backgroundColor", ""); // 사이드 버튼 색상 초기화
			
			$(item).css("backgroundColor", "oklch(0.278078 0.029596 256.848 / 0.2)");
			
			$('html, body').animate({
   				scrollTop: profileContentY[idx] - 50
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
  		
  		$(".side-btn").css("backgroundColor", "");
  		for(let i = 0; i < profileContentY.length; i++){
			if(scrollPosition <= profileContentY[i]) {
				$(".side-btn").eq(i).css("backgroundColor", "oklch(0.278078 0.029596 256.848 / 0.2)");
				break;
			}
		}
  		
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