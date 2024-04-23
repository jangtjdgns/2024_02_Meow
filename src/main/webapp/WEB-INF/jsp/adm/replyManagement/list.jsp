<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	// 댓글 목록 가져오기
	function admGetReplies() {
		const page = $('#page').val().trim();
		const replyCnt = $('#replyCnt').val().trim();
		const searchType = $('#searchType').val().trim();
		const searchKeyword = $('#searchKeyword').val().trim();
		const order = $('#order').prop("checked");
		
		$.ajax({
			url: '/adm/reply/list',
		    method: 'GET',
		    data: {
		    	page: page,
		    	replyCnt: replyCnt,
		    	searchType: searchType,
		    	searchKeyword: searchKeyword,
		    	order: order
		    },
		    dataType: 'json',
		    success: function(data) {
		    	
		    	$(".replies").empty();
		    	if(data.success) {
		    		const replies = data.data;
		    		
		    		for(let i = 0; i < replies.length; i++) {
		    			const reply = `
		    				<tr class="hover:bg-gray-50 cursor-pointer" onclick="admGetReply(\${replies[i].id})">
					        	<td class="font-bold">\${i + 1}</td>
					        	<td>\${replies[i].id}</td>
					        	<td>\${replies[i].relId}</td>
					        	<td>
					        		\${replies[i].writerName}
					        		<span class="badge badge-ghost badge-sm">\${replies[i].memberId}</span>
					        	</td>
					        	<td>\${replies[i].regDate}</td>
					        	<td>\${replies[i].updateDate == null ? '-' : replies[i].updateDate}</td>
					      	</tr>
		    			`;
		    			
		    			$(".replies").append(reply);
		    		} 
		    	} else {
		    		$(".replies").append(`
		    			<tr>
			    			<td colspan=7>\${data.msg}</td>
			    		</tr>
		    		`);
		    		
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			},
		});
	}
	
	// 댓글 정보 가져오기
	function admGetReply(replyId) {
		console.log(replyId)
		$.ajax({
			url: '/adm/reply/detail',
		    method: 'GET',
		    data: {
		    	replyId: replyId,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	
		    	$(".reply").empty();
		    	
		    	if(data.success) {
		    		const replyInfo = data.data;
		    		setReply(replyInfo);
		    		getArticleFreq(replyInfo.memberId);
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			},
		});
	}
	
	// 댓글 정보 표시 함수
	function setReply(replyInfo) {
		
		const boardId = replyInfo.boardId;
		let boardName = null;
		switch(boardId) {
			case 2: boardName = '공지사항'; break;
			case 3: boardName = '자유'; break;
			case 4: boardName = '반려묘'; break;
			case 5: boardName = '거래'; break;
			case 6: boardName = '모임'; break;
		}
		
		const reply = `
			<div class="flex flex-col h-full p-2 gap-2 overflow-auto">
				<div class="flex h-40 gap-2">
    				<div class="avatar">
    				  	<div class="w-40 rounded">
    				  		<img src="\${replyInfo.profileImage != null ? replyInfo.profileImage : ''}" alt="이미지 없음" class="flex justify-center items-center border-2" />
    				  	</div>
    				</div>
    				
					<div class="w-full border grid grid-rows-4 text-center">
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">번호</div>
							<div class="col-start-2 col-end-5 flex items-center justify-center">\${replyInfo.id}</div>
							<div class="col-start-5 col-end-6 flex items-center justify-center font-bold bg-gray-100">닉네임</div> 
							<div class="col-start-6 col-end-10 flex items-center justify-center">\${replyInfo.writerName}</div>
						</div>
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">작성일</div>
							<div class="col-start-2 col-end-10 flex items-center justify-center">\${replyInfo.regDate}</div>
						</div>
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">수정일</div>
							<div class="col-start-2 col-end-10 flex items-center justify-center">\${replyInfo.updateDate == null ? '-' : replyInfo.updateDate}</div>
						</div>
						<div class="grid grid-cols-9 text-sm border-b">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">게시글</div>
							<div class="col-start-2 col-end-8 flex items-center justify-center">\${replyInfo.relId} (\${boardName})</div>
							<div class="col-start-8 col-end-10 flex items-center justify-center font-bold bg-gray-100 btn btn-sm btn-ghost h-full rounded-none">
								<a href="../../usr/article/detail?boardId=\${boardId}&id=\${replyInfo.relId}" target="_blank">바로가기</a>
							</div>
						</div>
					</div>
				</div>
				
				<div class="grid grid-cols-1 h-full">
					<div class="grid text-center h-full border">
						<div class="grid grid-cols-9 text-sm">
							<div class="col-start-1 col-end-2 flex items-center justify-center font-bold bg-gray-100">댓글<br />내용</div>
							<div class="col-start-2 col-end-10 flex items-center justify-center">
								<textarea class="resize-none textarea w-full h-full focus:outline-none focus:border-0" placeholder="댓글 표시란" readonly>\${replyInfo.body}</textarea>
							</div>
						</div>
					</div>
				</div>
			</div>
		`;
		
		$(".reply").append(reply);
	}
	
	
	// 차트 표시
	function getArticleFreq(memberId) {
		
		// 댓글 선택 했는지 확인
		if($(".chart-default-msg").has(".hidden").length == 0) {
			$(".chart-default-msg").addClass("hidden");
			$(".chart-radio").removeClass("hidden");
		}
		
		// 차트 데이터
		const columnChartData = {
		    categories: [],
		    series: [
		       	{
		            name: '',
		            data: []
		        },
		    ]
		}
		
		// 차트 옵션
		const options = {
			chart: {title: ''},
		};
		
		
		// 차트 표시
		showWriteReplyFreq(columnChartData, options, memberId);
	}
	
	
	// 해당 회원의 댓글 작성 빈도 차트 표시
	function showWriteReplyFreq(columnChartData, options, memberId) {
		$.ajax({
			url: '/adm/reply/showWriteFreq',
		    method: 'GET',
		    data: {
		    	memberId: memberId,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	
		    	if(data.success) {
		    		const replyStatus = data.data;
		    		
		    		options.chart.title = data.msg;
		    		for(let i = 0; i < replyStatus.length; i++) {
		    			columnChartData.categories.push(replyStatus[i].date);
		    			columnChartData.series[0].data.push(replyStatus[i].replyCnt);
		    		}
		    		
		    		
		    	}
		    	
		    	// 차트 추가
		    	$(".chart-item").eq(0).empty();
				const columnChart = document.querySelectorAll('.chart-item')[0];
				new toastui.Chart.columnChart({ el: columnChart, data: columnChartData, options: options });
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			},
		});
	}
	
	
	$(function(){
		admGetReplies();
	})
</script>


<div class="grid grid-cols-4 grid-rows-2 p-4 gap-4 h-full">

	<!-- 댓글 상세 정보 -->
	<div class="border-2 rounded-lg col-start-1 col-end-3 reply">
		<div class="w-full h-full flex items-center justify-center text-lg">정보 확인을 원하는 댓글을 선택해주세요.</div>
	</div>

	<!-- 게시글 작성 빈도 차트 -->
	<div class="border-2 rounded-lg col-start-3 col-end-5 relative overflow-hidden">
		<div class="chart-default-msg w-full h-full flex items-center justify-center text-lg row-start-1 row-end-3">댓글을 선택해주세요.</div>
		
		<!-- 설명 -->
		<div class="absolute bottom-2 left-2 z-50">
			<div class="dropdown dropdown-top">
				<div tabindex="0" role="button" class="btn btn-circle btn-ghost btn-xs text-info">
					<svg tabindex="0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="w-4 h-4 stroke-current">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
					</svg>
				</div>
				<div tabindex="0" class="card compact dropdown-content z-[1] shadow bg-base-100 rounded-box w-40">
					<div tabindex="0" class="card-body">
						<p class="break-all">- 금일 날짜 기준 3개월 내에 작성했던 댓글들의 수를 표시합니다.</p>
						<p class="break-all">- 최대 6개의 막대까지만 표시됩니다.</p>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 차트 컨테이너 -->
		<div id="chartContainer" class="w-full h-full mx-auto">
			<div class="carousel w-full h-full">
				<!-- 열 차트 -->
				<div class="carousel-item w-full chart-item columnChart" style="grid-template-columns: 14rem 1fr;"></div>
		    	<div class="carousel-item w-full h-full chart-item" style="grid-template-columns: 14rem 1fr;">
		    		<div class="w-full h-full flex items-center justify-center">캐러셀을 추가하여 사용해도 좋을듯</div>
		    	</div>
			</div>
		</div>
		
		<!-- 컨테이너 아이템 -->
		<div class="absolute left-1/2 -translate-x-1/2 bottom-2 hidden chart-radio">
			<input class="carouselRadio radio radio-xs radio-info" type="radio" name="options" />
			<input class="carouselRadio radio radio-xs radio-info" type="radio" name="options" />
		</div>
	</div>

	<!-- 댓글 목록 -->
	<div class="border-2 rounded-lg col-start-1 col-end-5">
		<div class="flex gap-2 p-2 w-full h-full">
			<div class="w-96 h-full shadow px-2">
				<div class="w-full text-xl text-center font-LINESeed p-2">댓글 검색 옵션</div>

				<div class="relative h-full">
					<label class="form-control w-full">
						<div class="label">
							<span class="label-text text-xs">페이지</span> <span class="label-text text-xs">표시되는 댓글 수</span>
						</div>
						<div class="flex gap-2">
							<input type="number" id="page" class="input input-sm input-bordered w-1/2" value="1" min="1" placeholder="기본값 1페이지" autocomplete="off" />
							<input type="number" id="replyCnt" class="input input-sm input-bordered w-1/2" value="10" min="1" placeholder="기본값 10개" autocomplete="off" />
						</div>
					</label> <label class="form-control w-full">
						<div class="label">
							<span class="label-text text-xs">검색 옵션 선택</span>
						</div>
						<div class="flex gap-2">
							<select id="searchType" class="select select-sm select-bordered">
								<option value="all" selected>전체</option>
								<option value="replyId">댓글 번호</option>
								<option value="memberId">회원 번호</option>
								<option value="articleId">게시글 번호</option>
								<option value="nickname">회원 닉네임</option>
							</select> <input type="text" id="searchKeyword" class="input input-sm input-bordered w-full" placeholder="옵션 검색어" autocomplete="off" />
						</div>
					</label>

					<!-- replyType(relType 유무) 현재 추가는 안했지만 추가 가능성 있음
					
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-xs">회원 유형 선택</span>
					  	</div>
					</label>
					
					<div class="join grid grid-cols-3">
					  	<input class="replyType join-item btn btn-sm" type="radio" name="memberType" value="" aria-label="" checked autocomplete="off" />
					  	<input class="replyType join-item btn btn-sm" type="radio" name="memberType" value="" aria-label="" autocomplete="off" />
					</div>
					-->

					<label
						class="form-control w-full flex-row items-center justify-between">
						<div class="label">
							<span class="label-text text-xs pr-1.5">정렬순서</span> <input id="order" type="checkbox" class="checkbox checkbox-sm" />
						</div>
						<div class="">
							<span class="label-text text-xs"><span class="text-red-700">*</span> 기본: 내림차순, 선택: 오름차순</span>
						</div>
					</label>


					<div class="absolute text-center bottom-14 w-full">
						<button class="btn btn-sm w-full" onclick="admGetReplies()">검색</button>
					</div>
				</div>
			</div>

			<div class="w-full h-full overflow-x-auto">
				<div class="h-full">
					<table
						class="table table-xs adm-member-table text-center">
						<thead>
							<tr>
								<th>번호</th>
								<th>댓글번호</th>
								<th>게시글 번호</th>
								<th>작성자 (회원번호)</th>
								<th>작성일</th>
								<th>수정일</th>
							</tr>
						</thead>

						<!-- ajax 사용 -->
						<tbody class="replies"></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>