/** 
 * 관리자 페이지의 지도 관련 js 
 */

var geocoder = new kakao.maps.services.Geocoder();		// 주소 검색을 위한 geocoder

// 중심 좌표 기준으로 반경에 원 그리기
var circle = new kakao.maps.Circle({
	strokeWeight: 2, 			// 선 두께
	strokeColor: 'indigo', 		// 선 색깔
    fillColor: 'white', 		// 채우기 색깔
    fillOpacity: 0.2,  			// 채우기 불투명도
});
var center;
var line = new kakao.maps.Polyline();
var markers = [];										// 마커를 담을 배열, 전체 초기화 용도
var overlays = [];										// 오버레이를 담을 배열, 전체 초기화 용도

var callback = function(result, status) {				// 주소를 검색 후 결과값을 리턴하는 callback 함수
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
	                            	<ul class="border-2 rounded grid grid-cols-3">
						`;
						
						// 유저 닉네임 추가
						$(nicknames).each(function(idx, nickname) {
							content += `
								<li class="nickname-wrap relative h-8 overflow-hidden hover:bg-gray-100 cursor-pointer border-r flex items-center justify-center" onclick="getMember(${memberId[idx]})">
									<span class="nickname absolute left-0 text-sm">&nbsp;${nickname}&nbsp;</span>
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
function getMember(memberId){
	
	$.ajax({
		url: '../member/detail',
	    method: 'GET',
	    data: {
	    	memberId: memberId,
	    },
	    dataType: 'json',
	    success: function(data) {
			if(data.success) {
				const member = data.data;
				
				// 전화 번호 하이픈 존재 유무 확인
				const cellphoneNum = member.cellphoneNum;
				let phoneNum = '';
				// 없으면 추가
				if(!cellphoneNum.includes("-")) {
					phoneNum += cellphoneNum.substring(0,3) + '-';
					phoneNum += cellphoneNum.substring(3,7) + '-';
					phoneNum += cellphoneNum.substring(7,11);
				} else {
					phoneNum = cellphoneNum;
				}
				
				// 주소
				let jibunAddress= '';
				let roadAddress = '';
				
				if(member.address.length !== 0) {
					const tempAddr = JSON.parse(member.address);
					const detailAddress = tempAddr.detailAddress.length == 0 ? '' : ' (' + tempAddr.detailAddress + ')';
					jibunAddress = `[${tempAddr.zonecode}] ${tempAddr.jibunAddress}${detailAddress}`;
		    		roadAddress = `[${tempAddr.zonecode}] ${tempAddr.roadAddress}${detailAddress}`;
				}
				
				// 소개말
				let aboutMe = member.aboutMe;
				aboutMe = aboutMe == null ? '' : aboutMe;
				
				// 회원 정보
				let memberInfo = `
					<div class="w-full border grid grid-rows-4 text-center">
						<div class="grid grid-cols-9 text-xs border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">이름</div>
							<div class="col-start-2 col-end-4 flex items-center justify-center">${member.name}</div>
							<div class="col-start-4 col-end-5 flex items-center justify-center font-bold bg-gray-100">닉네임</div>
							<div class="col-start-5 col-end-7 flex items-center justify-center">${member.nickname}</div>
							<div class="col-start-7 col-end-8 flex items-center justify-center font-bold bg-gray-100">나이</div>
							<div class="col-start-8 col-end-10 flex items-center justify-center">${member.age}살</div>
						</div>
						<div class="grid grid-cols-9 text-xs border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">아이디</div>
							<div class="col-start-2 col-end-4 flex items-center justify-center">${member.loginId}</div>
							<div class="col-start-4 col-end-5 flex items-center justify-center font-bold bg-gray-100">이메일</div>
							<div class="col-start-5 col-end-9 flex items-center justify-center">${member.email}</div>
							<div class="col-start-9 col-end-10 flex items-center justify-center">
								<button class="btn btn-sm btn-ghost"><i class="fa-regular fa-envelope fa-lg"></i></button>
							</div>
						</div>
						<div class="grid grid-cols-9 text-xs border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">유형</div>
							<div class="col-start-2 col-end-4 flex items-center justify-center">${member.snsType == null ? '자체 회원' : `SNS&nbsp;<span class="font-bold">(${member.snsType})</span>`}</div>
							<div class="col-start-4 col-end-5 flex items-center justify-center font-bold bg-gray-100"><i class="fa-solid fa-mobile-screen-button fa-lg"></i></div>
							<div class="col-start-5 col-end-10 flex items-center justify-center">${phoneNum}</div>
						</div>
						<div class="grid grid-cols-9 text-xs">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">접속일</div>
							<div class="col-start-2 col-end-4 flex items-center justify-center">${member.lastLoginDaysDiff}일 전</div>
							<div class="col-start-4 col-end-5 flex items-center justify-center font-bold bg-gray-100">가입일</div>
							<div class="col-start-5 col-end-10 flex items-center justify-center">${member.regDate} (${getCalcDateDiffInDays(member.regDate)}일 전)</div>
						</div>
						
						<!-- 주소, 소개글 부분 -->
						<div class="grid grid-rows-4 text-center h-full border-t">
							<div class="grid grid-cols-9 grid-rows-2 row-start-1 row-end-3 text-xs border-b">
								<div class="col-start-1 col-end-2 row-start-1 row-end-3 flex items-center justify-center font-bold bg-gray-100 border-r">주소</div>
								<div class="col-start-2 col-end-3 flex items-center justify-center font-bold bg-gray-100 border-b">지번</div>
								<div class="col-start-3 col-end-10 flex items-center justify-center border-b">${jibunAddress}</div>
								<div class="col-start-2 col-end-3 flex items-center justify-center font-bold bg-gray-100">도로명</div>
								<div class="col-start-3 col-end-10 flex items-center justify-center">${roadAddress}</div>
							</div>
							<div class="grid grid-cols-9 text-xs row-start-3 row-end-5">
								<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">소개</div>
								<div class="col-start-2 col-end-10 flex items-center justify-center">
									<textarea class="resize-none textarea w-full h-full focus:outline-none focus:border-0" placeholder="작성된 소개말이 없습니다." readonly>${aboutMe}</textarea>
								</div>
							</div>
						</div>
					</div>
				`;
				
				// 회원번호
				const memberId = `
					<div class="badge badge-neutral badge-md">${member.id}번 회원</div>
				`;
				
				$(".member-info-body").html(memberInfo);
				$("#member-info-wrap>div>.member-info-nickname").html(memberId);
				if(parseInt($("#member-info-wrap").css('right')) < 0) {
					$("#member-info-wrap").css({
						"animation": "showMapInfoWrap .5s ease-in-out",
						"animation-fill-mode": "forwards"
					});
				}
			}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

// 유저 정보 컨테이너 닫기
function closeInfoWarp() {
	$("#member-info-wrap").css({
		"animation": "hideMapInfoWrap .5s ease-in-out",
		"animation-fill-mode": "forwards"
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


// 로드 후
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