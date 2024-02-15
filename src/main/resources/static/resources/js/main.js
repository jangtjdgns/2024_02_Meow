let geocoder = new kakao.maps.services.Geocoder();		// 주소 검색을 위한 geocoder
let callback = function(result, status) {				// 주소를 검색 후 결과값을 리턴하는 callback 함수
    if (status === kakao.maps.services.Status.OK) {
       	return result;
    }
};

// 마커 커스텀 오버레이 제거
function closeMarker(btn) {
	const overlay = $(btn).closest(".overlay-wrap").parent();
	
	overlay.css({
		"opacity": "0"
		, "transition": "opacity .4s"
	});
	
	setTimeout(function(){
		overlay.css({
			"opacity": "1"
		});	
		
		overlay.remove();
	}, 400);
}

// 유저들의 주소 마커표시
function getMembers(map) {
	let memberObj;
	let membersAddress = [];
	
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
			    	memberObj.members = member.nickname;	// memberObj 객체의 members 속성에 member의 닉네임을 값으로 추가
			   	 	membersAddress.push(memberObj);			// membersAddress 배열에 memberObj 객체를 추가
			  	} else {															// 중복인 경우
			    	membersAddress[existIdx].members += ',' + member.nickname;		// 중복되는 배열의 idx를 통해 해당 배열의 객체 속성인 members에 닉네임을 이어서 추가
		  		}
			});
			
			$(membersAddress).each(function(idx, addressInfo){
				
				geocoder.addressSearch(addressInfo.address, function(result, status) {
					if (status === kakao.maps.services.Status.OK) {
						const nicknames = addressInfo.members.split(",");
						
						let content = `
	                        <div id="${idx}" class="overlay-wrap w-56 border shadow-2xl rounded-xl bg-white p-2.5 absolute z-0 bottom-12 -left-32 whitespace-nowrap cursor-default">
	                        	<div class="flex justify-between">
	                    			<div><i class="fa-solid fa-location-dot"></i> <span>${result[0].address_name}</span></div>
	                    			<button class="btn btn-xs btn-square" onclick="closeMarker(this)">
										<svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
									</button>
	                    		</div>
	                            <div>
	                            	<div><i class="fa-solid fa-user"></i> <span>${nicknames.length}</span></div>
	                            	<ul class="border-2 rounded">
						`;
						
						// 유저 닉네임 추가
						$(nicknames).each(function(idx, nikcname) {
							content += `
								<li class="flex items-center justify-between py-1 px-2 text-sm">
									<div>${nikcname}</div>
									<div class="dropdown dropdown-right">
									  	<div tabindex="0" role="button" class="plus-btn"><i class="fa-solid fa-plus"></i></div>
									  	<ul tabindex="0" class="dropdown-content z-[1] menu p-2 border shadow-lg bg-base-100 rounded-box">
											<li><a>프로필 보기</a></li>
											<li><a>친구추가</a></li>
											<li><a>신고</a></li>
										</ul>
									</div>
								</li>
							`;
						});
						
						content += `
	                            	</ul>
	                            	
	                            </div>
	                        </div>						
						`;
						
						// 마커 커스텀 이미지
						let imageSrc = '/resources/images/marker/2.png',
						    imageSize = new kakao.maps.Size(36, 37),
						    imageOption = {offset: new kakao.maps.Point(27, 69)};
						
						let markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
	                    
						const marker = new kakao.maps.Marker({
							map: map,
							position: new kakao.maps.LatLng(parseFloat(result[0].y), parseFloat(result[0].x)),
							image: markerImage
						});

						const overlay = new kakao.maps.CustomOverlay({
						    content: content,
						    map: map,
						    position: marker.getPosition()
						});
						
						// 마커를 클릭했을 때 커스텀 오버레이를 표시
						kakao.maps.event.addListener(marker, 'click', function() {
							overlay.setMap(null);
						    overlay.setMap(map);
						});
						// 지도에 표시되는 커스텀 오버레이를 미리 제거
						overlay.setMap(null);
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
			getMembers(map);
		} else {
			console.error('Geocoding failed for address:', loginedMemberAddress);
		}
	});
})