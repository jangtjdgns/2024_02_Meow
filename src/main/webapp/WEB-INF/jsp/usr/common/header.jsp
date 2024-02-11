<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Meow</title>
	<link rel="icon" href="/resources/images/favicon/cat-pow.ico" type="image/x-icon">
	<%@ include file="../common/head.jsp"%>
</head>

<body>

<section class="h-mh mx-auto max-w-7xl flex justify-between">
	<div class="self-end">
		<a href="/"><img src="/resources/images/Meow-logo.png" class="w-24" /></a>
	</div>
	
	<div class="flex flex-col items-end justify-around h-h w-1/2">
		<div>
			<c:if test="${rq.loginedMemberId == 0 }">
				<div class="w-full flex justify-end">
					<a href="../member/login" class="btn btn-ghost btn-xs h-8">로그인</a>
					<a href="" class="btn btn-ghost btn-xs h-8">회원가입</a>		
				</div>
			</c:if>
			<c:if test="${rq.loginedMemberId != 0 }">
				<div class="w-full flex items-center justify-end">
					<div class="dropdown dropdown-start">
						<div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
							<div class="w-10 rounded-full">
								<c:if test="${rq.loginedMemberProfileImage != null}">
									<img alt="Tailwind CSS Navbar component" src="${rq.loginedMemberProfileImage }" />									
								</c:if>
								<c:if test="${rq.loginedMemberProfileImage == null}">
									<img alt="Tailwind CSS Navbar component" src="https://cdn.pixabay.com/photo/2020/11/15/18/31/cat-5746771_960_720.png" />									
								</c:if>
							</div>
						</div>
						<ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-24">
							<li><a href="../member/profile?memberId=${rq.loginedMemberId }">프로필</a></li>
							<li><a>계정관리</a></li>
							<li><a href="../member/doLogout" onclick="if(!confirm('로그아웃 하시겠습니까?')) return false;">로그아웃</a></li>
						</ul>
					</div>
				</div>
			</c:if>
		</div>
		
		<div class="menu-box">
			<ul class="w-full h-full font-NanumSquareNeo bg-white text-center">
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="/">메인</a>
				</li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="">반려묘</a>
					<ul>
						<li><a href="">등록</a></li>
						<li><a href="">정보수정</a></li>
					</ul>
				</li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="../article/list">게시판</a>
					<ul>
						<li><a href="../article/list?boardId=2">공지사항</a></li>
						<li><a href="">갤러리</a></li>
						<li><a href="">글쓰기</a></li>
					</ul>
				</li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line"><a href="">지도</a></li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line"><a href="">서비스</a></li>
			</ul>
		</div>
	</div>
</section>
