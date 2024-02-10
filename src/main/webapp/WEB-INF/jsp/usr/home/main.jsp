<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../common/header.jsp"%>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${javaScriptKey }&libraries=services"></script>
<script type="text/javascript" src="/resources/js/main.js"></script>

<script>
$(function() {
	var map;

	var mapContainer = document.getElementById('map'), // 지도를 표시할 div
		mapOption = {
			center: null,
			level: 5 // 지도의 확대 레벨
		};

	// 유저의 주소 가져오기, 기본값 코리아IT 대전지점 주소 
	const loginedMemberAddress = "${memberAddress}";

	// 로그인한 유저의 중심좌표
	geocodeAddress(loginedMemberAddress, function(result) {
		mapOption.center = new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x));
		map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성
		getMembers(map);
	});
})

function getMembers(map) {

	$.ajax({
		url: "../member/getMembers",
		method: "get",
		data: {},
		dataType: "json",
		success: function(data) {
			data.forEach(function(member, idx) {
				geocodeAddress(member.address, function(result) {
					let content = `
                        <div id="${'${member.id}'}" class="wrap">
                    		<div>${'${result[0].address_name}'}</div>
                            <div>
                            	<ul>
                            		<li>${'${member.nickname}'}</li>
                            		<a href="/">asdasd</a>
                            	</ul>
                            </div>
                        </div>
                    `;

					var marker = new kakao.maps.Marker({
						map: map,
						position: new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x)),
					});

					iwRemoveable = true;


					var infowindow = new kakao.maps.InfoWindow({
						content: content,
						removable: iwRemoveable
					});

					kakao.maps.event.addListener(marker, 'click', function() {
						infowindow.open(map, marker);
					});
				});
			});
		},
		error: function(xhr, status, error) {
			console.error("ERROR : " + status + " - " + error);
		}
	});
}
</script>

<!-- <script>
	//메인페이지에만 효과 적용
	if (window.location.pathname === '/usr/home/main') {
		$("body").prepend(`<div class="h-10 border-b" style="background-color: #EEEDEB;"></div>`);
		$("body").css('overflow-y', 'hidden');
	}
</script> -->

<section class="">
	<div id="map" style="width:100%; height: 350px;"></div>
</section>

<%@ include file="../common/footer.jsp"%>