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
<body>

<!-- alert -->
<div id="alert" class="fixed top-0 left-1/2 transform -translate-x-1/2 z-50"></div>