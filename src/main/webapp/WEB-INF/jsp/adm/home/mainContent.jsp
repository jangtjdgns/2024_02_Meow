<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- <script src="/js/adm/home/pieChart.js"></script> -->
<script src="/js/adm/other/calendar.js"></script>
<script>
function getNoticeArticle() {
	$.ajax({
		url: '/adm/article/notice',
	    method: 'GET',
	    dataType: 'json',
	    success: function(data) {
	    	if(data.success) {
	    		const articles = data.data;
		    	
		    	for(let i = 0; i < articles.length; i++) {
		    		const article = `
			    		<tr class="hover:bg-gray-50">
					        <th>\${i + 1}</th> 
					        <td>\${articles[i].id}</td> 
					        <td class="hover:underline text-left truncate [max-width:465px]">
					        	<a href="../../usr/article/detail?boardId=2&id=\${articles[i].id}">\${articles[i].title}</a>
					        </td> 
					        <td>\${articles[i].writerName}</td>
					        <td>\${articles[i].formattedUpdateDate}</td> 
				      	</tr>
			    	`;
			    	
		    		$(".notice-articles").append(article);
		    	}
	    	} else {
	    		$(".notice-articles").append(`
	    			<tr class="text-center">
				        <th colspan=4>\${data.msg}</th>
			      	</tr>
		    	`);
	    	}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
	});
}


// 프로필 이미지 초기화
function resetProfileImage(){
	$("#input_profile_image").val("");
	$("#imagePreview").attr("src", "");
}


// 이미지 업데이트
function doUpdateProfileImage(form) {
	event.preventDefault();	// submit 막기
	
	if(!confirm('프로필 이미지를 변경하시겠습니까?')) {
		alertMsg('프로필 이미지 변경을 취소합니다.', 'default');
		return false;
	} 
	
	let formData = new FormData(form);							// 폼 데이터 객체 생성
	formData.append('memberId', loginedMemberId)
	let imageFiles = form[0].files;								// 파일 추출
	if (imageFiles.length > 0) formData.append('profileImage', imageFiles);	// 파일이 있으면 데이터 추가
	
	$.ajax({
		url: '/adm/member/profileImage/doUpdate',
	    method: 'POST',
	    data: formData,
	    contentType: false,
	    processData: false,
	    dataType: 'json',
	    success: function(data) {
	    	alertMsg(data.msg + '<br /><span class="text-xs">* 변경후 새로고침을 진행해주세요.</span>', data.success ? 'success' : 'warning');
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
	});
}

$(function(){
	getNoticeArticle();
	
	calendar.setOptions({
		isReadOnly: true,
		useDetailPopup: false,
		month: {
	    	isAlways6Weeks: false,
	  	},
	});
	
	// 메인 아바타 업데이트 버튼 표시 토글 효과
	$(".main-avatar").on({
		mouseenter: () => {  $(this).find('.update-profile').fadeIn(200) },
	    mouseleave: () => { $(this).find('.update-profile').fadeOut(200) }
	});
	
	// 프로필 이미지 수정
	$("#input_profile_image").change(function(){
		let imageFiles = $(this)[0].files;
		if (imageFiles.length > 0) {
	        const imageURL = URL.createObjectURL(imageFiles[0]);
	        $("#imagePreview").attr("src", imageURL);
	    }
	})
})
</script>

<div class="grid grid-cols-3 grid-rows-3 p-4 gap-4 h-full">
	<div class="border-2 rounded-lg col-start-1 col-end-3 row-start-1 row-end-3 p-1 relative overflow-scroll">
		<!-- <div id="pieChart" class="w-full h-full"></div>
		<div class="absolute bottom-2 right-2 text-xs text-blue-600">* 10분마다 자동으로 갱신됨</div> -->
		<div id="calendar" class="h-full"></div>
	</div>

	<div class="border-2 rounded-lg row-start-1 row-end-3">
		<div class="card w-full h-full">
			<figure class="px-10 pt-10 pb-2">
				<div class="avatar rounded-full overflow-hidden main-avatar ring ring-offset-2">
					<div class="w-36">
						<c:if test="${rq.loginedMemberProfileImage == null}">
							<div class="w-full h-full pointer-events-none flex justify-center items-center text-center font-Jalnan text-sm">이미지 없음</div>
						</c:if>
						<c:if test="${rq.loginedMemberProfileImage != null}">
							<img src="${rq.loginedMemberProfileImage }" />
						</c:if>
						
						<div class="update-profile hidden w-full h-full absolute bottom-0 bg-black bg-opacity-20">
							<div class="h-4/5"></div>
							<div class="h-1/5 text-sm text-white text-center bg-black bg-opacity-40 font-Pretendard">
								<button class="w-full h-full pb-2" onclick="update_profile_image_modal.showModal()">프로필 수정</button>
							</div>
						</div>
					</div>
				</div>
			</figure>
			
			<div class="card-body items-center text-center">
				<h2 class="card-title">${rq.loginedMemberNickname }</h2>
				<p>정보 들어가는 곳</p>
				<div class="card-actions">
					<button class="btn btn-primary">액션 버튼</button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="border-2 rounded-lg col-start-1 col-end-3 h-full grid overflow-y-scroll" style="grid-template-rows: 45px 1fr">
		<div class="font-bold flex items-center justify-between px-3">
			<div>공지사항</div>
			<div class="hover:scale-110 cursor-pointer" style="transition: transform .2s">
				<a href="../../usr/article/list?boardId=2" target="_blank"><i class="fa-solid fa-plus"></i></a>
			</div>
		</div>
		
  		<table class="table table-sm">
    		<thead>
	      		<tr height=32>
		        	<th width=5%>번호</th>
		        	<th width=5%>글번호</th>
		        	<th width=465>제목</th>
		        	<th width=20%>작성자</th>
		        	<th width=20%>작성일</th>
		      	</tr>
    		</thead>
    		
    		<!-- ajax 사용 -->
    		<tbody class="notice-articles"></tbody>
		</table>
	</div>
	
	<div class="border-2 rounded-lg h-full grid overflow-y-scroll" style="grid-template-rows: 45px 1fr">
		<div class="font-bold flex items-center justify-between px-3">
			<div>쪽지</div>
			<div><i class="fa-solid fa-plus"></i></div>
		</div>
		
  		<table class="table table-sm">
    		<thead>
	      		<tr height=32>
		        	<th width=5%>번호</th> 
		        	<th width=250>제목</th> 
		        	<th width=20%>작성자</th> 
		      	</tr>
    		</thead>
    		<tbody>
		      	<tr class="hover:bg-gray-50">
			        <th>1</th>
			        <td class="hover:underline text-left truncate [max-width:250px]"><a href="">1번 입니다.</a></td> 
			        <td>관리자</td>
		      	</tr>
		      	<tr class="hover:bg-gray-50">
			        <th>2</th> 
			        <td class="hover:underline text-left truncate"><a href="">2번 입니다.</a></td> 
			        <td>관리자2</td> 
		      	</tr>
		      	<tr class="hover:bg-gray-50">
			        <th>3</th> 
			        <td class="hover:underline text-left truncate"><a href="">3번 입니다.</a></td> 
			        <td>관리자3</td> 
		      	</tr>
		      	<tr class="hover:bg-gray-50">
			        <th>4</th> 
			        <td class="hover:underline text-left truncate"><a href="">4번 입니다.</a></td> 
			        <td>관리자4</td> 
		      	</tr>
		      	<tr class="hover:bg-gray-50">
			        <th>5</th> 
			        <td class="hover:underline text-left truncate"><a href="">공지 5번 입니다.</a></td> 
			        <td>관리자5</td> 
		      	</tr>
			</tbody>
		</table>
	</div>
</div>

<!-- 이미지 수정 모달 -->
<dialog id="update_profile_image_modal" class="modal">
		<div class="modal-box">
			<form method="dialog">
				<button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
			</form>
			<h3 class="font-bold text-lg">프로필 이미지 변경</h3>
			<p class="text-sm">* 이미지 변경 후 <u class="text-red-600">새로고침</u>을 진행해주세요.</p>
			
			<div class="text-center">
				<div class="avatar rounded-full overflow-hidden main-avatar ring ring-offset-2 my-8">
					<div class="w-36">
						<img id="imagePreview" src="${rq.loginedMemberProfileImage }" />
					</div>
				</div>
			</div>
			
			<form onsubmit="doUpdateProfileImage(this)" enctype="multipart/form-data">
				<div class="flex items-center gap-2">
					<input type="file" id="input_profile_image" name="profileImage" class="file-input file-input-sm file-input-bordered w-full" accept="image/gif, image/jpeg, image/png" autocomplete="off" />
					<button type="button" class="btn btn-circle btn-sm" onclick="resetProfileImage()"><i class="fa-solid fa-rotate-right"></i></button>
				</div>
				<div class="text-right mt-4">
					<button class="btn btn-sm">변경</button>
				</div>
			</form>
		</div>
</dialog>