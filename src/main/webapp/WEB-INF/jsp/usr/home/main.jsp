<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../common/header.jsp"%>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${javascriptKey }&libraries=services"></script>
<!-- 유저의 주소 가져오기, 기본값 대전 둔산동 -->
<c:if test="${rq.loginedMemberId != 0 }">
	<script>
		const loginedMemberAddress = "${memberAddress}";
		const loginedMemberNickname = "${rq.loginedMemberNickname}";
	</script>
	<script type="text/javascript" src="/js/map/UsrShowMap.js"></script>
	<script src="/js/common/carousel.js"></script>
</c:if>
<script>
	function carouselPlay() {
		playCarousel($(".carousel-item").length, true, $('.carousel').width(), 7000);
	}
	
	$(function(){
		carouselPlay();
		$(window).resize(() => carouselPlay());
	})
	
	//메인페이지에만 효과 적용
	/* 
	if (window.location.pathname === '/usr/home/main') {
		$("body").prepend(`<div class="h-10 border-b" style="background-color: #EEEDEB;"></div>`);
		$("body").css('overflow-y', 'hidden');
	} 
	*/
</script>

<section class="mw b-mh">
	<div class="w-full h-[65vh] bg-[lightslategray] relative">
		<!-- Meow 소개 -->
		<!-- 인기게시글 -->
		<div class="absolute w-full h-full">
			<div class="carousel w-full h-full">
				<div class="carousel-item w-full">
					<div class="w-3/5 h-full border mx-auto">
					</div>
				</div>
				
		    	<div class="carousel-item w-full text-white text-9xl">2</div>
		    	
		    	<div class="carousel-item w-full text-white text-9xl">3</div>
		    	
		    	<div class="carousel-item w-full text-white text-9xl">4</div>
		    	
		    	<div class="carousel-item w-full text-white text-9xl">5</div>
			</div>
		</div>
		
		<!-- 캐러셀 시작, 정지 버튼 -->
		<div class="absolute top-2 left-2">
			<label id="carousel-play" class="carousel-playStop btn btn-sm w-8" onclick="carouselPlay()"><i class="fa-solid fa-play"></i>
				<input class="hidden" type="radio" name="carouselPlay" autocomplete="off" />
			</label>
			<label id="carousel-stop" class="carousel-playStop btn btn-sm w-8" onclick="stopCarousel()"><i class="fa-solid fa-pause"></i>
				<input class="hidden" type="radio" name="carouselPlay" checked autocomplete="off" />
			</label>
		</div>
		
		<!-- 캐러셀 이전, 다음 버튼 -->
		<div class="absolute flex justify-between transform -translate-y-1/2 inset-x-[10%] top-1/2">
	      	<div class="carouselMoveBtn btn btn-lg btn-circle bg-opacity-20 border-0"><i class="fa-solid fa-lg fa-angle-left"></i></div>
	      	<div class="carouselMoveBtn btn btn-lg btn-circle bg-opacity-20 border-0"><i class="fa-solid fa-lg fa-angle-right"></i></div>
	    </div>
		
		<!-- 캐러셀 라디오 버튼 -->
		<div class="absolute left-1/2 -translate-x-1/2 bottom-2">
			<input id="cr-01" class="carouselRadio hidden peer/cr-01" type="radio" name="carouselRadio" data-idx="0" checked autocomplete="off" />
			<label for="cr-01" class="inline-block h-1 px-2 bg-blue-50 cursor-pointer peer-checked/cr-01:bg-sky-500"></label>
			
			<input id="cr-02" class="carouselRadio hidden peer/cr-02" type="radio" name="carouselRadio" data-idx="1" autocomplete="off" />
			<label for="cr-02" class="inline-block h-1 px-2 bg-blue-50 cursor-pointer peer-checked/cr-02:bg-sky-500"></label>
			
			<input id="cr-03" class="carouselRadio hidden peer/cr-03" type="radio" name="carouselRadio" data-idx="2" autocomplete="off" />
			<label for="cr-03" class="inline-block h-1 px-2 bg-blue-50 cursor-pointer peer-checked/cr-03:bg-sky-500"></label>
			
			<input id="cr-04" class="carouselRadio hidden peer/cr-04" type="radio" name="carouselRadio" data-idx="3" autocomplete="off" />
			<label for="cr-04" class="inline-block h-1 px-2 bg-blue-50 cursor-pointer peer-checked/cr-04:bg-sky-500"></label>
			
			<input id="cr-05" class="carouselRadio hidden peer/cr-05" type="radio" name="carouselRadio" data-idx="4" autocomplete="off" />
			<label for="cr-05" class="inline-block h-1 px-2 bg-blue-50 cursor-pointer peer-checked/cr-05:bg-sky-500"></label>
		</div>
	</div>
