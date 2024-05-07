<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script src="/js/adm/other/calendar.js"></script>

<div class="grid h-full" style="grid-template-rows: 4rem 1fr">
	<div class="flex items-center justify-between">
		<!-- navbar -->
		<nav class="navbar gap-2">
			<select class="select select-bordered select-sm change-view" autocomplete="off" onchange="onChangeView(this)">
				<option value="month" selected>월</option>
				<option value="week">주</option>
				<option value="day">일</option>
			</select>
			<button class="btn btn-sm today" onclick="onClickTodayBtn()">오늘</button>
			<button class="btn btn-sm btn-circle prev" onclick="moveToNextOrPrevRange(-1)"><i class="fa-solid fa-angle-left"></i></button>
			<button class="btn btn-sm btn-circle next" onclick="moveToNextOrPrevRange(1)"><i class="fa-solid fa-angle-right"></i></button>
			<span class="date-range"></span>
		</nav>
		<div class="w-96 flex justify-end pr-4 text-xl"><span class="font-bold">${rq.loginedMemberNickname }</span>&nbsp;님의 캘린더</div>
	</div>
	
	<!-- calendar -->
	<div id="calendar" class="[min-height:600px] h-full"></div>
</div>