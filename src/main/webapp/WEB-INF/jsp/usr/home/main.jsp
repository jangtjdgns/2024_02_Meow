<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../common/header.jsp"%>
<script src="/js/common/carousel.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${javascriptKey }&libraries=services"></script>
<!-- 유저의 주소 가져오기, 기본값 대전 둔산동 -->
<c:if test="${rq.loginedMemberId != 0 }">
	<script>
		const loginedMemberAddress = "${memberAddress}";
		const loginedMemberNickname = "${rq.loginedMemberNickname}";
	</script>
	<script type="text/javascript" src="/js/map/UsrShowMap.js"></script>
</c:if>
<script>
	function carouselPlay() {
		playCarousel($(".carousel-item").length, true, $('.carousel').width(), 10000);
	}
	
	$(function(){
		carouselPlay();
		$(window).resize(() => carouselPlay());
		
		// 게시글 내 이미지가 있는 경우 이미지 추출 후 배경으로 사용
		$('.articles-body').each(function(idx, item){
			const text = $(item).val();
			const regex = /!\[.*?\]\((.*?\.(?:jpg|jpeg|png|gif))\)/gi;
			const imageUrl = regex.exec(text);
			
			if(imageUrl !== null) {
				$('.bn-article-wrap').eq(idx).css('background-image', `url(\${imageUrl[1]})`);
			} else {
				$('.bn-article-wrap').eq(idx).addClass('bg-blue-100');
			}
		})
	})
	
	//메인페이지에만 효과 적용
	/* 
	if (window.location.pathname === '/usr/home/main') {
		$("body").prepend(`<div class="h-10 border-b" style="background-color: #EEEDEB;"></div>`);
		$("body").css('overflow-y', 'hidden');
	} 
	*/
</script>

