<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Meow</title>
	<link rel="icon" href="/images/favicon/cat-pow.ico" type="image/x-icon">
	<%@ include file="../common/head.jsp"%>
	<script>
		const loginedMemberId = "${rq.loginedMemberId}";
		let submitType = 0;
		$(function(){
			const headerHeight = $(".h-mh").css("height");
			$('.b-mh').css('--header-height', headerHeight);	// body 부분 최소 height 지정
			
			bindFormInputEvent($(".customer-title").eq(0), "input-error");
			bindFormInputEvent($(".customer-body").eq(0), "textarea-error");
		})
		
		function submitRequest(sbType) {
			submitType = sbType;
			// type
			// 0 == modal
			// 1 == page
		    const type = $(".customer-type").eq(submitType).val();
		    const title = $(".customer-title").eq(submitType).val().trim();
		    let body = $(".customer-body").eq(submitType).val();
		    const imagePath = $(".customer-image").eq(submitType).val();

		    if (title.length == 0) {
		        alertMsg("접수하실 제목을 입력해주세요.", "warning");
		        $(".customer-title").eq(submitType).addClass("input-error");
		        return $(".customer-title").eq(submitType).focus();
		    }

		    if (body.trim().length == 0) {
		        alertMsg("접수하실 내용을 입력해주세요.", "warning");
		        $(".customer-body").eq(submitType).addClass("textarea-error");
		        return $(".customer-body").eq(submitType).focus();
		    }

		    $.ajax({
		        url: '../customer/submitRequest',
		        method: 'POST',
		        data: {
		            memberId: loginedMemberId,
		            type: type,
		            title: title,
		            body: body,
		            imagePath: imagePath,
		        },
		        dataType: 'json',
		        success: function (data) {
		            $(".customer-title").eq(submitType).val("");
		            $(".customer-body").eq(submitType).val("");
		            if (data.success) {
		                let msg = `접수번호: \${data.data}번\n`
		                    + `제목: \${title}\n`
		                    + '접수 되었습니다.';
		                alert(msg);
		                
		                if(submitType == 0) {
			                $("#my_modal_3")[0].close();		                	
		                }
		            }
		        },
		        error: function (xhr, status, error) {
		            console.error('Ajax error:', status, error);
		        }
		    });
		}
	</script>
</head>

<body>
<!-- alert -->
<div id="alert" class="fixed top-0 left-1/2 transform -translate-x-1/2 [z-index:1000]"></div>

<!-- 모달 컨테이너 -->
<div id="modal-container">
	<!-- 문의 관련 모달창 -->
	<dialog id="my_modal_3" class="modal">
	  	<div class="modal-box">
	    	<form method="dialog">
	      		<button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
	    	</form>
	    	<h3 class="font-bold text-lg">고객센터</h3>
	    	<p class="py-4 text-sm">문의, 버그 제보 등 다양한 의견들을 자유롭게 남겨주세요.</p>
	    	
	    	<div class="py-2">
		    	<select class="customer-type select select-sm select-bordered">
		    		<option value="inquiry">문의</option>
		    		<option value="bug">버그 제보</option>
		    		<option value="suggestion">기타 건의 사항</option>
		    	</select>
	    	</div>
	    	
	    	<div class="py-2">
	    		<label class="label" for="customer-image">
	    			<span class="label-text">이미지 업로드</span>
	    		</label>
		    	<input type="file" class="customer-image file-input file-input-sm file-input-bordered w-56" accept="image/gif, image/jpeg, image/png" />
	    	</div>
	    	
	    	<div class="py-2">
	    		<label class="label" for="customer-title">
	    			<span class="label-text"><span class="text-red-700">*</span>제목</span>
	    		</label>
		    	<input id="customer-title" class="customer-title input input-sm input-bordered w-full" type="text" placeholder="2 ~ 50 글자 입력이 가능합니다." type="text" minlength="2" maxlength="50" />
	    	</div>
	    	
	    	<div class="py-2">
		    	<label class="label" for="customer-body">
		    		<span class="label-text"><span class="text-red-700">*</span>내용</span>
		    	</label>
		    	<textarea id="customer-body" class="customer-body textarea textarea-bordered resize-none w-full" placeholder="문의하실 내용을 입력해주세요."></textarea>
		    </div>
		    
		    <div class="py-2 text-right">
		    	<button class="btn" onclick="submitRequest(0);">접수</button>
		    </div>
	  	</div> 
	</dialog>
	
	<!-- 신고 관련 모달창 -->
	<dialog id="report_modal" class="modal">
	  	<div class="modal-box">
	    	<form method="dialog">
	      		<button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
	    	</form>
	    	<h3 class="font-bold text-lg">신고</h3>
	    	<p class="py-4 text-sm">신고를 원하는 회원, 게시물 등의 번호를 입력해주세요.</p>
	    	
	    	<div class="py-2 grid grid-cols-3 gap-4">
	    		<div>
		    		<label class="label" for="relTypeCode">
		    			<span class="label-text"><span class="text-red-700">*</span>관련 항목 유형</span>
		    		</label>
		    		<select id="relTypeCode" class="select select-sm select-bordered w-full">
			    		<option value="none" selected>선택</option>
			    		<option value="member">회원</option>
			    		<option value="article">게시물</option>
			    		<option value="reply">댓글</option>
			    	</select>
		    	</div>
		    	
		    	<div>
		    		<label class="label" for="relId">
		    			<span class="label-text"><span class="text-red-700">*</span>관련 항목 번호</span>
		    			<div class="label-text dropdown dropdown-hover dropdown-end h-5">
							<div tabindex="0" role="button" class="btn btn-circle btn-ghost btn-xs text-info [width:1.25rem] [min-height:1.25rem] [height:1.25rem]">
								<svg tabindex="0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="w-4 h-4 stroke-current">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
								</svg>
							</div>
							<div tabindex="0" class="card compact dropdown-content z-[1] shadow bg-base-100 rounded-box w-40">
								<div tabindex="0" class="card-body text-center">
									<p><strong>회원</strong>의 경우 닉네임<br /> 입력이 가능합니다.</p>
								</div>
							</div>
						</div>
		    		</label>
		    		<input id="relId" type="text" class="input input-sm input-bordered w-full" placeholder="번호를 입력해주세요." />
		    	</div>
		    	
	    		<div>
		    		<label class="label" for="reportType">
		    			<span class="label-text"><span class="text-red-700">*</span>신고 유형</span>
		    		</label>
		    		<select id="reportType" class="select select-sm select-bordered w-full">
			    		<option value="0" selected>선택</option>
			    		<option value="1">스팸</option>
			    		<option value="2">욕설 또는 비방</option>
			    		<option value="3">성적인 콘텐츠</option>
			    		<option value="4">저작권 침해</option>
			    		<option value="5">사기 또는 부정행위</option>
			    		<option value="6">기타</option>
			    	</select>
		    	</div>
	    	</div>
	    	
	    	<div class="py-2">
		    	<label class="label" for="report-body">
		    		<span class="label-text"><span class="text-red-700">*</span>내용</span>
		    	</label>
		    	<textarea id="report-body" class="textarea textarea-bordered resize-none w-full" placeholder="신고 내용을 입력해주세요. (2글자 이상)" minLength="2"></textarea>
		    </div>
		    
		    <div class="py-2 text-right">
		    	<button class="btn" onclick="doReport();">신고</button>
		    </div>
	  	</div> 
	</dialog>
