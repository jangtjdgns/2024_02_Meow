<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>
<script>
	let unsavedChanges = false;
	
	$(function(){
		$(".userAccount").click(function(){
			if (unsavedChanges && !confirm("변경사항이 저장되지 않을 수 있습니다. 나가시겠습니까?")) {
				return;
	      	}
			unsavedChanges = false;
			
			const accountNo = $(this).index();
			
			getUserAccountJsp(accountNo);
		})
	})
	
	function getUserAccountJsp(accountNo){
		$.ajax({
			url: '/usr/member/getUserAccountJsp', // JSP 파일의 경로
		    method: 'GET',
		    data: {
		    	memberId: ${rq.loginedMemberId},
				sectionNo: accountNo
		    },
		    dataType: 'html',
		    success: function(response) {
		    	// 서버에서 받은 응답을 화면에 표시
		    	$("#section-wrap").html(response);
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
</script>

<section id="profile-bg" class="py-12 p-mw min-h border-t" style="background: linear-gradient(#EBE8E6, #E5D7D1);">
	<div class="mx-auto max-w-6xl profile-layout">
		<div>
			<div class="bg-white w-72 rounded-3xl p-6 shadow-2xl">
				<div role="tablist" class="tabs tabs-bordered mb-4">
				  	<a href="profile?memberId=${rq.loginedMemberId }" role="tab" class="tab">프로필</a>
				  	<button role="tab" class="tab tab-active" onclick="getUserAccountJsp(-1)">계정관리</button>
				</div>
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">
						<i class="fa-solid fa-screwdriver-wrench pr-1"></i>
						<span>계정관리</span>
					</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<a class="userAccount side-btn btn btn-ghost btn-sm mx-1">계정 정보 수정</a>
						<div class="userAccount side-btn btn btn-ghost btn-sm mx-1">비밀번호 재설정</div>
						<a class="userAccount side-btn btn btn-ghost btn-sm mx-1">계정 탈퇴</a>
					</div>
				</div>
			</div>
		</div>
		
		<div id="section-wrap">
			<%@ include file="../member/userAccountDefault.jsp"%>
		</div>
	</div>
</section>
<%@ include file="../common/footer.jsp"%>