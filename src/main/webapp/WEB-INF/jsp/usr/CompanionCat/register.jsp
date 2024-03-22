<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../common/header.jsp"%>
<script>
	$(function(){
		const today = new Date().toISOString().substring(0,10);
		$('#birthDate').val(today);
		$('#birthDate').attr("max", today);
		
		// 이름 변경시
		$("#name").change(function(){
			const name = $(this).val().trim();
			
			if(validataRegex($(this), 2) && name.length > 0) {
				const fc = msgByFinalConsonant($(this).val().trim(), 1);
				$("#aboutCat").attr("placeholder", `\${name}\${fc} 소개해보세요!`);
			}
		});
		
		// 소개말 변경 시, 글자수 표시
		$("#aboutCat").on("input", function(){
			$("#aboutCatLength").text($(this).val().trim().length)
		});
	})

	const registerFormOnSubmit = function(form){
		
		if(!validataNotBlank($(form.name))) {
			return form.name.focus();
		}
		
		if(!validataRegex($(form.name), 2)) {
			return form.name.focus();
		}
		
		if(form.aboutCat.value.trim().length > 100) {
			alertMsg("최대 100글자 까지 입력가능합니다.");
			return form.aboutCat.focus();
		}
		
		form.submit();
	}
	
</script>

<section class="py-12 p-mw min-h border-t bg-gray-50">
	<div class="mx-auto max-w-6xl profile-layout">
		<div>
			<div id="profile-side" class="bg-white w-72 rounded-3xl px-6 pt-8 pb-4 shadow-2xl">
				<div class="text-sm font-bold border-b-2">
					<i class="fa-solid fa-cat pr-1"></i>
					<span>반려묘 등록</span>
				</div>
				<div class="side-btn-wrap flex flex-col py-2">
					<div class="side-btn btn btn-ghost btn-sm mx-1">내 반려묘</div>
					<div class="side-btn btn btn-ghost btn-sm mx-1 btn-active">등록</div>
				</div>
			</div>
		</div>
		
		
		<div>
			<div class="bg-white border shadow-xl rounded-3xl">
				<div class="p-10 text-3xl">
					<i class="fa-solid fa-cat pr-1"></i>
					<span>반려묘 등록</span>
				</div>
				<div class="p-6">
					<div class="profile-content">
						<div class="pt-2 pb-12 px-6">
							<form action="doRegister" method="post" onsubmit="registerFormOnSubmit(this); return false;">
								<input name="memberId" type="hidden" value="${rq.loginedMemberId }" />
								<div class="grid grid-cols-3 gap-10">
								
									<!-- 이름  -->
									<div class="form-control">
										<label class="label" for="name">
						                	<span class="label-text"><span class="text-red-600 font-bold pr-1">*</span>이름</span>
						            	</label>
						            	<input id="name" name="name" type="text" placeholder="이름 입력" data-korName="이름" class="input input-bordered" />
									</div>
									
									<!-- 성별 -->
									<div class="form-control">
										<label class="label" for="gender">
						                	<span class="label-text"><span class="text-red-600 font-bold pr-1">*</span>성별</span>
						                </label>
						                <div class="flex justify-around gap-2 input input-bordered">
						                	<label class="label gap-2 cursor-pointer">
						                		<span><i class="fa-solid fa-venus text-xs text-red-600"></i> 암컷</span>
						                		<input id="gender" name="gender" type="radio" value="F" data-korName="성별" class="radio radio-sm" checked />
						                	</label>
						                	<label class="label gap-2 cursor-pointer">
						                		<span><i class="fa-solid fa-mars text-xs text-blue-600"></i> 수컷</span>
						                		<input name="gender" type="radio" value="M" data-korName="성별" class="radio radio-sm" />
						                	</label>
										</div>
									</div>
									
									<!-- 생일  -->
						            <div class="form-control">
						            	<label class="label" for="birthDate">
						                	<span class="label-text"><span class="text-red-600 font-bold pr-1">*</span>생일</span>
						            	</label>
						            	<input id="birthDate" name="birthDate" type="date" min="1990-01-01" data-korName="생일" class="input input-bordered"/>
						            </div>
						        </div>
						        
						        <!-- 프로필 이미지  -->
						        <div class="form-control">
						            <label class="label" for="profileImage">
						                <span class="label-text">프로필 이미지</span>
						            </label>
						            <input id="profileImage" name="profileImage" type="file" data-korName="프로필이미지" class="file-input file-input-bordered w-full" accept="image/gif, image/jpeg, image/png" />
						         </div>
						         
						         <!-- 소개말  -->
						         <div class="form-control">
						            <label class="label" for="aboutCat">
						                <span class="label-text">소개말</span>
						            </label>
						            <!-- 이 부분 join.jsp에도 적용 해야함  -->
						            <div class="textarea textarea-bordered p-0 relative">
						            	<textarea id="aboutCat" name="aboutCat" placeholder="소개해보세요!" rows="5" class="w-full h-full textarea resize-none" data-korName="소개말" maxLength="300"></textarea>
						            	<div class="absolute bottom-0 right-0 border-l border-t rounded-tl-lg p-1 w-16 text-center"><span id="aboutCatLength">0</span>/300</div>
						            </div>
						       	</div>
						       	
						       	<!-- 버튼  -->
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