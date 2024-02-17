<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>
<script>
	$(function(){
		const today = new Date().toISOString().substring(0,10);
		$('#birthDate').val(today);
		$('#birthDate').attr("max", today);
	})

	const registerFormOnSubmit = function(form){
		form.name.value = form.name.value.trim();
		form.gender.value = form.gender.value.trim();
		
		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요');
			form.name.focus();
			return;
		}
		
		if (form.gender.value.length == 0) {
			alert('성별을 선택해주세요');
			form.gender.focus();
			return;
		}
		
		form.submit();
	}
</script>

<section id="profile-bg" class="py-12 p-mw min-h border-t" style="background: linear-gradient(#EBE8E6, #E5D7D1);">
	<div class="mx-auto max-w-6xl profile-layout">
		<div>
			<div id="profile-side" class="bg-white w-72 rounded-3xl px-6 pt-8 pb-4 shadow-2xl">
				<div class="text-sm font-bold border-b-2">
					<i class="fa-solid fa-cat pr-1"></i>
					<span>반려묘 등록</span>
				</div>
				<div class="side-btn-wrap flex flex-col py-2">
					<div class="side-btn btn btn-ghost btn-sm mx-1">등록</div>
				</div>
				<div class="btn btn-sm mx-1">
					<a href="../member/profile?memberId=${rq.loginedMemberId }">프로필</a>
				</div>
			</div>
		</div>
		
		
		<div>
			<div class="bg-white border shadow-2xl rounded-3xl">
				<div class="p-10 text-3xl">반려묘 등록</div>
				<div class="p-6">
					<div class="profile-content">
						<div class="pt-2 pb-12 px-6">
							<form action="doRegister" method="post" onsubmit="registerFormOnSubmit(this); return false;">
								<input name="memberId" type="hidden" value="${rq.loginedMemberId }" />
								<div class="grid grid-cols-3 gap-10">
									<div class="form-control">
										<label class="label" for="name">
						                	<span class="label-text"><span class="text-red-600 font-bold pr-1">*</span>이름</span>
						            	</label>
						            	<input id="name" name="name" type="text" placeholder="Name" class="input input-bordered" required/>
									</div>
									
									<div class="form-control">
										<label class="label" for="gender">
						                	<span class="label-text"><span class="text-red-600 font-bold pr-1">*</span>성별</span>
						                </label>
						                <div class="flex justify-around gap-2 input input-bordered">
						                	<label class="label gap-2">
						                		<span><i class="fa-solid fa-venus text-xs text-red-600"></i> 암컷</span>
						                		<input id="gender" name="gender" type="radio" value="F" class="radio radio-sm" checked />
						                	</label>
						                	<label class="label gap-2">
						                		<span><i class="fa-solid fa-mars text-xs text-blue-600"></i> 수컷</span>
						                		<input name="gender" type="radio" value="M" class="radio radio-sm" />
						                	</label>
										</div>
									</div>
									
						            <div class="form-control">
						            	<label class="label" for="birthDate">
						                	<span class="label-text">생일</span>
						            	</label>
						            	<input id="birthDate" name="birthDate" type="date" min="1990-01-01" class="input input-bordered"/>
						            </div>
						        </div>
						        
						        <div class="form-control">
						            <label class="label" for="profileImage">
						                <span class="label-text">사진</span>
						            </label>
						            <input id="profileImage" name="profileImage" type="file" class="file-input file-input-bordered w-full" accept="image/gif, image/jpeg, image/png" />
						         </div>
						         
						         <div class="form-control">
						            <label class="label" for="aboutCat">
						                <span class="label-text">소개말</span>
						            </label>
						            <textarea id="aboutCat" name="aboutCat" placeholder="Introduce cat" rows="5" class="textarea textarea-bordered resize-none"></textarea>
						       	</div>
						       	
					       		<div class="grid grid-cols-2 gap-12 mt-6">
						            <button class="btn btn-primary">등록</button>
						            <button type="button" class="btn" onclick="history.back()">취소</button>
						        </div>
					        </form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>