</section>

<section class="mw mb-40 text-center">
	<div class="join">
		<button class="btn btn-outline btn-accent w-32 h-32 join-item rounded-none border-r-0">전체</button>
		<button class="btn btn-outline btn-accent w-32 h-32 join-item border-r-0">공지사항</button>
		<button class="btn btn-outline btn-accent w-32 h-32 join-item border-r-0">자유</button>
		<button class="btn btn-outline btn-accent w-32 h-32 join-item border-r-0">반려묘</button>
		<button class="btn btn-outline btn-accent w-32 h-32 join-item border-r-0">거래</button>
		<button class="btn btn-outline btn-accent w-32 h-32 join-item rounded-none">모임</button>
	</div>
</section>

<section class="mw mb-60">
	<div class="relative overflow-hidden flex justify-center pl-52">
		<c:if test="${rq.loginedMemberId != 0 }">
			<div id="map" class="shadow w-[80%] h-[550px] rounded-box">
				<div id="radioBtn" class="join absolute z-20 top-2 left-2">
				  	<input class="join-item btn btn-sm btn-neutral text-xs w-12" type="radio" name="options" value="1000" aria-label="1km" autocomplete="off" />
				  	<input class="join-item btn btn-sm btn-neutral text-xs w-12" type="radio" name="options" value="2000" aria-label="2km" checked autocomplete="off" />
				  	<input class="join-item btn btn-sm btn-neutral text-xs w-12" type="radio" name="options" value="3000" aria-label="3km" autocomplete="off" />
				  	<input class="join-item btn btn-sm btn-neutral text-xs w-12" type="radio" name="options" value="4000" aria-label="4km" autocomplete="off" />
				  	<input class="join-item btn btn-sm btn-neutral text-xs w-12" type="radio" name="options" value="5000" aria-label="5km" autocomplete="off" />
				  	<input class="join-item btn btn-sm btn-neutral text-xs w-12" type="radio" name="options" value="10000" aria-label="10km" autocomplete="off" />
				  	<input class="join-item btn btn-sm btn-neutral text-xs w-12" type="radio" name="options" value="500000" aria-label="all" autocomplete="off" />
				</div>
						
				<div id="map-info-wrap" class="border-2 rounded-lg p-2 opacity-90">
					<button class="btn btn-circle btn-sm m-1" onclick="closeInfoWarp()">
					  	<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
					</button>
					<div class="px-4 h-5/6 rounded-none flex flex-col justify-between"></div>
				</div>
			</div>
		</c:if>
		
		<c:if test="${rq.loginedMemberId == 0 }">
			<div class="flex items-center justify-center border bg-gray-200 opacity-90 text-lg w-[80%] min-w-[1024px] h-[550px] rounded-box">
				<span class="pr-1.5">로그인 후 이용가능합니다.</span>
				<a class="text-red-600 hover:text-red-700 hover:underline " href="../member/login">로그인 이동</a>
			</div>
		</c:if>
		
		<div>
			<img class="-scale-x-100 w-[305px] h-[550px] pointer-events-none" src="https://i.pinimg.com/564x/55/a1/e1/55a1e1ae25e0e2bc339adab003242664.jpg" />
		</div>
	</div>
</section>

<%@ include file="../common/scrollButtons.jsp"%>
<%@ include file="../common/footer.jsp"%>