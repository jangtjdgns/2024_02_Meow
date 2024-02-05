<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Meow</title>
	<link rel="icon" href="/resources/image/favicon/cat-pow.ico" type="image/x-icon">
	<%@ include file="../common/head.jsp"%>
</head>

<body>

<header class="h-top-t" style="background-color: #EEEDEB;">
	<div class="h-full mx-auto max-w-4xl flex items-center justify-end">
		<div class="font-Pretendard pr-6">
			<!-- <a class="btn btn-ghost btn-xs text-sm">공지사항</a>
			<a class="btn btn-ghost btn-xs text-sm">게시판</a>
			<a class="btn btn-ghost btn-xs text-sm">도움</a> -->
		</div>

		<div class="flex items-center px-4">
			<a href=""><i class="fa-brands fa-instagram"></i></a>
			<a href="" class="px-2.5"><i class="fa-brands fa-facebook-f"></i></a>
			<a href=""><i class="fa-brands fa-youtube"></i></a>
			<a href="" class="pl-2.5"><i class="fa-brands fa-github"></i></a>
		</div>
	</div>
</header>

<section class="h-top-b mx-auto max-w-4xl">
	<div class="h-full navbar bg-base-100">
		<div class="navbar-start">
			<div class="dropdown">
				<div tabindex="0" role="button" class="btn btn-ghost btn-circle">
					<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" /></svg>
				</div>
				<ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
					<li><a>Homepage</a></li>
					<li><a href="../article/list">List</a></li>
					<li><a>About</a></li>
				</ul>
			</div>
		</div>
		<div class="navbar-center">
			<a href="/" class="btn btn-ghost text-xl">Meow</a>
		</div>
		<div class="navbar-end">
			<button class="btn btn-ghost btn-circle">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
			</button>
			<button class="btn btn-ghost btn-circle">
				<div class="indicator">
					<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
					<span class="badge badge-xs badge-primary indicator-item"></span>
				</div>
			</button>
		</div>

		<div class="dropdown dropdown-start">
			<div tabindex="0" role="button"
				class="btn btn-ghost btn-circle avatar">
				<div class="w-10 rounded-full">
					<img alt="Tailwind CSS Navbar component" src="https://cdn.pixabay.com/photo/2020/11/15/18/31/cat-5746771_960_720.png" />
				</div>
			</div>
			<ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-24">
				<li><a>프로필</a></li>
				<li><a>계정관리</a></li>
				<li><a>로그아웃</a></li>
			</ul>
		</div>
	</div>
</section>
