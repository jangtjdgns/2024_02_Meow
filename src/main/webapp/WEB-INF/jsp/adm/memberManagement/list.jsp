<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
	// 회원 목록 가져오기
	function admGetMembers() {
		const page = $('#page').val().trim();
		const memberCnt = $('#memberCnt').val().trim();
		const searchType = $('#searchType').val().trim();
		const searchKeyword = $('#searchKeyword').val().trim();
		const memberType = $('.memberType[name="memberType"]:checked').val();
		const order = $('#order').prop("checked");
		
		$.ajax({
			url: '/adm/member/list',
		    method: 'GET',
		    data: {
		    	page: page,
		    	memberCnt: memberCnt,
		    	searchType: searchType,
		    	searchKeyword: searchKeyword,
		    	memberType: memberType,
		    	order: order
		    },
		    dataType: 'json',
		    success: function(data) {
		    	$(".members").empty();
		    	if(data.success) {
		    		const members = data.data;
		    		
		    		for(let i = 0; i < members.length; i++) {
		    			const member = `
		    				<tr class="hover:bg-gray-50 cursor-pointer" onclick="admGetMember(\${members[i].id})">
					        	<td class="font-bold">\${i + 1}</td>
					        	<td>\${members[i].id}</td>
					        	<td>\${members[i].name}</td>
					        	<td>\${members[i].nickname}</td>
					        	<td>\${members[i].loginId}</td>
					        	<td>\${members[i].age}</td>
					        	<td>\${members[i].cellphoneNum}</td>
					        	<td>\${members[i].email}</td>
					        	<td>\${members[i].regDate}</td>
					        	<td class="text-left truncate [width:150px] [max-width:150px]"">\${members[i].aboutMe == null ? '' : members[i].aboutMe}</td>
					        	<td>\${members[i].lastLoginDaysDiff}일 전</td>
					        	<td>\${members[i].snsType == null ? '자체회원' : 'SNS회원'}</td>
					        	<td>\${members[i].status}</td>
					      	</tr>
		    			`;
		    			
		    			$(".members").append(member);
		    		} 
		    	} else {
		    		// colspan 최대 13인데 보기에 별로임
		    		$(".members").append(`
		    			<tr>
			    			<td colspan=10>\${data.msg}</td>
			    		</tr>
		    		`);
		    		
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			},
		});
	}
	
	// 회원 정보 가져오기
	function admGetMember(memberId) {
		$.ajax({
			url: '/adm/member/detail',
		    method: 'GET',
		    data: {
		    	memberId: memberId,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	
		    	$(".member").empty();
		    	
		    	if(data.success) {
		    		const memberInfo = data.data;
		    		setMember(memberInfo);
		    		getArticleFreq(memberId);
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			},
		});
	}
	
	// 게시글 작성 빈도 차트
	function getArticleFreq(memberId) {
		
		// 회원 선택 했는지 확인
		if($(".chart-default-msg").has(".hidden").length == 0) {
			$(".chart-default-msg").addClass("hidden");
			$(".chart-option").removeClass("hidden");
		}
		
		const interval = $('.interval[name="interval"]:checked').val();
		const intervalFreq = $('.intervalFreq').val();
		const barCnt = $('.barCnt').val();
		
		// 차트 데이터
		const columnChartData = {
		    categories: [],
		    series: [
		       	{
		            name: '작성한 게시글 수',
		            data: []
		        },
		    ]
		}
		
		// 차트 옵션
		const options = {
			chart: {title: '게시글 등록 현황'},
		};
		
		$.ajax({
			url: '/adm/article/frequency',
		    method: 'GET',
		    data: {
		    	memberId: memberId,
		    	interval: interval,
		    	intervalFreq: intervalFreq,
		    	barCnt: barCnt,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	
		    	if(data.success) {
		    		const intervalFreq = data.data;
		    		
		    		for(let i = 0; i < intervalFreq.length; i++) {
		    			columnChartData.categories.push(intervalFreq[i].date);				// 차트 데이터 카테고리 속성에 date 추가
		    			columnChartData.series[0].data.push(intervalFreq[i].articleCnt);	// 차트 데이터 시리즈 속성의 데이터 속성에 게시글 수 추가
		    		}
		    	}
		    	
		    	// 차트 추가
		    	$("#columnChart").empty();
				const columnChart = document.getElementById('columnChart');
				new toastui.Chart.columnChart({ el: columnChart, data: columnChartData, options: options });
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			},
		});
	}
	
	// 회원 정보 표시 함수
	function setMember(memberInfo) {
		
		// 전화 번호 하이픈 존재 유무 확인
		const cellphoneNum = memberInfo.cellphoneNum;
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
		
		if(memberInfo.address.length !== 0) {
			const tempAddr = JSON.parse(memberInfo.address);
			const detailAddress = tempAddr.detailAddress.length == 0 ? '' : ' (' + tempAddr.detailAddress + ')';
			jibunAddress = `[\${tempAddr.zonecode}] \${tempAddr.jibunAddress}\${detailAddress}`;
    		roadAddress = `[\${tempAddr.zonecode}] \${tempAddr.roadAddress}\${detailAddress}`;
		}
		
		// 소개말
		let aboutMe = memberInfo.aboutMe;
		aboutMe = aboutMe == null ? '' : aboutMe;
		
		const member = `
			<div class="flex flex-col h-full p-2 gap-2 overflow-auto">
				<div class="flex h-40 gap-2">
    				<div class="avatar">
    				  	<div class="w-40 rounded">
    				  		<img src="\${memberInfo.profileImage != null ? memberInfo.profileImage : ''}" alt="이미지 없음" class="flex justify-center items-center border-2" />
    				  	</div>
    				</div>
    				
					<div class="w-full border grid grid-rows-4 text-center">
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">이름</div>
							<div class="col-start-2 col-end-4 flex items-center justify-center">\${memberInfo.name}</div>
							<div class="col-start-4 col-end-5 flex items-center justify-center font-bold bg-gray-100">닉네임</div>
							<div class="col-start-5 col-end-7 flex items-center justify-center">\${memberInfo.nickname}</div>
							<div class="col-start-7 col-end-8 flex items-center justify-center font-bold bg-gray-100">나이</div>
							<div class="col-start-8 col-end-10 flex items-center justify-center">\${memberInfo.age}살</div>
						</div>
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">아이디</div>
							<div class="col-start-2 col-end-4 flex items-center justify-center">\${memberInfo.loginId}</div>
							<div class="col-start-4 col-end-5 flex items-center justify-center font-bold bg-gray-100">이메일</div>
							<div class="col-start-5 col-end-9 flex items-center justify-center">\${memberInfo.email}</div>
							<div class="col-start-9 col-end-10 flex items-center justify-center">
								<button class="btn btn-sm btn-ghost"><i class="fa-regular fa-envelope fa-lg"></i></button>
							</div>
						</div>
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">유형</div>
							<div class="col-start-2 col-end-4 flex items-center justify-center">\${memberInfo.snsType == null ? '자체 회원' : `SNS&nbsp;<span class="font-bold">(\${memberInfo.snsType})</span>`}</div>
							<div class="col-start-4 col-end-5 flex items-center justify-center font-bold bg-gray-100"><i class="fa-solid fa-mobile-screen-button fa-lg"></i></div>
							<div class="col-start-5 col-end-10 flex items-center justify-center">\${phoneNum}</div>
						</div>
						<div class="grid grid-cols-9 text-sm">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">접속일</div>
							<div class="col-start-2 col-end-4 flex items-center justify-center">\${memberInfo.lastLoginDaysDiff}일 전</div>
							<div class="col-start-4 col-end-5 flex items-center justify-center font-bold bg-gray-100">가입일</div>
							<div class="col-start-5 col-end-10 flex items-center justify-center">\${memberInfo.regDate} (\${getCalcDateDiffInDays(memberInfo.regDate)}일 전)</div>
						</div>
					</div>
				</div>
				
				<div class="grid h-full gap-2" style="grid-template-columns: 160px 1fr">
					<div class="grid grid-rows-4 text-center h-full border">
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-5 flex items-center justify-center font-bold bg-gray-100">회원 번호</div>
							<div id="memberId" class="col-start-5 col-end-10 flex items-center justify-center">\${memberInfo.id}</div>
						</div>
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-5 flex items-center justify-center font-bold bg-gray-100">반려묘 수</div>
							<div class="col-start-5 col-end-10 flex items-center justify-center"><span class="catsCnt">0</span>&nbsp;/ 8</div>
						</div>
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-5 flex items-center justify-center font-bold bg-gray-100">상태</div>
							<div class="col-start-5 col-end-10 flex items-center justify-center">\${memberInfo.status}</div>
						</div>
						<div class="grid grid-cols-9 text-sm">
							<div class="col-start-1 col-end-10 flex items-center justify-center font-bold bg-gray-100">
								<button class="btn btn-sm btn-ghost w-full h-full">강제탈퇴진행</button>
							</div>
						</div>
					</div>
					
					<div class="grid grid-rows-4 text-center h-full border">
						<div class="grid grid-cols-9 grid-rows-2 row-start-1 row-end-3 text-sm border-b">
							<div class="col-start-1 col-end-2 row-start-1 row-end-3 flex items-center justify-center font-bold bg-gray-100 border-r">주소</div>
							<div class="col-start-2 col-end-3 flex items-center justify-center font-bold bg-gray-100 border-b">지번</div>
							<div class="col-start-3 col-end-10 flex items-center justify-center border-b">\${jibunAddress}</div>
							<div class="col-start-2 col-end-3 flex items-center justify-center font-bold bg-gray-100">도로명</div>
							<div class="col-start-3 col-end-10 flex items-center justify-center">\${roadAddress}</div>
						</div>
						<div class="grid grid-cols-9 text-sm row-start-3 row-end-5">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">소개</div>
							<div class="col-start-2 col-end-10 flex items-center justify-center">
								<textarea class="resize-none textarea w-full h-full focus:outline-none focus:border-0" placeholder="작성된 소개말이 없습니다." readonly>\${aboutMe}</textarea>
							</div>
						</div>
					</div>
				</div>
			</div>
		`;
		
		$(".member").append(member);
	}
	
	
	// 차트 옵션 변경 시
	function changeChartOption() {
		getArticleFreq($("#memberId").text());
	}
	
	
	$(function(){
		admGetMembers();
	})
</script>


<div class="grid grid-cols-4 grid-rows-2 p-4 gap-4 h-full">
	
	<!-- 회원 상세 정보 -->
	<div class="border-2 rounded-lg col-start-1 col-end-3 member">
		<div class="w-full h-full flex items-center justify-center text-lg">정보 확인을 원하는 회원을 선택해주세요.</div>
	</div>
	
	<!-- 게시글 작성 빈도 차트 -->
	<div class="border-2 rounded-lg col-start-3 col-end-5 relative grid grid-row-2" style="grid-template-rows: 1fr 50px ">
		<div class="chart-default-msg w-full h-full flex items-center justify-center text-lg row-start-1 row-end-3">차트 확인을 원하는 회원을 선택해주세요.</div>
		
		<!-- 열 차트 -->
		<div id="columnChart" class="[width:95%] h-full mx-auto"></div>
		
		<!-- 차트 옵션 -->
		<div class="chart-option grid grid-cols-9 items-center hidden">
			<div class="col-start-1 col-end-4 justify-self-center">
				<span class="pr-2">막대 수:</span>
				<input type="number" class="chart-options barCnt input input-bordered input-sm w-20" onchange="changeChartOption()" value="7" min="2" max="10" autocomplete="off" />
				
				<div class="dropdown dropdown-end">
					<div tabindex="0" role="button" class="btn btn-circle btn-ghost btn-xs text-info">
						<svg tabindex="0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="w-4 h-4 stroke-current">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
						</svg>
					</div>
					<div tabindex="0" class="card compact dropdown-content z-[1] shadow bg-base-100 rounded-box w-40">
						<div tabindex="0" class="card-body">
							<p class="break-all">결과 값의 길이가 지정한 막대 수 보다 작을 시 반영되지 않습니다.</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="col-start-4 col-end-7 justify-self-center">
				<span class="pr-2">간격:</span>
				<div class="join">
					<input class="chart-options interval join-item btn btn-sm" onchange="changeChartOption()" type="radio" name="interval" value="year" aria-label="년" />
				  	<input class="chart-options interval join-item btn btn-sm" onchange="changeChartOption()" type="radio" name="interval" value="month" aria-label="월" checked />
				  	<input class="chart-options interval join-item btn btn-sm" onchange="changeChartOption()" type="radio" name="interval" value="week" aria-label="주" />
				</div>
			</div>
			
			<div class="col-start-7 col-end-10 justify-self-center">
				<span>간격 주기:</span>
				<input type="number" class="chart-options intervalFreq input input-bordered input-sm w-20" onchange="changeChartOption()" value="6" min="1" autocomplete="off" />
			</div>
		</div>
	</div>
	
	<!-- 회원 목록 -->
	<div class="border-2 rounded-lg col-start-1 col-end-5">
		<div class="flex gap-2 p-2 w-full h-full">
			<div class="w-96 h-full shadow px-2">
				<div class="w-full text-xl text-center font-LINESeed p-2">회원 검색 옵션</div>
				
				<div class="relative h-full">
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-xs">페이지</span>
						    <span class="label-text text-xs">표시되는 회원 수</span>
					  	</div>
					  	<div class="flex gap-2">
							<input type="number" id="page" class="input input-sm input-bordered w-1/2" value="1" min="1" placeholder="기본값 1페이지" autocomplete="off" />
							<input type="number" id="memberCnt" class="input input-sm input-bordered w-1/2" value="10" min="1" placeholder="기본값 10명" autocomplete="off" />
						</div>
					</label>
					
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-xs">옵션 선택</span>
					  	</div>
					  	<div class="flex gap-2">
						  	<select id="searchType" class="select select-sm select-bordered">
							    <option value="all" selected>전체</option>
							    <option value="name">이름</option>
							    <option value="loginId">아이디</option>
							    <option value="nickname">닉네임</option>
							    <option value="email">이메일</option>
							    <option value="cellphoneNum">전화번호</option>
						  	</select>
						  	<input type="text" id="searchKeyword" class="input input-sm input-bordered w-full" placeholder="옵션 검색어" autocomplete="off" />
					  	</div>
					</label>
					
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-xs">회원 유형 선택</span>
					  	</div>
					</label>
					<div class="join grid grid-cols-3">
					  	<input class="memberType join-item btn btn-sm" type="radio" name="memberType" value="all" aria-label="전체" checked/>
					  	<input class="memberType join-item btn btn-sm" type="radio" name="memberType" value="native" aria-label="자체 회원" />
					  	<input class="memberType join-item btn btn-sm" type="radio" name="memberType" value="sns" aria-label="SNS회원" />
					</div>
					
					<label class="form-control w-full flex-row items-center justify-between">
						<div class="label">
						    <span class="label-text text-xs pr-1.5">정렬순서</span>
						  	<input id="order" type="checkbox" class="checkbox checkbox-sm" />
					  	</div>
					  	<div class="">
					  		<span class="label-text text-xs"><span class="text-red-700">*</span> 기본: 오름차순, 선택: 내림차순</span>
					  	</div>
					</label>
					
					
					<div class="absolute text-center bottom-14 w-full">
						<button class="btn btn-sm w-full" onclick="admGetMembers()">검색</button>
					</div>
				</div>
			</div>
			
			<div class="w-full h-full overflow-x-auto">
				<div class="h-full">
				  	<table class="table table-xs [width:150%] adm-member-table text-center">
					    <thead>
					      	<tr>
					        	<th>번호</th>
					        	<th>회원번호</th>
								<th>이름</th>
								<th>닉네임</th>
								<th>아이디</th>
								<th>나이</th>
								<th>전화번호</th>
								<th>이메일</th>
								<th>가입일</th>
								<th class="[width:150px] [max-width:150px]">소개</th>
								<th>마지막 로그인 일</th>
								<th>회원 유형</th>
								<th>상태</th>
					      	</tr>
				    	</thead>
				    	
				    	<!-- ajax 사용 -->
					    <tbody class="members"></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>