<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../common/header.jsp"%>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${javaScriptKey }&libraries=services"></script>
<!-- 유저의 주소 가져오기, 기본값 코리아IT 대전지점 주소 -->
<c:if test="${rq.loginedMemberId != 0 }">
	<script>const loginedMemberAddress = "${memberAddress}";</script>
	<script type="text/javascript" src="/resources/js/main.js"></script>
</c:if>
<!-- <script>
	//메인페이지에만 효과 적용
	if (window.location.pathname === '/usr/home/main') {
		$("body").prepend(`<div class="h-10 border-b" style="background-color: #EEEDEB;"></div>`);
		$("body").css('overflow-y', 'hidden');
	}
</script> -->

<section class="">
	<c:if test="${rq.loginedMemberId != 0 }">
		<div id="map" style="width:100%; height: 350px;"></div>
	</c:if>
	
	<c:if test="${rq.loginedMemberId == 0 }">
		<div class="flex items-center justify-center border bg-black opacity-70" style="width:100%; height: 350px;">
			<span class="text-white pr-1.5">로그인 후 이용가능합니다.</span>
			<a class="text-red-500 hover:text-red-600 hover:underline " href="../member/login">로그인 이동</a>
		</div>
	</c:if>
</section>

<%@ include file="../common/footer.jsp"%>