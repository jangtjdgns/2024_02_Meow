<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<script>
function getAdmContentJsp(type){
	$.ajax({
		url: '/adm/get/content',
	    method: 'GET',
	    data: {
	    	type: type
	    },
	    dataType: 'html',
	    success: function(response) {
	    	// 서버에서 받은 응답을 화면에 표시
	    	$("#admContentJspWrap").html(response);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}


$(function(){
	$(".sub-title").click(function() {
		
		// 버튼 유무 확인
		if(!$(this).has(".btn-active")) {
			$(this).addClass("btn-active");
		}
		
		const titleIdx = parseInt($(this).closest("ul").attr("data-idx"));
		
		$(".title").removeClass("btn-active");
		$(".title").eq(titleIdx).addClass("btn-active");
		
		$(".sub-title-name").text($(this).text());
		$(".title-name").text($(".title").eq(titleIdx).text().trim());
	});
})

</script>

<section class="min-h-screen">
	<div class="flex">
		<div>
			<aside class="drawer lg:drawer-open">
			  	<input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
			  	
			  	<div class="drawer-side border-r-2">
			    	<label for="my-drawer-2" aria-label="close sidebar" class="drawer-overlay"></label> 
			    	<ul class="menu p-4 w-80 min-h-full bg-base-200 text-base-content">
			      		<li class="text-2xl text-center pt-3 pb-6 font-bold">Meow 관리자 페이지</li>
			      		
			      		<li>
			      			<button class="font-bold text-lg sub-title" onclick="getAdmContentJsp('main')"><i class="fa-solid fa-house"></i> 메인</button>
			      		</li>
			      		
			      		<li>
							<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-solid fa-users"></i> 회원 관리</summary>
			      				<ul data-idx="0">
					              	<li><button class="sub-title">회원 목록</button></li>
					              	<li><button class="sub-title">회원 신고 조치</button></li>
					              	<li><button class="sub-title">회원 상태</button></li>
					            </ul>
				          	</details>
						</li>
						
			      		<li>
			      			<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-regular fa-clipboard"></i> 게시판 관리</summary>
			      				<ul data-idx="1">
					              	<li><button class="sub-title">게시글 목록</button></li>
					              	<li><button class="sub-title">게시글 신고 조치</button></li>
					              	<li><button class="sub-title">공지사항 등록</button></li>
					            </ul>
				          	</details>
			      		</li>
			      		
			      		<li>
			      			<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-solid fa-envelope-open-text"></i> 건의 사항 및 문의 관리</summary>
			      				<ul data-idx="2">
					              	<li><button class="sub-title">접수 목록</button></li>
					              	<li><button class="sub-title">처리 목록</button></li>
					            </ul>
				          	</details>
			      		</li>
			      		
			      		<li>
			      			<details open>
			      				<summary class="font-bold text-lg title"><i class="fa-solid fa-chart-simple"></i> 기타</summary>
			      				<ul data-idx="3">
					              	<li><button class="sub-title">일정</button></li>
					              	<li><button class="sub-title">전체 요청 기록 확인</button></li>
					              	<li><button class="sub-title">채팅 기록 확인</button></li>
					            </ul>
				          	</details>
			      		</li>
			      		
			      		<li class="absolute bottom-4 left-1/2 -translate-x-1/2 w-72">
			      			<a href="/" class="btn content-center btn-neutral hover:bg-gray-800">
			      				<span class="font-bold" style="background: linear-gradient(to right top, #fbc2eb, #a6c1ee); color: transparent; -webkit-background-clip: text;">Meow</span>
			      			바로가기</a>
			      		</li>
			    	</ul>
			  	</div>
			</aside>
		</div>
		
		<div class="grid bg-gray-50 w-full" style="grid-template-rows: 120px 1fr">
			<div class="flex flex-col justify-center border-b-2 bg-white px-10">
				<div class="flex items-center justify-between">
					<div class="title-name"></div>
					<button class="btn btn-sm">로그아웃</button>
				</div>
				
				<div class="flex items-center justify-between">
					<div class="sub-title-name text-2xl font-bold">메인</div>
					<div>asd</div>
				</div>
			</div>
			<div id="admContentJspWrap" class="m-8 border bg-white shadow-2xl rounded-lg [max-height:721px]">
				<%@ include file="../home/mainContent.jsp"%>
			</div>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>