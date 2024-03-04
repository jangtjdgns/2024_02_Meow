<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="border-2 shadow-xl rounded-2xl p-10">
	<div class="text-sm py-2"><span class="text-red-700">* </span> 표시는 로그인 후 이용가능한 페이지입니다.</div>
	<div class="grid grid-cols-3 gap-3">
		<ul class="menu w-full">
			<li class="pl-2 text-lg font-bold fa-solid fa-house"> 메인</li>
			<li>
				<ul><li><a href="/">바로가기</a></li></ul>
			</li>
		</ul>
		
		<ul class="menu w-full">
			<li class="pl-2 text-lg font-bold fa-solid fa-envelope-open-text"> 고객센터</li>
			<li>
				<ul><li><a href="../customer/main">바로가기</a></li></ul>
			</li>
		</ul>
		
		<ul class="menu w-full">
			<li class="px-2 text-lg font-bold fa-solid fa-screwdriver-wrench"> 계정관리</li>
			<li>
				<ul>
					<li>
						<a href="../member/userAccount?memberId=${rq.loginedMemberId }">
						<span class="text-red-700">* </span>바로가기</a>
					</li>
				</ul>
			</li>
		</ul>
		
		<ul class="menu w-full">
			<li class="pl-2 text-lg font-bold fa-solid fa-paw pr-1"> 반려묘</li>
			<li>
				<ul>
					<li><a href="../companionCat/register"><span class="text-red-700">* </span>등록</a></li>
					<!-- 링크 나중에 추가 예정 -->
					<li><a href=""><span class="text-red-700">* </span>관리</a></li>
				</ul>
			</li>
		</ul>
		
		<ul class="menu w-full">
			<li class="pl-2 text-lg font-bold fa-regular fa-newspaper"> 게시판</li>
			<li>
				<ul>
					<li>
						<details close>
			            <summary>분류</summary>
			            	<ul>
			              		<li><a href="../article/list">전체</a></li>
								<li><a href="../article/list?boardId=2">공지사항</a></li>
								<li><a href="../article/list?boardId=3">자유</a></li>
								<li><a href="../article/list?boardId=4">반려묘</a></li>
								<li><a href="../article/list?boardId=5">거래</a></li>
								<li><a href="../article/list?boardId=6">모임</a></li>
			            	</ul>
			          	</details>
					</li>
					<!-- 링크 나중에 추가 예정 -->
					<li><a href="">갤러리</a></li>
					<li><a href="../article/write"><span class="text-red-700">* </span>게시글 작성</a></li>
				</ul>
			</li>
		</ul>
		
		<ul class="menu w-full">
			<li class="pl-1 text-lg font-bold fa-solid fa-user"> 프로필</li>
			<li>
				<ul>
					<li>
						<a href="../member/profile?memberId=${rq.loginedMemberId }">
						<span class="text-red-700">* </span>바로가기</a>
					</li>
				</ul>
			</li>
		</ul>
	</div>
</div>