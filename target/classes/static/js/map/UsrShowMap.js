/**
 * 메인페이지 상단에 표시되는 지도 관련 js
 */

 let geocoder = new kakao.maps.services.Geocoder();		// 주소 검색을 위한 geocoder

// 중심 좌표 기준으로 반경에 원 그리기
var circle = new kakao.maps.Circle({
	strokeWeight: 6, 			// 선 두께
	strokeColor: 'purple', 		// 선 색깔
    fillColor: 'white', 		// 채우기 색깔
    fillOpacity: 0.3  			// 채우기 불투명도
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
function getMembers(map, radius) {
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
				
				// membersAddress 배열의 각 인덱스에 존재하는 객체의 address 속성 값과 member(반복문)의 값이 같은지 확인
				// 같다 		=> 	존재함 (중복O) 			=> 	해당 배열의 인덱스 반환
				// 같지 않다 	=> 	존재하지 않음 (중복X) 	=> 	-1 반환
				const existIdx = membersAddress.findIndex(mObj => mObj.address === member.address);
				
				const address = member.address.length != 0 ? member.address : '대전둔산동';
				
			  	if (existIdx === -1) {						// 중복이 아닌 경우
			  		memberObj.address = address;			// memberObj 객체의 address 속성에 member의 주소를 값으로 추가
			  		memberObj.memberId = `${member.id}`;
			    	memberObj.members = member.nickname;	// memberObj 객체의 members 속성에 member의 닉네임을 값으로 추가
			   	 	membersAddress.push(memberObj);			// membersAddress 배열에 memberObj 객체를 추가
			  	} else {															// 중복인 경우
			    	membersAddress[existIdx].memberId += ',' + member.id;
			    	membersAddress[existIdx].members += ',' + member.nickname;		// 중복되는 배열의 idx를 통해 해당 배열의 객체 속성인 members에 닉네임을 이어서 추가
		  		}
			});
			
			$(membersAddress).each(function(idx, addressInfo){
				
				geocoder.addressSearch(addressInfo.address, function(result, status) {
					if (status === kakao.maps.services.Status.OK) {
						const nicknames = addressInfo.members.split(",");
						const memberId = addressInfo.memberId.split(",");
						let content = `
	                        <div id="${idx}" class="overlay-wrap w-56 border shadow-2xl rounded-xl bg-white p-2.5 absolute z-0 bottom-12 -left-32 whitespace-nowrap cursor-default">
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
	                            	<ul class="border-2 rounded">
						`;
						
						// 유저 닉네임 추가
						$(nicknames).each(function(idx, nickname) {
							content += `
								<li class="member-wrap flex items-center justify-between py-1 px-2 text-sm hover:bg-gray-100 cursor-pointer" onclick="clickNickname(${memberId[idx]});">
									<div>${nickname == loginedMemberNickname ? nickname + ' (나)' : nickname}</div>
									<div class="dropdown dropdown-right">
									  	<div tabindex="0" role="button" class="plus-btn"><i class="fa-solid fa-plus"></i></div>
									  	<ul tabindex="0" class="dropdown-content z-[1] menu p-2 border shadow-lg bg-base-100 rounded-box w-32">
											<li><a>프로필 보기</a></li>
							`;
							
							if(nickname != loginedMemberNickname) {
								content += `
									<li><button onclick="sendRequest(${memberId[idx]}, 'friend')">친구추가</button></li>
									<li><button onclick="openPop(${loginedMemberId}, ${memberId[idx]});">채팅</button></li>
									<li><button onclick="showReportModal('member', ${memberId[idx]}, 0)">신고</button></li>
								`;
							}
							
							content += `</ul></div></li>`
						});
						
						content += `</ul></div></div>						
						`;
						
						// 마커 커스텀 이미지
						/*let imageSrc = '/images/marker/2.png',
						    imageSize = new kakao.maps.Size(36, 37),
						    imageOption = {offset: new kakao.maps.Point(27, 69)};
						
						let markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);*/
	                    
						const marker = new kakao.maps.Marker({
							map: map,
							position: new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x)),
							/*image: markerImage*/
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

// 마커 커스텀 오버레이안의 닉네임 클릭 시 해당 유저의 정보 표시
function clickNickname(memberId){
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
}

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

// 유저 정보 컨테이너 닫기
function closeInfoWarp() {
	$("#map-info-wrap").css({
		"animation": "hideMapInfoWrap .5s ease-in-out",
		"animation-fill-mode": "forwards"
	});
}


$(function() {
	let map;

	let mapContainer = document.getElementById('map'), // 지도를 표시할 div
		mapOption = {
			center: null,
			level: 6 // 지도의 확대 레벨
		};
		
	geocoder.addressSearch(loginedMemberAddress, function(result, status) {
		if (status === kakao.maps.services.Status.OK) {
			mapOption.center = new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x));
			map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성
			center = map.getCenter();
			getMembers(map, 2000);
		} else {
			console.error('Geocoding failed for address:', loginedMemberAddress);
		}
	});
	
	$("#radioBtn>input").change(function(){
		circle.setMap(null)							// 원 지도에서 제거
		$(markers).each(function(idx, marker) {		// 마커 제거
			marker.setMap(null);
		});
		
		$(overlays).each(function(idx, overlay) {	// 오버레이 제거
			overlay.setMap(null);
		})
		
		getMembers(map, $(this).val());
	});
})
