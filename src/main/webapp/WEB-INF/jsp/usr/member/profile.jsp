<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>
<script src="/resources/js/member/profile.js"></script>
<script src="/resources/js/common/carousel.js"></script>

<section id="profile-bg" class="py-12 p-mw min-h border-t" style="background: linear-gradient(#EBE8E6, #E5D7D1);">
	<div class="mx-auto max-w-6xl profile-layout">
		<div>
			<div id="profile-side" class="bg-white w-72 rounded-3xl p-6 shadow-2xl">
				<div role="tablist" class="tabs tabs-bordered mb-4">
				  	<a role="tab" class="tab tab-active">프로필</a>
				  	<a href="userAccount?memberId=${rq.loginedMemberId }" role="tab" class="tab">계정관리</a>
				</div>
				<div class="flex flex-col absolute bg-white rounded-xl p-2 shadow-2xl -translate-y-1/2" style="top: 50%; left: -50px">
					<div class="top-bot-btn btn btn-xs mb-2">∧</div>
					<div class="top-bot-btn btn btn-xs">∨</div>
				</div>
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">
						<i class="fa-solid fa-user pr-1"></i>
						<span>내 정보</span>
					</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<div class="side-btn btn btn-ghost btn-sm mx-1">프로필 이미지</div>
						<div class="side-btn btn btn-ghost btn-sm mx-1">소개말</div>
						<div class="side-btn btn btn-ghost btn-sm mx-1">계정관리</div>				
					</div>
				</div>
			
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">
						<i class="fa-solid fa-paw pr-1"></i>
						<span>반려묘</span>
					</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<div class="side-btn btn btn-ghost btn-sm mx-1">내 반려묘</div>
						<div class="side-btn btn btn-ghost btn-sm mx-1">반려묘 관리</div>
					</div>
				</div>
			
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">
						<i class="fa-solid fa-user-group pr-1"></i>
						<span>친구</span>
					</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<div class="side-btn btn btn-ghost btn-sm mx-1">목록</div>	
					</div>
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
						<div class="border-b border-black p-2 flex justify-between">
							<span class="text-xl">계정관리</span>
							<span class="text-xs pl-2 self-end">* SNS 회원의 경우 <strong>프로필 이미지</strong>, <strong>소개말</strong> 변경가능 (+주소?)</span>
						</div>
						
						<div class="py-12 px-6">
							<c:choose>
							    <c:when test="${snsType == 'naver'}">
							    	<div>* 네이버 로그인 계정입니다.</div>
							    	<a href="https://nid.naver.com/user2/help/myInfoV2?m=viewSecurity&lang=ko_KR" target="_blank" class="btn">네이버 계정 정보 수정</a>
							    </c:when>
							    <c:when test="${snsType == 'kakao'}">
							    	<div>* 카카오 로그인 계정입니다.</div>
							    	<a href="" target="_blank" class="btn">카카오 계정 정보 수정</a>
							    </c:when>
							    <c:when test="${snsType == 'google'}">
							    	<div>* 구글 로그인 계정입니다.</div>
							    	<a href="" target="_blank" class="btn">구글 계정 정보 수정</a>
							    </c:when>
							    <c:otherwise>
							    	<a href="userAccount?memberId=${member.id }" class="btn">계정 관리 바로가기</a>
							    </c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bg-white border shadow-2xl rounded-3xl my-32">
				<div class="p-10 text-3xl">반려묘</div>
				<div class="p-6">
					<div class="profile-content">
						<div class="text-xl border-b border-black p-2">내 반려묘</div>
						<div class="py-12 mb-12 px-8 relative">
							<c:if test="${companionCats.size() == 0 }">
								<div class="border rounded w-full h-80 flex items-center justify-center">
									<span>현재 등록된 반려묘가 없습니다.</span>
									<a href="../CompanionCat/register" class="ml-1 text-red-600 hover:underline">등록하러가기</a>
								</div>
							</c:if>
							
							<c:if test="${companionCats.size() > 1}">
								<div class="absolute flex justify-between transform -translate-y-1/2 -left-3 -right-3 top-1/2">
							      	<div class="carouselMoveBtn btn btn-circle btn-ghost">❮</div>
							      	<div class="carouselMoveBtn btn btn-circle btn-ghost">❯</div>
							    </div>
						    </c:if>
						    
						    <c:if test="${companionCats.size() > 0 }">
								<div class="carousel w-full h-80">
									<c:forEach var="cat" items="${companionCats }" varStatus="status">
										<div class="carousel-item w-full my-3 grid gap-6" style="grid-template-columns: 14rem 1fr;">
								        	<img class="w-48 h-48 border-2 rounded-full self-center justify-self-center" src="https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg"/>
							    			<div class="catInfo-wrap">
									    		<div class="catInfo">
									    			<div class="border-t border-l rounded-tl-md py-1 px-2 text-center"><span class="h-full flex items-center justify-center">이름</span></div>
									    			<input class="input input-bordered border-b-0 rounded-tr-md rounded-none h-full" value="${cat.name }" readonly />
									    		</div>
									    		<div class="catInfo">
									    			<div class="border-t border-l py-1 px-2 text-center"><span class="h-full flex items-center justify-center">생년월일</span></div>
									    			<input class="input input-bordered border-b-0 rounded-none h-full" value="${cat.birthDate != null ? cat.birthDate : '생일을 입력해주세요!'}" readonly />
									    		</div>
									    		<div class="catInfo">
									    			<div class="border border-r-0 rounded-bl-md py-1 px-2"><span class="h-full flex items-center justify-center">소개말</span></div>
										    		<textarea placeholder="${cat.name }(이)를 소개해보세요!" class="resize-none border rounded-br-md py-2 px-4" disabled>${cat.aboutCat }</textarea>
									    		</div>
									    	</div>
								    	</div>
									</c:forEach>
								</div>
							</c:if>
							
							<c:if test="${companionCats.size() > 1}">
								<%-- <input class="join-item btn btn-outline [min-height:1rem] [height:1.2rem] [padding-left:.5rem]" type="radio" name="options" ${i == 1 ? 'checked' : '' }/> --%>
								<div class="join absolute left-1/2 -translate-x-1/2 bottom-4">
									<c:forEach var="i" begin="1" end="${companionCats.size() }" step="1">
										<input class="carouselRadio radio radio-info mx-1 glass" type="radio" name="options" ${i == 1 ? 'checked' : '' }/>
									</c:forEach>
								</div>
							</c:if>
						</div>
					</div>
					
					<div class="profile-content">
						<div class="text-xl border-b border-black p-2">반려묘 관리</div>
						<div class="pt-12 pb-24 px-6">
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>