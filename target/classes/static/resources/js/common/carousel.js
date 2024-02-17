// common, 캐러셀 기능

$(function(){
	const carouselNo = $(".carousel-item").length; 					// 캐러셀 아이템 개수
	const cIW = parseInt($(".carousel-item:first").css("width"));	// carouselItemWidth
	let curIdx = $(".carouselRadio:checked").index();				// 캐러셀 현재 idx
	
	// 캐러셀 prev, next 버튼 클릭 시
	$(".carouselMoveBtn").click(function(){
		const btnIdx = $(this).index();
		let move = btnIdx == 0 ? `-=${cIW}` : `+=${cIW}`;
		curIdx = btnIdx == 0 ? curIdx - 1 : curIdx + 1;				// prev 버튼 클릭 시 -1, next 버튼 클릭 시 + 1
		
		if(curIdx < 0) {
			move = carouselNo * 700;
			curIdx = carouselNo - 1;
		} else if(curIdx == carouselNo) {
			move = 0;
			curIdx = 0;
		}
		
		carouselMove(curIdx, move);
	})
	
	// 캐러셀 라디오 버튼 클릭 시
	$(".carouselRadio").click(function(){
		const idx = $(this).index();
		curIdx = idx;
		const move = idx * 700;
		carouselMove(idx, move);
	})
})

// 캐러셀 아이템 이동 함수
function carouselMove(idx, move) {
	$(".carousel").animate({
		scrollLeft: move
	}, 10);
	
	$(".carouselRadio").eq(idx).prop("checked", true);
}