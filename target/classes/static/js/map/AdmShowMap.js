/**
 * 관리자 페이지의 지도 관련 js
 */

let geocoder = new kakao.maps.services.Geocoder();		// 주소 검색을 위한 geocoder

// 중심 좌표 기준으로 반경에 원 그리기
var circle = new kakao.maps.Circle({
	strokeWeight: 2, 			// 선 두께
	strokeColor: 'indigo', 		// 선 색깔
    fillColor: 'white', 		// 채우기 색깔
    fillOpacity: 0.2,  			// 채우기 불투명도
});
let center;
var line = new kakao.maps.Polyline();
var markers = [];										// 마커를 담을 배열, 전체 초기화 용도
var overlays = [];										// 오버레이를 담을 배열, 전체 초기화 용도

let callback = function(result, status) {				// 주소를 검색 후 결과값을 리턴하는 callback 함수
    if (status === kakao.maps.services.Status.OK) {
       	return result;
    }
};

// 유저들의 주소 마커표시, ajax
function setMarkers(map, radius) {
	let memberObj;
	let membersAddress = [];
	
    if(radius <= 500000) {
        circle.setMap(map);
        circle.setPosition(center);
        circle.setRadius(radius);
    } else {
        circle.setMap(null);
    }

	$.ajax({
		url: "../member/getMembers",
		method: "get",
		data: {},
		dataType: "json",
		success: function(data) {
			const members = data.data;
			
			$(members).each(function(idx, member){
				// 반복마다 초기화
				memberObj = {
					memberId: '',
					address: '',
					members: ''
				}
				const existIdx = membersAddress.findIndex(mObj => mObj.address === member.address);
				const setAddress = member.address.length != 0 ? member.address : '대전 둔산동';
				
			  	if (existIdx === -1) {	// 중복이 아닌 경우
			  		memberObj.address = setAddress;
			  		memberObj.memberId = `${member.id}`;
			    	memberObj.members = member.nickname;
			   	 	membersAddress.push(memberObj);
			  	} else {				// 중복인 경우
			    	membersAddress[existIdx].memberId += ',' + member.id;
			    	membersAddress[existIdx].members += ',' + member.nickname;
		  		}
			});
			
			markers = [];
			overlays = [];
			
			$(membersAddress).each(function(idx, addressInfo){
				geocoder.addressSearch(addressInfo.address, function(result, status) {
					if (status === kakao.maps.services.Status.OK) {
						const nicknames = addressInfo.members.split(",");
						const memberId = addressInfo.memberId.split(",");
						let content = `
	                        <div id="${idx}" class="overlay-wrap w-52 border shadow-2xl rounded-xl bg-white p-2.5 absolute z-0 bottom-12 -left-32 whitespace-nowrap cursor-default">
	                        	<div class="grid grid-cols-10 w-full break-all">
	                    			<div class="col-start-1 col-end-2"><i class="fa-solid fa-location-dot"></i></div>
	                    			<div class="col-start-2 col-end-10 whitespace-normal">${result[0].address_name}</div>
	                    			<button class="btn btn-xs btn-square col-start-10 col-end-11" onclick="closeMarker(this, ${idx});">
										<svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
									</button>
		                    		<div class="col-start-1 col-end-2"><i class="fa-solid fa-user"></i></div>
		                    		<div class="col-start-2 col-end-11">${nicknames.length}</div>
	                    		</div>
	                            <div>
	                            	<ul class="border-2 rounded grid grid-cols-4">
						`;
						
						// 유저 닉네임 추가
						$(nicknames).each(function(idx, nickname) {
							content += `
								<li class="nickname-wrap relative h-8 text-sm overflow-hidden hover:bg-gray-100 text-center cursor-pointer">
									<span class="nickname absolute left-0 bg-indigo-50">${nickname}</span>
								</li>
							`;
						});
						content += `</ul></div></div>`;
	                    
						const marker = new kakao.maps.Marker({
							map: map,
							position: new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x)),
						});
						
				        var path = [marker.getPosition(), center];
				        line.setPath(path);
						
				        // 마커와 원의 중심 사이의 거리
				        var dist = line.getLength();
				
				        // 이 거리가 원의 반지름보다 작거나 같다면
				        if (dist <= radius) {
				            // 해당 marker는 원 안에 있는 것
				            marker.setMap(map);
				            markers.push(marker);
				        } else {
				            return marker.setMap(null);
				        }
				        
						const overlay = new kakao.maps.CustomOverlay({
                            content: content,
                            map: map,
                            position: marker.getPosition()
                        });
						moveNickname();
						
                        // 마커를 클릭했을 때 커스텀 오버레이를 표시
                        kakao.maps.event.addListener(marker, 'click', function () {
							overlay.setMap(null);
                            overlay.setMap(map);
                        });
                        
                        // 지도에 표시되는 커스텀 오버레이를 미리 제거
                        overlay.setMap(null);
                        overlays.push(overlay);
					} else {
						console.error('Geocoding failed for address:', member.address);
					}
				});
			});
		},
		error: function(xhr, status, error) {
			console.error("ERROR : " + status + " - " + error);
		}
	});
}

