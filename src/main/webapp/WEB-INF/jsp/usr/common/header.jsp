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

<section class="h-mh mx-auto max-w-7xl flex items-end justify-between">
	<div>
		<a href="/"><img src="/resources/images/Meow-logo.png" class="w-24" /></a>
	</div>
	
	<div class="flex flex-col-reverse h-h w-1/2">
		<div class="menu-box">
			<ul class="w-full h-full font-NanumSquareNeo bg-white text-center">
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="1">메인</a>
				</li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="2">반려묘</a>
					<ul>
						<li><a href="">등록</a></li>
						<li><a href="">정보수정</a></li>
					</ul>
				</li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="../article/list">게시판</a>
					<ul>
						<li><a href="">공지사항</a></li>
						<li><a href="">갤러리</a></li>
						<li><a href="">글쓰기</a></li>
					</ul>
				</li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line"><a href="">지도</a></li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line"><a href="">서비스</a></li>
			</ul>
		</div>
		
		<c:if test="${rq.loginedMemberId == 0 }">
			<div class="w-5/6 flex items-center justify-end h-full">
				<a href="../member/login" class="btn btn-ghost btn-xs h-8">로그인</a>
				<a href="" class="btn btn-ghost btn-xs h-8">회원가입</a>		
			</div>
		</c:if>
	
		<c:if test="${rq.loginedMemberId != 0 }">
			<div class="dropdown dropdown-start">
				<div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
					<div class="w-10 rounded-full">
						<img alt="Tailwind CSS Navbar component" src="https://cdn.pixabay.com/photo/2020/11/15/18/31/cat-5746771_960_720.png" />
					</div>
				</div>
				<ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-24">
					<li><a>프로필</a></li>
					<li><a>계정관리</a></li>
					<li><a href="../member/doLogout" onclick="if(!confirm('로그아웃 하시겠습니까?')) return false;">로그아웃</a></li>
				</ul>
			</div>
		</c:if>
	</div>
</section>