</div>


<section class="h-mh mw flex justify-around">
	<div class="self-end">
		<a href="/"><img src="/images/Meow-logo.png" class="w-24 jello-horizontal" /></a>
	</div>
	
	<div class="flex flex-col items-end justify-around h-h w-1/2">
		<div>
			<c:if test="${rq.loginedMemberId == 0 }">
				<div class="w-full flex justify-end">
					<a href="../member/login" class="btn btn-ghost btn-xs h-8">로그인</a>
					<a href="../member/join" class="btn btn-ghost btn-xs h-8">회원가입</a>		
				</div>
			</c:if>
			
			<c:if test="${rq.loginedMemberId != 0 }">
				<script>
					$(function() {
						checkRequests(${rq.loginedMemberId});
					})
				</script>
				
				<div class="w-full flex items-center justify-end">
					<div class="dropdown dropdown-start">
						<div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
							<div class="w-10 rounded-full">
								<c:if test="${rq.loginedMemberProfileImage != null}">
									<img src="${rq.loginedMemberProfileImage }" />
								</c:if>
								<c:if test="${rq.loginedMemberProfileImage == null}">
									<div class="border w-full h-full rounded-full flex items-center justify-center">${rq.loginedMemberNickname }</div>
								</c:if>
							</div>
						</div>
						<ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-30 p-2 shadow bg-base-100 rounded-box w-32">
							<li class="font-bold"><a>${rq.loginedMemberNickname }</a></li>
							<c:if test="${rq.authLevel == 1}">
								<!-- 유저 -->
								<li><a href="../member/profile?memberId=${rq.loginedMemberId }">프로필</a></li>
								<li><a>계정관리</a></li>
								<li><button onclick="my_modal_3.showModal()">문의</button></li>
								<li><button onclick="showReportModal('none', 0, 0)">신고</button></li>
							</c:if>
							<c:if test="${rq.authLevel == 0}">
								<!-- 관리자 -->
								<li><a href="/adm">관리자 페이지</a></li>
							</c:if>
							<li><a href="../member/doLogout" onclick="if(!confirm('로그아웃 하시겠습니까?')) return false;">로그아웃</a></li>
						</ul>
					</div>
					
					<div class="z-10">
						<div class="dropdown dropdown-bottom dropdown-end">
							<button tabindex="0" role="button" class="btn btn-ghost btn-circle m-1">
								<div class="indicator text-lg">
									<i class="fa-regular fa-bell p-1 wobble-hor-top"></i>
									<span id="notification-count" class="badge badge-xs badge-primary indicator-item hidden"></span>
								</div>
							</button>
						  	<div tabindex="0" id="notification" class="dropdown-content z-[1] p-2 menu shadow bg-base-100 rounded-box w-56">
						  		
						  	</div>
						</div>					
					</div>
				</div>
			</c:if>
		</div>
		
		<div class="menu-box">
			<ul class="w-full h-full bg-white text-center">
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="/">메인</a>
				</li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="../companionCat/view?memberId=${rq.loginedMemberId }">반려묘</a>
					<ul>
						<li><a href="../companionCat/view?memberId=${rq.loginedMemberId }">내반려묘</a></li>
						<li><a href="../companionCat/register">등록</a></li>
					</ul>
				</li>
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="../article/list">게시판</a>
					<ul>
						<li><a href="../article/list?boardId=2">공지사항</a></li>
						<li><a href="../article/write">글작성</a></li>
					</ul>
				</li>
				<!-- <li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line"><a href="">지도</a></li> -->
				<li class="nav-btn nav-btn-primary nav-btn-ghost nav-btn-open-line">
					<a href="../customer/main">고객센터</a>
					<ul>
						<li><a href="">문의</a></li>
						<li><a href="">내역</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
</section>
