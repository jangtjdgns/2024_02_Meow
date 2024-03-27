<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
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
					        	<td>\${members[i].updateDate}</td>
					        	<td>\${members[i].lastLoginDaysDiff}일 전</td>
					        	<td class="text-left truncate [width:150px] [max-width:150px]"">\${members[i].aboutMe == null ? '' : members[i].aboutMe}</td>
					        	<td>\${members[i].snsType == null ? '자체회원' : 'SNS회원'}</td>
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
	
	
	function admGetMember(memberId) {
		$.ajax({
			url: '/adm/member/list',
		    method: 'GET',
		    data: {
		    	memberId: memberId,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	if(data.success) {
		    		console.log(data);
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			},
		});
	}
	
	$(function(){
		admGetMembers();
	})
</script>

<div class="grid grid-cols-4 grid-rows-2 p-4 gap-4 h-full">
	
	<!-- 회원 상세 정보 -->
	<div class="border-2 rounded-lg col-start-1 col-end-3">
		<!-- 여기부터 해야됨 -->
	</div>
	
	<!-- 반려묘 상세 정보 -->
	<div class="border-2 rounded-lg col-start-3 col-end-5"></div>
	
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
							<input type="number" id="page" class="input input-sm input-bordered w-1/2" value="1" min="1" placeholder="기본값 1페이지"/>
							<input type="number" id="memberCnt" class="input input-sm input-bordered w-1/2" value="10" min="1" placeholder="기본값 10명"/>
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
						  	<input type="text" id="searchKeyword" class="input input-sm input-bordered w-full" placeholder="옵션 검색어" />
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
			
			<div class="border w-full h-full overflow-x-auto">
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
								<th>수정일</th>
								<th>마지막 로그인 일</th>
								<th class="[width:150px] [max-width:150px]">소개</th>
								<th>회원 유형</th>
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