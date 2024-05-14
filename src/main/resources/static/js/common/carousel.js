// common, 캐러셀 기능

let curIdx = 0;		// 캐러셀 현재 idx 전역

$(function(){
	carouselMove(0, 0);			// 맨 앞으로 초기화
	
	const carouselSize = $(".carousel-item").length; 							// 캐러셀 아이템 개수
	let carouselWidth = parseInt($(".carousel-item:first").css("width"));	// 캐러셀 너비
	curIdx = $(".carouselRadio:checked").index();							// 캐러셀 현재 idx
	
	// 캐러셀 prev, next 버튼 클릭 시
	$(".carouselMoveBtn").click(function(){
		const btnIdx = $(this).index();
		
		let move = btnIdx == 0 ? `-=${carouselWidth}` : `+=${carouselWidth}`;
		curIdx = btnIdx == 0 ? curIdx - 1 : curIdx + 1;				// prev 버튼 클릭 시 -1, next 버튼 클릭 시 + 1
		
		if(curIdx < 0) {
			move = carouselSize * carouselWidth;
			curIdx = carouselSize - 1;
		} else if(curIdx == carouselSize) {
			move = 0;
			curIdx = 0;
		}
		
		carouselMove(curIdx, move);
	})
	
	// 캐러셀 라디오 버튼 클릭 시
	$(".carouselRadio").click(function(){
		curIdx = parseInt($(this).data('idx'));
		carouselWidth = $('.carousel').width();
		const move = curIdx * carouselWidth;
		carouselMove(curIdx, move);
	})
	
	// 쉬프트+휠 할때의 curIdx 구하기
	/*$('.carousel').on('wheel', function(event) {
	    if (event.shiftKey) {
			setTimeout(function(){
				console.log($(".carousel").scrollLeft());
			}, 600)
		}
	});*/
})

// 캐러셀 아이템 이동 함수
function carouselMove(idx, move) {
	$(".carousel").animate({
		scrollLeft: move
	}, 10);
	
	$(".carouselRadio").eq(idx).prop("checked", true);
}


// 캐러셀 자동 움직임 함수 (캐러셀 아이템 개수, 수평 여부(true 수평, flase 수직), 캐러셀 길이 or 높이, 반복 시간)
let carouselInterval;
function playCarousel(size, isHorizontal, len, time) {
	if (carouselInterval) clearInterval(carouselInterval);
	
	$('.carousel-playStop').removeClass('btn-active');
	$('#carousel-play').addClass('btn-active')
	
	carouselInterval = setInterval(function() {
		curIdx = curIdx == size - 1 ? 0 : curIdx + 1;
		$('.carouselRadio').eq(curIdx).prop('checked', true);
		
		let move = isHorizontal ? $(".carousel").scrollLeft() + len : $(".carousel").scrollTop() + len;
		move = move >= size * len ? 0 : move;
		
		carouselWidth = len;
		
		let animate = isHorizontal ? {scrollLeft: move} : {scrollTop: move};		
		$(".carousel").animate(animate, 10);
	}, time)
}

// 캐러셀 inertval 정지 버튼
function stopCarousel() {
	$('.carousel-playStop').removeClass('btn-active');
	$('#carousel-stop').addClass('btn-active');
	clearInterval(carouselInterval); 
}