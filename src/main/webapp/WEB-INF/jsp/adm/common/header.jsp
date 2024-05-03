<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Meow</title>
	<link rel="icon" href="/images/favicon/cat-pow.ico" type="image/x-icon">
	<%@ include file="../../usr/common/head.jsp"%>
	
	<!-- 토스트 UI 차트 CDN -->
	<link rel="stylesheet" href="https://uicdn.toast.com/chart/latest/toastui-chart.min.css" />
	<script src="https://uicdn.toast.com/chart/latest/toastui-chart.min.js"></script>
	
	<!-- 토스트 UI 캘린터 팝업(생성, 상세보기) 사용을 위한 CDN, 순서 틀리면 에러발생 -->
	<link rel="stylesheet" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
	<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.js"></script>
	<link rel="stylesheet" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css" />
	<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.js"></script>
	
	<!-- 토스트 UI 캘린더 CDN -->
	<link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />
	<script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>
	<script>const Calendar = tui.Calendar;</script>
</head>
<body>

<!-- alert -->
<div id="alert" class="fixed top-0 left-1/2 transform -translate-x-1/2 z-50"></div>