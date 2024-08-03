<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../common/header.jsp"%>

<script src="/js/companionCat/registerAndModify.js"></script>

<section class="py-12 p-mw min-h border-t bg-gray-50">
	<div class="mx-auto max-w-3xl">
		<div>
			<div class="bg-white border shadow-xl rounded-3xl">
				<div class="p-10 text-3xl">
					<i class="fa-solid fa-cat pr-1"></i>
					<span>반려묘 수정</span>
				</div>
				<div class="p-6">
					<div class="pt-2 pb-12 px-6">
						<form action="doModify" method="post" onsubmit="registerFormOnSubmit(this); return false;" enctype="multipart/form-data">
							<input name="memberId" type="hidden" value="${rq.loginedMemberId }" />
							<input name="catId" type="hidden" value="${companionCat.id }" />
							<div class="grid grid-cols-3 gap-10">
							
								<!-- 이름 -->
								<div class="form-control">
									<label class="label" for="name">
					                	<span class="label-text"><span class="text-red-600 font-bold pr-1">*</span>이름</span>
					            	</label>
					            	<input id="name" name="name" type="text" placeholder="이름 입력" data-korName="이름" class="input input-bordered" value="${companionCat.name }" />
								</div>
								
								<!-- 성별 -->
								<div class="form-control">
									<label class="label" for="gender">
					                	<span class="label-text"><span class="text-red-600 font-bold pr-1">*</span>성별</span>
					                </label>
					                <div class="flex justify-around gap-2 input input-bordered">
					                	<label class="label gap-2 cursor-pointer">
					                		<span><i class="fa-solid fa-venus text-xs text-red-600"></i> 암컷</span>
					                		<input id="gender" name="gender" type="radio" value="F" data-korName="성별" class="radio radio-sm" ${companionCat.gender == "F" ? "checked" : "" } />
					                	</label>
					                	<label class="label gap-2 cursor-pointer">
					                		<span><i class="fa-solid fa-mars text-xs text-blue-600"></i> 수컷</span>
					                		<input name="gender" type="radio" value="M" data-korName="성별" class="radio radio-sm" ${companionCat.gender == "M" ? "checked" : "" } />
					                	</label>
									</div>
								</div>
								
								<!-- 생일 -->
					            <div class="form-control">
					            	<label class="label" for="birthDate">
					                	<span class="label-text"><span class="text-red-600 font-bold pr-1">*</span>생일</span>
					            	</label>
					            	<input id="birthDate" name="birthDate" type="date" min="1990-01-01" data-korName="생일" class="input input-bordered" value="${companionCat.birthDate }" />
					            </div>
					        </div>
					        
					        <!-- 프로필 이미지 -->
					        <div class="form-control mt-4">
					            <label class="label" for="profileImage">
					                <span class="label-text">프로필 이미지</span>
					                <span class="label-text text-xs"><span class="text-red-600 font-bold pr-1">*</span>이미지는 선택하지 않으면 변경되지 않습니다.</span>
					            </label>
					            <div class="flex items-center gap-2">
						            <input id="profileImage" name="profileImage" type="file" data-korName="프로필이미지" onchange="previewImage(this)" class="file-input file-input-bordered w-full" accept="image/gif, image/jpeg, image/png" />
						            <div class="dropdown dropdown-hover dropdown-top dropdown-end">
								  		<div tabindex="0" role="button" class="btn btn-sm btn-circle bg-white mt-1"><i class="fa-solid fa-image"></i></div>
									  	<ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box">
										    <li>
										    	<div class="font-bold">현재 이미지</div>
										    	<div class="[width:276px] [height:192px] overflow-hidden flex items-center">
										    		<img id="imagePreview" src="${companionCat.profileImage }" alt="선택된 이미지가 없음" class="w-full h-64"/>
										    	</div>
										    </li>
									  	</ul>
									</div>
									<button type="button" class="btn btn-circle btn-sm bg-white" onclick="resetImage()"><i class="fa-solid fa-rotate-right"></i></button>
								</div>
					         </div>
					         
					         <!-- 소개말 -->
					         <div class="form-control">
					            <label class="label" for="aboutCat">
					                <span class="label-text">소개말</span>
					            </label>
					            
					            <div class="textarea textarea-bordered p-0 relative">
					            	<textarea id="aboutCat" name="aboutCat" placeholder="소개해보세요!" oninput="checkInputTextLength(this)" rows="5" class="w-full h-full textarea resize-none" data-korName="소개말" maxLength="300">${companionCat.aboutCat }</textarea>
					            	<div class="absolute bottom-0 right-0 border-l border-t rounded-tl-lg p-1 w-16 text-center"><span class="inputTextLength">0</span> / 300</div>
					            </div>
					       	</div>
					       	
					       	<!-- 버튼 -->
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
</section>

<%@ include file="../common/footer.jsp"%>