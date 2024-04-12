<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
	// 문의 접수 목록 가져오기
	function admGetInquiries() {
		const page = $('#page').val().trim();
		const inquiryCnt = $('#inquiryCnt').val().trim();
		const status = $('.status[name="status"]:checked').val();
		const inquiryType = $('.inquiryType[name="inquiryType"]:checked').val();
		const order = $('#order').prop("checked");
		
		$.ajax({
			url: '/adm/inquiry/list',
		    method: 'GET',
		    data: {
		    	page: page,
		    	inquiryCnt: inquiryCnt,
		    	status: status,
		    	inquiryType: inquiryType,
		    	order: order,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	console.log(data)
		    	$(".inquiries").empty();
		    	if(data.success) {
		    		const inquiries = data.data;
		    		
		    		for(let i = 0; i < inquiries.length; i++) {
		    			
		    			// 접수일, 처리일 구분
		    			const formattedDate = getFormattedDateStatus(inquiries[i]);
		    			$(".date").text(formattedDate.status);
		    			
		    			const inquiry = `
		    				<tr class="hover:bg-gray-50 cursor-pointer" onclick="getInquiry(\${inquiries[i].id})">
		    					<td>\${inquiries[i].id}</td>
		    					<td class="text-left truncate [width:120px] [max-width:120px]">\${inquiries[i].title}</td>
		    					<td>\${inquiries[i].nickname}</td>
		    					<td>\${inquiries[i].type}</td>
		    					<td>\${formattedDate.setDate.substring(0, 11)}</td>
		    					<td>\${inquiries[i].status}</td>
					      	</tr>
		    			`;
		    			
		    			$(".inquiries").append(inquiry);
		    		} 
		    	} else {
		    		$(".inquiries").append(`
		    			<tr>
			    			<td colspan=7>\${data.msg}</td>
			    		</tr>
		    		`);
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
	
	
	// 문의 가져오기
	function getInquiry(inquiryId) {
		$.ajax({
			url: '/adm/inquiry/detail',
		    method: 'GET',
		    data: {
		    	inquiryId: inquiryId
		    },
		    dataType: 'json',
		    success: function(data) {
		    	
		    	if(data.success) {
		    		const inquiryInfo = data.data;
		    		console.log(inquiryInfo)
		    		const formattedDate = getFormattedDateStatus(inquiryInfo);
		    		
		    		let answerBody = null;
		    		// 문의에 대한 처리를 진행했는지 확인
		    		if(inquiryInfo.answerBody !== null) {
		    			answerBody = `
		    				<div class="absolute top-0 left-0 w-full h-full z-20 bg-gray-100 opacity-80"></div>
		    			`;
		    		}
		    		
		    		const inquiry = `
		    			<input id="memberId" type="hidden" value="\${inquiryInfo.memberId}" />
		    			<div class="grid grid-rows-4 h-full">
		    				<div class="row-start-1 row-end-4 overflow-auto border-b-2">
			    				<table class="table h-full">
				        			<tbody>
					        			<tr>
					        				<th class="w-1/5 bg-gray-50">접수번호</th>
					        				<td id="receiptId" class="w-1/5">\${inquiryInfo.id}</td>
					        			</tr>
					        			<tr>
					        				<th class="w-1/5 bg-gray-50">닉네임</th>
					        				<td id="nickname" class="w-1/5">\${inquiryInfo.nickname}</td>
					        			</tr>
					        			<tr>
					        				<th class="w-1/5 bg-gray-50">\${formattedDate.status}</th>
					        				<td>\${formattedDate.setDate}</td>
					        			</tr>
					        			<tr>
					        				<th class="w-1/5 bg-gray-50">제목</th>
					        				<td id="title" class="w-4/5">\${inquiryInfo.title}</td>
					        			</tr>
					        			<tr>
					        				<th class="w-1/5 bg-gray-50 align-top">내용</th>
					        				<td class="w-4/5 h-52">
					        					<textarea id="body" class="focus:outline-none w-full h-full resize-none" readonly>\${inquiryInfo.body}</textarea>
					        				</td>
					        			</tr>
					        			<tr>
					        				<th class="w-1/5 bg-gray-50">처리내역</th>
					        				<td id="status" class="w-4/5">\${inquiryInfo.status}</td>
					        			</tr>
					        			<tr>
					        				<th class="w-1/5 bg-gray-50">이미지</th>
					        				<td id="image" class="w-4/5">등록된 이미지가 없습니다. (처리해야됨)</td>
					        			</tr>
					    	    	</tbody>
				    	    	</table>
		    				</div>
		    				
		    				<div class="textarea p-0 relative row-start-4 row-end-5">
		    					\${answerBody}
		    					
		    					<div class="absolute top-0 z-10 border-b px-2 w-full bg-white h-8">
		    						<div class="font-bold">답변하기</div>
		    					</div>
		    					
				            	<textarea class="answerBody absolute top-0 left-0 w-full h-full textarea resize-none py-8 focus:outline-none focus:border-0">\${inquiryInfo.answerBody == null ? '' : inquiryInfo.answerBody}</textarea>
				            	
				            	<div class="absolute bottom-0 z-10 border-t w-full bg-white flex justify-between h-8">
				            		<div class="flex h-full items-center px-2">
					            		<div class="dropdown dropdown-hover dropdown-top">
											<div tabindex="0" role="button" class="btn btn-circle btn-ghost btn-xs text-info">
												<i class="fa-solid fa-flag" style="color: #ff0000;"></i>
											</div>
											<div tabindex="0" class="card compact dropdown-content z-[1] shadow bg-base-100 rounded-box w-40">
												<div tabindex="0" class="card-body">
													<p class="text-sm text-center">부적절한 문의 처리</p>
												</div>
											</div>
										</div>
					            		<select class="reportProcessing select select-xs focus:outline-none focus:border-0">
					            			<option value="0" selected>선택</option>
					            			<option value="1">경고</option>
					            			<option value="2">정지</option>
					            			<option value="3">강제탈퇴</option>
					            		</select>
				            		</div>
				            		<div>
						            	<button class="btn btn-sm btn-outline rounded-none border-0" onclick="answerInquiry()">답변하기</button>
					            	</div>
				            	</div>
				            </div>
		    			</div>
		    		`;
		    		
		    		$(".inquiry").html(inquiry);
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
	
	
	// 답변하기
	function answerInquiry() {
		
		if(!confirm("답변하시겠습니까?")) return false;
		
		const id = $("#receiptId").text();
		const answerBody = $(".answerBody").val();
		const processing = $(".processing").val();
		const memberId = $("#memberId").val();
		
		if(answerBody.trim().length < 2) {
			return alertMsg("답변하실 내용을 입력해주세요.<br />(두 글자 이상)", "warning");
		}
		
		
		$.ajax({
			url: '/adm/inquiry/answer',
		    method: 'GET',
		    data: {
		    	inquiryId: id,
		    	recipientId: memberId,
		    	answerBody: answerBody,
		    	processing: processing,
		    	
		    },
		    dataType: 'json',
		    success: function(data) {
		    	alertMsg("답변이 완료 되었습니다.", "success");
		    	admGetInquiries();
				getInquiry(id);
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
	
	
	// 입력된 문의 상태에 따라 접수일 or 처리일 반환 (날짜, 글자)
	function getFormattedDateStatus(inquiry) {
	    const setDate = inquiry.status === '처리중' ? inquiry.regDate : inquiry.updateDate;
	    const status = inquiry.status === '처리중' ? '접수일' : '처리일';
	    return { setDate, status };
	}
	
	
	$(function(){
		admGetInquiries();
		//getInquiry(43);	// 테스트 때문에 추가 지워야됨
		
		// 문의 상태 라디오 버튼 변경 시
		$('.status').change(function(){
			// disabled 속성 토글
			$("#page, #inquiryCnt").prop("disabled", function(i, val) {
	            return !val;
	        });
			
			$("#page").val(1);
			$("#inquiryCnt").val(15);
		})
	})
</script>

<div class="grid grid-cols-5 p-4 gap-4 h-full">
	
	<!-- 문의 접수 목록 -->
	<div class="col-start-1 col-end-3 overflow-auto border-2 rounded-lg">
		<div class="grid gap-2 py-2 h-full" style="grid-template-rows: 1fr 256px">
			<div class="w-full overflow-auto border-b-2">
			  	<table class="table table-xs text-center">
				    <thead>
				      	<tr>
				        	<th>문의 번호</th>
							<th class="[width:120px] [max-width:120px]">제목</th>
							<th>작성자</th>
							<th>타입</th>
							<th class="date">접수일</th>
							<th>처리상태</th>
				      	</tr>
			    	</thead>
			    	
			    	<!-- ajax 사용 -->
				    <tbody class="inquiries"></tbody>
				</table>
			</div>
			
			<!-- 검색 옵션 -->
			<div class="px-2 w-96 mx-auto">
				<div class="w-full text-xl text-center font-LINESeed p-2">문의 접수 검색 옵션</div>
				
				<div>
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-left text-xs">페이지</span>
						    <span class="label-text text-right text-xs ">표시되는 접수 개수
							    <div class="dropdown dropdown-hover dropdown-end">
									<div tabindex="0" role="button" class="btn btn-circle btn-ghost btn-xs text-info">
										<svg tabindex="0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="w-4 h-4 stroke-current">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
										</svg>
									</div>
									<div tabindex="0" class="card compact dropdown-content z-[1] shadow bg-base-100 rounded-box w-40">
										<div tabindex="0" class="card-body text-left">
											<p class="text-sm"><strong>처리중</strong> 상태</p>
											<p class="text-xs">- 페이지, 표시되는 접수 개수 옵션 사용이 불가능합니다.</p>
										</div>
									</div>
								</div>
						    </span>
					  	</div>
					  	<div class="join">
							<input type="number" id="page" class="input input-sm input-bordered w-4/12 join-item" value="1" min="1" placeholder="기본값 1페이지" disabled autocomplete="off" />
							<input type="radio" name="status" class="status btn btn-sm w-2/12 text-xs join-item" value="progress" aria-label="처리중" checked autocomplete="off" />
							<input type="radio" name="status" class="status btn btn-sm w-2/12 text-xs join-item" value="complete" aria-label="완료" autocomplete="off" />
							<input type="number" id="inquiryCnt" class="input input-sm input-bordered w-4/12 join-item" value="15" min="1" placeholder="기본값 15개" disabled autocomplete="off" />
						</div>
					</label>
					
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-xs">문의 종류 선택</span>
					  	</div>
					</label>
					<div class="join grid grid-cols-4">
					  	<input class="inquiryType join-item btn btn-sm text-xs" type="radio" name="inquiryType" value="1" aria-label="전체" checked autocomplete="off" />
					  	<input class="inquiryType join-item btn btn-sm text-xs" type="radio" name="inquiryType" value="2" aria-label="문의" autocomplete="off" />
					  	<input class="inquiryType join-item btn btn-sm text-xs" type="radio" name="inquiryType" value="3" aria-label="버그제보" autocomplete="off" />
					  	<input class="inquiryType join-item btn btn-sm text-xs" type="radio" name="inquiryType" value="4" aria-label="기타" autocomplete="off" />
					</div>
					
					<label class="form-control w-full flex-row items-center justify-between">
						<div class="label">
						    <span class="label-text text-xs pr-1.5">정렬순서</span>
						  	<input id="order" type="checkbox" class="checkbox checkbox-sm" autocomplete="off" />
					  	</div>
					  	<div class="">
					  		<span class="label-text text-xs"><span class="text-red-700">*</span> 기본: 내림차순, 선택: 오름차순</span>
					  	</div>
					</label>
					
					
					<div class="mt-2 mx-auto">
						<button class="btn btn-sm w-full" onclick="admGetInquiries()">검색</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 문의 정보 -->
	<div class="inquiry col-start-3 col-end-6 overflow-auto border-2 rounded-lg">
		<div class="w-full h-full flex items-center justify-center text-lg">처리하실 문의를 선택해주세요.</div>
	</div>
	
</div>