// 닉네임 클릭 시 
/*function clickNickname(memberId){
	$("#map-info-wrap").addClass("shoMapInWarp");
	
	$.ajax({
		url: '../member/getMemberById',
	    method: 'GET',
	    data: {
	    	memberId: memberId,
	    },
	    dataType: 'json',
	    success: function(data) {
			const result = data.data;
			if(data.success) {
				const nickname = result.member.nickname;
				const catsLen = result.companionCats.length;
				
				let memberInfo = `
					<div>
						<div class="border-2 rounded-full w-1/2 text-center text-lg mx-auto mb-3">${nickname == loginedMemberNickname ? nickname + ' (나)' : nickname}</div>
						<div>${catsLen == 0 ? "현재 등록된 반려묘가 없습니다." : "반려묘 " + catsLen + "마리 집사"}</div>
						<ul>
				`;
				for(let i = 0; i < catsLen; i++) {
					memberInfo += `
						<li>${i + 1}. ${result.companionCats[i].name}</li>
					`;
				}
				
				if(nickname != loginedMemberNickname) {
					memberInfo += `
								</ul>
							</div>
							<div class="grid grid-cols-4 join">
								<button class="join-item btn btn-outline">프로필 보기</button>
								<button class="join-item btn btn-outline" onclick="sendRequest(${result.member.id}, 'friend')">친구추가</button>
								<button class="join-item btn btn-outline" onclick="openPop(${loginedMemberId}, ${result.member.id});">채팅</button>
								<button class="join-item btn btn-outline" onclick="showReportModal('member', ${result.member.id}, 0)">신고</button>
							</div>
						`;
					}
				
				$("#map-info-wrap>div").html(memberInfo);
				$("#map-info-wrap").css({
					"animation": "showMapInfoWrap .5s ease-in-out",
					"animation-fill-mode": "forwards"
				});
			}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}*/

// 마커 커스텀 오버레이 제거
function closeMarker(btn, idx) {
	const overlay = $(btn).closest(".overlay-wrap").parent();

	overlay.css({
		"opacity": "0"
		, "transition": "opacity .4s"
	});
	
	setTimeout(function(){
		overlay.css({
			"opacity": "1"
		});	
		
		for(let i = 0; i < overlays.length; i++) {
			if(overlay[0] == overlays[i].a){
				overlays[i].setMap(null);
				break;
			}
		}
	}, 400);
}