<main class="mw b-mh">
	<section>
		<div class="w-full h-[50vh] bg-[darkseagreen] relative">
			<div class="absolute w-full h-full">
				<div class="carousel w-full h-full">
					<!-- Meow 소개 -->
					<!-- HOT 게시글 -->
					<div class="carousel-item w-full">
						<div class="w-[65%] h-full mx-auto py-2 grid grid grid-cols-3 grid-rows-10 gap-x-8 z-[2]">
							<div class="col-start-1 col-end-4 row-start-1 row-end-3 flex gap-2 justify-self-center self-center">
								<div class="text-4xl"><i class="fa-solid fa-ranking-star" style="color: #FFD43B;"></i></div>
								<div class="text-3xl text-white font-semibold">화제 게시글</div>
							</div>
							<c:forEach var="article" items="${hotArticles }" varStatus="status">
								<a href="../article/detail?boardId=${article.boardId }&id=${article.id }" class="bn-article-wrap bg-cover bg-center bg-no-repeat row-start-3 row-end-10 shadow-2xl rounded-md">
									<div class="bg-black bg-opacity-50 hover:bg-opacity-60 transition-[background-color] duration-[0.4s] text-center text-indigo-100 h-full grid rounded-md" style="grid-template-rows: 65px 1fr;">
										<div class="h-full bg-black bg-opacity-5 grid items-center" style="grid-template-rows: 2fr 1fr;">
											<div class="max-w-[511px] text-lg px-2 truncate">${article.title}</div>
											<div class="flex gap-2.5 items-center justify-center text-xs pb-2">
												<div><i class="fa-solid fa-eye"></i> ${article.hitCnt }</div>
												<div><i class="fa-solid fa-thumbs-up"></i> ${article.reactionLikeCnt }</div>
												<div><i class="fa-solid fa-comment-dots"></i> ${article.replyCnt }</div>
												<div><i class="fa-solid fa-clock"></i> ${article.regDate.substring(2, 10) }</div>
											</div>
										</div>
										<div><input type="hidden" class="articles-body" value="${article.body}" /></div>
									</div>
								</a>
							</c:forEach>
						</div>
					</div>
					
					<!-- 최신 게시글 -->
					<div class="carousel-item w-full bg-[lightsteelblue]">
						<div class="w-[65%] h-full mx-auto py-2 grid grid-cols-3 grid-rows-10 gap-x-8 z-[2]">
							<div class="col-start-1 col-end-4 row-start-1 row-end-3 flex gap-2 justify-self-center self-center">
								<div class="text-3xl text-red-300 font-SBAggroB border-b-2 border-pink-300"><div class="-rotate-6">NEW</div></div>
								<div class="text-3xl text-white font-semibold">게시글</div>
							</div>
							<c:forEach var="article" items="${latestArticles }" varStatus="status">
								<a href="../article/detail?boardId=${article.boardId }&id=${article.id }" class="bn-article-wrap bg-cover bg-center bg-no-repeat row-start-3 row-end-10 shadow-2xl rounded-md">
									<div class="bg-black bg-opacity-50 hover:bg-opacity-60 transition-[background-color] duration-[0.4s] text-center text-indigo-100 h-full grid rounded-md" style="grid-template-rows: 65px 1fr;">
										<div class="h-full bg-black bg-opacity-5 grid items-center" style="grid-template-rows: 2fr 1fr;">
											<div class="max-w-[511px] text-lg px-2 truncate">${article.title}</div>
											<div class="flex gap-2.5 items-center justify-center text-xs pb-2">
												<span class="badge badge-sm badge-ghost mr-1">${article.boardName}</span>
												<div><i class="fa-solid fa-eye"></i> ${article.hitCnt }</div>
												<div><i class="fa-solid fa-thumbs-up"></i> ${article.reactionLikeCnt }</div>
												<div><i class="fa-solid fa-comment-dots"></i> ${article.replyCnt }</div>
												<div><i class="fa-solid fa-clock"></i> ${article.regDate.substring(2, 10) }</div>
											</div>
										</div>
										<div><input type="hidden" class="articles-body" value="${article.body}" /></div>
									</div>
								</a>
							</c:forEach>
						</div>
					</div>
			    	
			    	<div class="carousel-item w-full bg-[thistle] text-white text-9xl">3</div>
			    	
			    	<div class="carousel-item w-full bg-[gainsboro] text-white text-9xl">4</div>
			    	
			    	<div class="carousel-item w-full bg-[burlywood] text-white text-9xl">5</div>
				</div>
			</div>
			
			<!-- 캐러셀 자동 스크롤 시작, 정지 버튼 -->
			<div class="absolute top-2 right-2 bg-white bg-opacity-10 scale-50 p-1 rounded-lg">
				<label id="carousel-play" class="carousel-playStop btn btn-sm btn-ghost w-8" onclick="carouselPlay()"><i class="fa-solid fa-play" style="color: #ffffff;"></i>
					<input class="hidden" type="radio" name="carouselPlay" autocomplete="off" />
				</label>
				<label id="carousel-stop" class="carousel-playStop btn btn-sm btn-ghost w-8" onclick="stopCarousel()"><i class="fa-solid fa-pause" style="color: #ffffff;"></i>
					<input class="hidden" type="radio" name="carouselPlay" checked autocomplete="off" />
				</label>
			</div>
			
			<!-- 캐러셀 이전, 다음 버튼 -->
			<div class="absolute flex justify-between transform -translate-y-1/2 inset-x-[10%] top-1/2 z-[1]">
		      	<div class="carouselMoveBtn btn btn-lg btn-circle bg-opacity-50 border-0"><i class="fa-solid fa-lg fa-angle-left"></i></div>
		      	<div class="carouselMoveBtn btn btn-lg btn-circle bg-opacity-50 border-0"><i class="fa-solid fa-lg fa-angle-right"></i></div>
		    </div>
			
			<!-- 캐러셀 라디오 버튼 -->
			<div class="absolute left-1/2 -translate-x-1/2 bottom-2 z-20">
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
	
	<!-- 게시판 바로가기 -->
	<section class="mw py-32 bg-gray-50">
		<div class="w-[1024px] mx-auto">
			<div class="text-xl font-semibold pb-4">게시판에서 재미있는 글들을 확인해보세요</div>
			<div class="grid grid-cols-3 grid-rows-2 gap-6 h-[20rem] justify-center">
				<a href="../article/list" class="btn btn-outline text-[#BDB76B] bg-[#fffef2] border-[#BDB76B] hover:bg-[#BDB76B] hover:border-[#BDB76B] h-full grid grid-cols-3 shadow-xl">
					<div class="col-start-1 col-end-3 grid text-left mx-2" style="grid-template-rows: 1fr 2fr;">
						<div class="font-semibold text-lg">전체 게시판</div>
						<div class="font-normal self-center">모든 게시글을 볼 수 있어요.</div>
					</div>
					<img src="https://img.icons8.com/?size=100&id=yln7W1tiSYJz&format=png&color=000000" alt="" />
				</a>
				<a href="../article/list?boardId=2" class="btn btn-outline text-[#DEB887] bg-[#fff9f2] border-[#DEB887] hover:bg-[#DEB887] hover:border-[#DEB887] h-full grid grid-cols-3 shadow-xl">
					<div class="col-start-1 col-end-3 grid text-left mx-2" style="grid-template-rows: 1fr 2fr;">
						<div class="font-semibold text-lg">공지사항 게시판</div>
						<div class="font-normal self-center">오늘의 Meow 소식을 확인해보세요.</div>
					</div>
					<img src="https://img.icons8.com/?size=100&id=7EoumkdcLQEo&format=png&color=000000" alt="" />
				</a>
				
				<a href="../article/list?boardId=3" class="btn btn-outline text-[#BC8F8F] bg-[#fff2f2] border-[#BC8F8F] hover:bg-[#BC8F8F] hover:border-[#BC8F8F] h-full grid grid-cols-3 shadow-xl">
					<div class="col-start-1 col-end-3 grid text-left mx-2" style="grid-template-rows: 1fr 2fr;">
						<div class="font-semibold text-lg">자유 게시판</div>
						<div class="font-normal self-center">자유롭게 게시글을 작성해보세요!</div>
					</div>
					<img src="https://img.icons8.com/?size=100&id=6ExjWWj6a5p3&format=png&color=000000" alt="" />
				</a>
				
				<a href="../article/list?boardId=4" class="btn btn-outline text-[#00D7C0] bg-[#f0fffd] border-[#00D7C0] hover:bg-[#00D7C0] hover:border-[#00D7C0] h-full grid grid-cols-3 shadow-xl">
					<div class="col-start-1 col-end-3 grid text-left mx-2" style="grid-template-rows: 1fr 2fr;">
						<div class="font-semibold text-lg">반려묘 게시판</div>
						<div class="font-normal self-center">우리의 고양이 친구들을 만나보세요!</div>
					</div>
					<img src="https://img.icons8.com/?size=100&id=tvJZdxwTxU5v&format=png&color=000000" alt="" />
				</a>
				
				<a href="../article/list?boardId=5" class="btn btn-outline text-[#778899] bg-[#f0f7ff] border-[#778899] hover:bg-[#778899] hover:border-[#778899] h-full grid grid-cols-3 shadow-xl">
					<div class="col-start-1 col-end-3 grid text-left mx-2" style="grid-template-rows: 1fr 2fr;">
						<div class="font-semibold text-lg">거래 게시판</div>
						<div class="font-normal self-center">고양이 집사들을 위한 용품 거래 공간입니다.</div>
					</div>
					<img src="https://img.icons8.com/?size=100&id=UDDUYWPLoNks&format=png&color=000000" alt="" />
				</a>
				
				<a href="../article/list?boardId=6" class="btn btn-outline text-[#6524d9] bg-[#f5f0fc] border-[#6524d9] hover:bg-[#6524d9] hover:border-[#6524d9] h-full grid grid-cols-3 shadow-xl">
					<div class="col-start-1 col-end-3 grid text-left mx-2" style="grid-template-rows: 1fr 2fr;">
						<div class="font-semibold text-lg">모임 게시판</div>
						<div class="font-normal self-center">고양이 사랑이 가득한 모임입니다.</div>
					</div>
					<img src="https://img.icons8.com/?size=100&id=Xvo1JQO2ujpL&format=png&color=000000" alt="" />
				</a>
			</div>
		</div>
	</section>
	
	<!-- 내 주변 회원 지도 -->
	<section class="mw py-32">
		<div class="w-[1024px] mx-auto">
			<div class="text-xl font-semibold pb-4">내 주변 집사들과 소통해보세요</div>
		</div>
		<div class="overflow-hidden grid" style="grid-template-columns: 1fr 1024px 1fr;">
			<div></div>
			<c:if test="${rq.loginedMemberId != 0 }">
				<div id="map" class="shadow w-[1024px] h-[550px] rounded-box shadow">
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
				<div class="flex items-center justify-center border bg-gray-200 opacity-90 text-lg w-[1024px] min-w-[1024px] h-[550px] rounded-box shadow">
					<span class="pr-1.5">로그인 후 이용가능합니다.</span>
					<a class="text-red-600 hover:text-red-700 hover:underline " href="../member/login">로그인 이동</a>
				</div>
			</c:if>
			
			<div class="w-[305px]">
				<img class="-scale-x-100 w-full h-[550px] pointer-events-none" src="https://i.pinimg.com/564x/55/a1/e1/55a1e1ae25e0e2bc339adab003242664.jpg" />
			</div>
		</div>
	</section>
	
	<!-- 각 부분 랭킹 표시, 댓글왕, 추천왕, 작성왕 등 -->
	<section id="hall-of-fame" class="mw relative py-32 bg-gray-50">
		<div class="w-[1024px] mx-auto">
			<div class="text-xl font-semibold pb-4">MEOW 명예의 전당</div>
		</div>
		
		<div class="w-[1024px] mx-auto">
			<div class="cr inline-flex snap-x snap-mandatory overflow-x-scroll scroll-smooth p-4 space-x-4 border rounded-box shadow-2xl">
				<!-- 작성왕 -->
				<div id="item1" class="cr-item box-content flex flex-none snap-center">
					<div class="card bg-base-100 shadow-xl w-[300px] h-[400px] bg-[#fffff5]">
						<figure class="border-b py-4">
							<div class="avatar">
							  	<div class="w-36 rounded-full">
							    	<img src="${topArticleWriters.profileImage }" alt="프로필 이미지가 없습니다." class="h-[180px] flex justify-center items-center" />
							  	</div>
							</div>
						</figure>
						<div class="card-body">
							<h2 class="card-title"><i class="fa-solid fa-star" style="color: #FFD43B;"></i> 작성왕</h2>
							<h2 class="card-title justify-end">
								<span style="background: linear-gradient(140deg, #ff9f71, #ffe6cc); color: transparent; -webkit-background-clip: text;">${topArticleWriters.nickname }</span> 님
							</h2>
							<p>총 <span class="font-bold underline">${topArticleWriters.articleCnt }</span> 개의 게시글을 작성했습니다!</p>
						</div>
					</div>
				</div>
				
				<!-- 게시글 추천왕 -->
				<div id="item2" class="cr-item box-content flex flex-none snap-center">
					<div class="card bg-base-100 shadow-xl w-[300px] h-[400px] bg-[#f5fbff]">
						<figure class="border-b py-4">
							<div class="avatar">
							  	<div class="w-36 rounded-full">
							    	<img src="${topLikedArticles.profileImage }" alt="프로필 이미지가 없습니다." class="h-[180px] flex justify-center items-center" />
							  	</div>
							</div>
						</figure>
						
						<div class="card-body">
							<h2 class="card-title">
								<i class="fa-solid fa-star" style="color: #74C0FC;"></i>추천왕
							</h2>
							<h2 class="card-title justify-end">
								<span style="background: linear-gradient(140deg, #0080c0, #d0f0ff); color: transparent; -webkit-background-clip: text;">${topLikedArticles.nickname }</span> 님
							</h2>
							<p>총 <span class="font-bold underline">${topLikedArticles.reactionLikeCnt }</span> 개의 추천을 받았습니다!</p>
							<p><div class="badge badge-info">게시글</div></p>
						</div>
					</div>
				</div>
				
				<!-- 댓글 추천왕 -->
				<div id="item3" class="cr-item box-content flex flex-none snap-center">
					<div class="card bg-base-100 shadow-xl w-[300px] h-[400px] bg-[#f8fff5]">
						<figure class="border-b py-4">
							<div class="avatar">
							  	<div class="w-36 rounded-full">
							    	<img src="${topLikedReplies.profileImage }" alt="프로필 이미지가 없습니다." class="h-[180px] flex justify-center items-center" />
							  	</div>
							</div>
						</figure>
						
						<div class="card-body">
							<h2 class="card-title">
								<i class="fa-solid fa-star" style="color: #63E6BE;"></i>추천왕
							</h2>
							<h2 class="card-title justify-end">
								<span style="background: linear-gradient(140deg, #00d700, #9bffb5); color: transparent; -webkit-background-clip: text;">${topLikedReplies.nickname }</span> 님
							</h2>
							<p>총 <span class="font-bold underline">${topLikedReplies.reactionLikeCnt }</span> 개의 추천을 받았습니다!</p>
							<p><div class="badge badge-accent">댓글</div></p>
						</div>
					</div>
				</div>
				
				<!-- 더 추가 가능함, 예시 -->
				<div id="item4" class="cr-item box-content flex flex-none snap-center">
					<img src="https://img.daisyui.com/images/stock/photo-1494253109108-2e30c049369b.jpg" class="rounded-box" />
				</div>
				<div id="item5" class="cr-item box-content flex flex-none snap-center">
					<img src="https://img.daisyui.com/images/stock/photo-1550258987-190a2d41a8ba.jpg" class="rounded-box" />
  				</div> 
			  	<div id="item6" class="cr-item box-content flex flex-none snap-center">
				    <img src="https://img.daisyui.com/images/stock/photo-1559181567-c3190ca9959b.jpg" class="rounded-box" />
			  	</div> 
			  	<div id="item7" class="cr-item box-content flex flex-none snap-center">
		    		<img src="https://img.daisyui.com/images/stock/photo-1601004890684-d8cbf643f5f2.jpg" class="rounded-box" />
			  	</div>
			</div>
		</div>
		
		<div class="flex justify-center w-full py-2 gap-2">
		  	<a href="#item1" class="cr-indicator-btn btn btn-xs" onclick="moveCarouselAnimation(this)">1</a> 
		  	<a href="#item2" class="cr-indicator-btn btn btn-xs" onclick="moveCarouselAnimation(this)">2</a> 
		  	<a href="#item3" class="cr-indicator-btn btn btn-xs" onclick="moveCarouselAnimation(this)">3</a> 
		  	<a href="#item4" class="cr-indicator-btn btn btn-xs" onclick="moveCarouselAnimation(this)">4</a>
		  	<a href="#item5" class="cr-indicator-btn btn btn-xs" onclick="moveCarouselAnimation(this)">5</a>
		  	<a href="#item6" class="cr-indicator-btn btn btn-xs" onclick="moveCarouselAnimation(this)">6</a>
		  	<a href="#item7" class="cr-indicator-btn btn btn-xs" onclick="moveCarouselAnimation(this)">7</a>
		</div>
	</section>
</main>
<%@ include file="../common/scrollButtons.jsp"%>
<%@ include file="../common/footer.jsp"%>