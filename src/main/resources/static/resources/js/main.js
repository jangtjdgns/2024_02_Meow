let geocoder = new kakao.maps.services.Geocoder();
let callback = function(result, status) {
    if (status === kakao.maps.services.Status.OK) {
       	return result;
    }
};

$(function() {
	let map;

	let mapContainer = document.getElementById('map'), // 지도를 표시할 div
		mapOption = {
			center: null,
			level: 5 // 지도의 확대 레벨
		};

	geocoder.addressSearch(loginedMemberAddress, function(result, status) {
		if (status === kakao.maps.services.Status.OK) {
			mapOption.center = new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x));
			map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성
			getMembers(map);
		} else {
			console.error('Geocoding failed for address:', loginedMemberAddress);
		}
	});
})

function getMembers(map) {
	
	$.ajax({
		url: "../member/getMembers",
		method: "get",
		data: {},
		dataType: "json",
		success: function(data) {
			data.forEach(function(member, idx){
				geocoder.addressSearch(member.address, function(result, status) {
					if (status === kakao.maps.services.Status.OK) {
						let content = `
	                        <div id="${member.id}" class="wrap">
	                    		<div>${result[0].address_name}</div>
	                            <div>
	                            	<ul>
	                            		<li>${member.nickname}</li>
	                            		<a href="#">링크이동</a>
	                            	</ul>
	                            </div>
	                        </div>
	                    `;
	                    
						let marker = new kakao.maps.Marker({
							map: map,
							position: new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x)),
						});

						iwRemoveable = true;

						let infowindow = new kakao.maps.InfoWindow({
							content: content,
							removable: iwRemoveable
						});

						kakao.maps.event.addListener(marker, 'click', function() {
							infowindow.open(map, marker);
						});
					} else {
						console.error('Geocoding failed for address:', member.address);
					}
				});
			})
		},
		error: function(xhr, status, error) {
			console.error("ERROR : " + status + " - " + error);
		}
	});
}