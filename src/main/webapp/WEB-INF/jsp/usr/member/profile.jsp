<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>
<script src="/resources/js/profile.js"></script>

<section id="profile-bg" class="py-12 w-full min-h border-t" style="background: linear-gradient(#EBE8E6, #E5D7D1);">
	<div class="mx-auto max-w-6xl profile-layout">
		<div>
			<div id="profile-side" class="bg-white w-72 rounded-3xl p-6 shadow-2xl">
				<div class="text-center">
					<div class="top-bot-btn btn btn-xs w-full">∧</div>
				</div>
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">내 정보</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<div class="side-btn btn btn-ghost btn-sm mx-1">프로필 이미지</div>
						<div class="side-btn btn btn-ghost btn-sm mx-1">소개말</div>
						<div class="side-btn btn btn-ghost btn-sm mx-1">계정관리</div>				
					</div>
				</div>
			
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">반려묘 정보</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<div class="side-btn btn btn-ghost btn-sm mx-1">반려묘 등록</div>			
					</div>
					<!--
					없으면
					<div>반려묘를 등록하세요!</div>
					-->
					<!--
					있으면 
					<div>이름1</div>
					<div>이미지</div>
					<div>소개</div>
					-->
				</div>
			
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">친구</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<div class="side-btn btn btn-ghost btn-sm mx-1">목록</div>	
					</div>
				</div>

				
				<div class="text-center">
					<div class="top-bot-btn btn btn-xs w-full">∨</div>
				</div>
			</div>
		</div>
		
		
		<div>
			<div class="bg-white border shadow-2xl rounded-3xl">
				<div class="p-10 text-3xl">내 정보</div>
				<div class="p-6">
					<div class="profile-content">
						<!-- sns 로그인 유저인 경우 해당 페이지로 이동  -->
						<div class="text-xl border-b border-black p-2">프로필 이미지</div>
						<div class="flex items-start justify-between pt-12 pb-24 px-6">
							<c:if test="${member.profileImage == null}">
								<div class="h-72 w-72 border rounded-full flex items-center justify-center">이미지을 등록해주세요</div>
							</c:if>
							<c:if test="${member.profileImage != null}">
								<img class="h-72 w-72 rounded-full" src="${member.profileImage}"/>
							</c:if>
							
							<!-- 이미지 변경 모달 -->
							<div>
								<button class="btn" onclick="my_modal_3.showModal()">이미지 변경</button>
								<dialog id="my_modal_3" class="modal">
									<div class="modal-box">
										<form method="dialog">
											<button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
										</form>
										<h3 class="font-bold text-lg">이미지 변경</h3>
										<p class="py-2 pl-2 text-sm">* 소셜 유저의 경우 본래의 SNS 프로필 이미지는 변경되지않습니다.</p>
										
										<div class="py-4">
											<span>현재 이미지 정보</span>
											<div class="dropdown dropdown-bottom scale-75 rounded-full">
												<div tabindex="0" role="button" class="btn btn-sm btn-circle m-1"><i class="fa-solid fa-exclamation"></i></div>
												<p tabindex="0" class="dropdown-content z-[1] menu p2 shadow bg-base-100 rounded-box w-52 break-all">
													${member.profileImage }
												</p>
											</div>
											<img class="w-1/2 mx-auto" src="${member.profileImage }" alt="" />
										</div>
										
										<p class="pt-4 pb-2">이미지를 업로드해주세요.</p>
										<input type="file" class="file-input file-input-bordered w-full max-w-xs" accept="image/gif, image/jpeg, image/png" />
										
										<div class="text-right">
											<button class="btn">변경</button>
										</div>
									</div>
								</dialog>
							</div>
						</div>
					</div>
					<div class="profile-content">
						<div class="text-xl border-b border-black p-2">소개말</div>
						<div class="pt-12 pb-24 px-6">
							<textarea name="" placeholder="소개말을 작성해보세요 :)" class="textarea textarea-bordered w-full h-28 resize-none" readonly>${member.aboutMe != null ? '' : member.aboutMe}</textarea>
							<div class="text-right">
								<button class="btn btn-sm px-6">변경</button>
							</div>
						</div>
					</div>
					
					<div class="profile-content">
						<div class="text-xl border-b border-black p-2">계정관리</div>
						<div class="py-12 px-6">
							<a href="modify?memberId=${member.id }" class="btn">계정 정보 수정</a>
							<a href="" class="btn">비밀번호 재설정</a>
							<a href="" class="btn btn-error">계정 탈퇴</a>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bg-white border shadow-2xl rounded-3xl my-32">
				<div class="p-10 text-3xl">반려묘</div>
				<div class="p-6">
					<div>
						<div class="text-xl border-b border-black p-2">내 반려묘</div>
						<div class="pt-12 pb-24 px-6">
							123
						</div>
						<!-- <div>반려묘 정보</div>
						<div>반려묘 이미지</div>
						<div>반려묘 소개말</div> -->
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
</section>

<%@ include file="../common/footer.jsp"%>