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
<!-- <script>
	//메인페이지에만 효과 적용
	if (window.location.pathname === '/usr/home/main') {
		$("body").prepend(`<div class="h-10 border-b" style="background-color: #EEEDEB;"></div>`);
		$("body").css('overflow-y', 'hidden');
	}
</script> -->

<section class="mw b-mh">
	<div class="w-full h-[65vh] bg-[lightslategray]"></div>
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

<section class="mw">
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

<%@ include file="../common/footer.jsp"%>