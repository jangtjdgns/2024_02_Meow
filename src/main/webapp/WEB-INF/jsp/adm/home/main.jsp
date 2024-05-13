<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${javascriptKey }&libraries=services"></script>
<script src="/js/common/carousel.js"></script>
<script>
function getAdmContentJsp(type){
	$.ajax({
		url: '/adm/content/getJsp',
	    method: 'GET',
	    data: {
	    	type: type
	    },
	    dataType: 'html',
	    success: function(jspContent) {
	    	
	    	// 서버에서 받은 응답을 화면에 표시
	    	$("#admContentJspWrap").html(jspContent);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

const loginedMemberId = ${rq.loginedMemberId};	// 로그인 관리자의 번호
const loginedMemberAddress = "대전 둔산동";		// 지도의 기준 주소
const loginedMemberNickname = "관리자";			// 기본 위치에 표시될 이름

$(function(){
	
	$(".sub-title").click(function() {
		
		$(".sub-title").removeClass("btn-active");
		$(this).addClass("btn-active");
		
		const titleIdx = parseInt($(this).closest("ul").attr("data-idx"));
		
		$(".title").removeClass("btn-active");
		$(".title").eq(titleIdx).addClass("btn-active");
		
		$(".sub-title-name").text($(this).text());
		$(".sub-title-name").attr('data-type', $(this).closest("ul").attr("data-type"));
		$(".title-name").text($(".title").eq(titleIdx).text().trim());
	});
	
	// 캐러셀 자동 움직임 함수(carousel.js)
	playCarousel($(".carousel-item").length, false, 24, 10000);
})

</script>

<section class="min-h-screen overflow-y-scroll">
	<div class="flex">
		<div class="h-full">
			<aside class="drawer lg:drawer-open">
			  	<input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
			  	
			  	<div class="drawer-side border-r-2">
			    	<label for="my-drawer-2" aria-label="close sidebar" class="drawer-overlay"></label> 
			    	<ul class="menu p-4 w-80 min-h-full bg-base-200 text-base-content">
			      		<li class="text-3xl text-center pt-2 pb-3 font-bold" style="background: linear-gradient(to right top, #fbc2eb, #a6c1ee); color: transparent; -webkit-background-clip: text;">
			      			Meow
			      		</li>	
			      		<li>
			      			<button class="font-bold text-lg sub-title" onclick="getAdmContentJsp('main')"><i class="fa-solid fa-house"></i> 메인</button>
			      		</li>
			      		
			      		<li>
							<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-solid fa-users"></i> 회원 관리</summary>
			      				<ul data-idx="0" data-type="member">
					              	<li><button class="sub-title" onclick="getAdmContentJsp('memberList')">회원 목록</button></li>
					              	<li><button class="sub-title" onclick="getAdmContentJsp('report')">회원 신고 조치</button></li>
					              	<li><button class="sub-title">휴면 회원 관리</button></li>
					              	<li><button class="sub-title">회원 통계</button></li>
					            </ul>
				          	</details>
						</li>
						
			      		<li>
			      			<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-regular fa-clipboard"></i> 게시판 관리</summary>
			      				<ul data-idx="1" data-type="article">
					              	<li><button class="sub-title" onclick="getAdmContentJsp('articleList')">게시글 목록</button></li>
					              	<li><button class="sub-title" onclick="getAdmContentJsp('report')">게시글 신고 조치</button></li>
					              	<li><button class="sub-title">공지사항 등록</button></li>
					              	<li><button class="sub-title">게시판 통계</button></li>
					            </ul>
				          	</details>
			      		</li>
			      		
			      		<li>
			      			<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-solid fa-comments"></i> 댓글 관리</summary>
			      				<ul data-idx="2" data-type="reply">
					              	<li><button class="sub-title" onclick="getAdmContentJsp('replyList')">댓글 목록</button></li>
					              	<li><button class="sub-title" onclick="getAdmContentJsp('report')">댓글 신고 조치</button></li>
					            </ul>
				          	</details>
			      		</li>
			      		
			      		<li>
			      			<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-solid fa-envelope-open-text"></i> 건의 사항 및 문의 관리</summary>
			      				<ul data-idx="3" data-type="inquiry">
					              	<li><button class="sub-title" onclick="getAdmContentJsp('customerList')">접수 목록</button></li>
					            </ul>
				          	</details>
			      		</li>
			      		
			      		<li>
			      			<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-solid fa-map-location-dot"></i> 지도</summary>
			      				<ul data-idx="4" data-type="map">
					              	<li><button class="sub-title" onclick="getAdmContentJsp('map')">지역별 회원 목록</button></li>
					              	<li><button class="sub-title">거래 목록</button></li>
					            </ul>
				          	</details>
			      		</li>
			      		
			      		<li>
			      			<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-solid fa-chart-simple"></i> 기타</summary>
			      				<ul data-idx="5" data-type="etc">
					              	<li><button class="sub-title" onclick="getAdmContentJsp('calendar')">일정</button></li>
					              	<li><button class="sub-title" onclick="getAdmContentJsp('requestHistory')">전체 요청 기록 확인</button></li>
					              	<!-- <li><button class="sub-title">채팅 기록 확인</button></li>
					              	<li><button class="sub-title">친구 상태 확인</button></li> -->
					            </ul>
				          	</details>
			      		</li>
			      		
			      		<li class="pt-4">
			      			<a href="/" class="btn content-center btn-neutral hover:bg-gray-800">
			      				<span class="font-bold" style="background: linear-gradient(to right top, #fbc2eb, #a6c1ee); color: transparent; -webkit-background-clip: text;">Meow</span>
			      			바로가기</a>
			      		</li>
			    	</ul>
			  	</div>
			</aside>
		</div>
		
		<div class="grid bg-gray-50 w-full [min-width:1024px]" style="grid-template-rows: 120px 1fr">
			<div class="flex flex-col justify-center border-b-2 bg-white px-10">
				<div class="flex items-center justify-between">
					<div class="title-name"></div>
					<div class="flex items-center gap-4">
						<div><span class="font-bold">${rq.loginedMemberNickname }</span> 님</div>
						<div>
							<a href="../member/doLogout" onclick="if(!confirm('로그아웃 하시겠습니까?')) return false;" class="btn btn-sm">로그아웃</a>
						</div>
					</div>
				</div>
				
				<div class="flex items-center justify-between">
					<div class="sub-title-name text-2xl font-bold" data-type='main'>메인</div>
					<!-- 이부분은 공지를 등록했을때 자동으로 생성되면 좋을듯함 -->
					<div class="self-end border-b">
						<i class="fa-solid fa-bullhorn" style="color: #B197FC;"></i>
						<ul class="w-72 h-6 carousel carousel-vertical">
							<li class="carousel-item w-full"><a class="hover:underline">안녕하세요. 1번 공지입니다.</a></li>
							<li class="carousel-item w-full"><a class="hover:underline">반갑습니다.</a></li>
							<li class="carousel-item w-full"><a class="hover:underline">환영합니다.</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div id="admContentJspWrap" class="m-8 border bg-white shadow-2xl rounded-lg [height:721px] [max-height:721px]">
				<%@ include file="../home/mainContent.jsp"%>
				<%-- <%@ include file="../other/requestHistory.jsp"%> --%>
			</div>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>