// 오버레이 내의 닉네임 태그의 마우스 이벤트
// (오버레이 내의 닉네임 hover시 닉네임이 움직이는 함수)
// * 첫 표시 범위를 늘렸을 때(라디오 버튼 클릭) 적용이 안되는 오류가있음. 다시 줄였다 늘리면 오류는 없어지는데 번거로움
function moveNickname() {
	$(".nickname-wrap").on({
		mouseenter: function() {								// 마우스를 올렸을 때
			$(this).children().stop(true);						// 현재 애니메이션을 초기상태로 되돌리는 작업
			const nicknameWrapWidth  = $(this).width();			// 닉네임이 들어갈 공간의 길이
	        const nicknameWdith = $(this).children().width();	// 닉네임 길이
	        
			// 닉네임의 길이가 닉네임Wrap보다 클때
	        if (nicknameWdith > nicknameWrapWidth) {
		        $(this).children().animate({left: nicknameWrapWidth - nicknameWdith}, 600);
	        }
	    },
	    mouseleave: function() {								// 마우스를 내렸을 때
	       	$(this).children().animate({left: 0}, 600);
	    }
	});
}

$(function() {
	let map;
	let level = 7;
	let radius = 2000;
	let mapContainer = document.getElementById('map'), 	// 지도를 표시할 태그
		mapOption = {									// 지도 옵션
			center: null,
			level: level 									// 지도의 확대 레벨
		};
	
	// 시작 시 지도 표시
	geocoder.addressSearch(loginedMemberAddress, function(result, status) {
		if (status === kakao.maps.services.Status.OK) {
			mapOption.center = new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x));
			map = new kakao.maps.Map(mapContainer, mapOption);	// 지도 생성
			center = map.getCenter();							// 센터 지정
			setMarkers(map, radius);							// 마커 표시
		} else {
			console.error('Geocoding failed for address:', loginedMemberAddress);
		}
	});
	
	// 주소 검색
	$(".optionBtn").click(function(){
		let address = $('.search-address').val().trim();
		if($(this).attr("data-defaultAddr") !== undefined) {
			address = $(this).attr("data-defaultAddr");
			$('.search-address').val('')
			alertMsg('지도 초기화 완료', 'success');
		}
		
		if(address.length == 0) {
			return alertMsg("주소를 입력해주세요.", "warning");
		}
		
		radius = $('#radioBtn>input:checked').val();
		geocoder.addressSearch(address, function(result, status) {
			if (status === kakao.maps.services.Status.OK) {
				mapOption.center = new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x));
				map = new kakao.maps.Map(mapContainer, mapOption);	// 지도 생성
				center = map.getCenter();							// 센터 지정
				setMarkers(map, radius);							// 마커 표시
			} else if (status === kakao.maps.services.Status.ZERO_RESULT) {		// 검색 결과 없을 때
				alertMsg('검색 결과가 존재하지 않습니다.', 'warning');
		        return;
		    } else if (status === kakao.maps.services.Status.ERROR) {			// 검색 오류
		        alert('검색 결과 중 오류가 발생했습니다.', 'error');
		        return;
		    } else {
				console.error('Geocoding failed for address:', address);
			}
		});
	})
	
	$("#radioBtn>input").change(function(){
		circle.setMap(null)						// 표시원 지도에서 제거
		$(markers).each(function(idx, marker) {	// 마커 제거
			marker.setMap(null);
		});
		
		$(overlays).each(function(idx, overlay) {	// 오버레이 제거
			overlay.setMap(null);
		})
		radius = $(this).val()
		setMarkers(map, $(this).val());
	});
	
	// swap 버튼 클릭 시
	$(".swap>input").change(function(){
		
		const swapWrap = $(this).closest('.swap-wrap');		// swap 클래스의 기준이 되는 부모
		const closeWt = $(swapWrap).children('.swap').outerWidth() - $(swapWrap).outerWidth();
		
		$(swapWrap).animate({
		    left: $(swapWrap).find('.swap>input').is(':checked') ? closeWt - 1 : 0
		}, 600);
		
		$(swapWrap).find('.swap>input').is(':checked')
		? setTimeout(function() {
			$(swapWrap).parent().removeClass('z-20');
		}, 600)
		: $(swapWrap).parent().addClass('z-20');
	})
})