<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>
<script src="/js/member/profile.js"></script>
<script src="/js/common/carousel.js"></script>

<!-- 프로필 이미지 변경 모달 -->
<dialog id="my_modal_4" class="modal">
	<div class="modal-box">
		<form method="dialog">
			<button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
		</form>
		<h3 class="font-bold text-lg">이미지 변경</h3>
		<p class="pt-2 pl-2 text-sm">* <u>소셜 유저</u>의 경우 본래의 SNS 프로필 이미지는 변경되지 않습니다.</p>
		<p class="pb-2 pl-2 text-sm">* 이미지 변경 후 <u class="text-red-600">새로고침</u>을 진행해주세요.</p>
		
		<form onsubmit="doUpdateProfileImage(this)" enctype="multipart/form-data">
			<div class="py-4">
				<span>현재 이미지 정보</span>
				<div class="dropdown dropdown-bottom scale-75 rounded-full">
					<div tabindex="0" role="button" class="btn btn-sm btn-circle m-1"><i class="fa-solid fa-exclamation"></i></div>
					<p tabindex="0" class="dropdown-content z-[1] menu p2 shadow bg-base-100 rounded-box w-52 break-all">
						${member.profileImage }
					</p>
				</div>
				<div class="w-[288px] min-h-[100px] border">
					<img id="imagePreview" src="${member.profileImage }" alt="선택된 이미지가 없음" />
				</div>
			</div>
			
			<div class="py-4 flex items-center gap-2">
				<input id="profileImage" name="profileImage" type="file" onchange="previewImage(this)" class="file-input file-input-bordered file-input-sm w-full max-w-xs" accept="image/gif, image/jpeg, image/png" />
				<button type="button" class="btn btn-circle btn-sm bg-white" onclick="resetImage()"><i class="fa-solid fa-rotate-right"></i></button>
			</div>
			
			<div class="text-right">
				<button class="btn btn-sm btn-primary">변경</button>
			</div>
		</form>
	</div>
</dialog>

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
							
							<!-- 프로필 이미지 변경 버튼 -->
							<div>
								<button class="btn" onclick="my_modal_4.showModal()">이미지 변경</button>
							</div>
						</div>
					</div>
					<div class="profile-content">
						<div class="text-xl border-b border-black p-2">소개말</div>
						<div class="pt-12 pb-24 px-6">
							<textarea name="" placeholder="소개말을 작성해보세요 :)" class="textarea textarea-bordered w-full h-28 resize-none" readonly>${member.aboutMe == null ? '' : member.aboutMe}</textarea>
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
							    <c:when test="${snsType == 'google'}">
							    	<div>* 구글 로그인 계정입니다.</div>
							    	<a href="" target="_blank" class="btn">깃허브 계정 정보 수정</a>
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
									<a href="../companionCat/register" class="ml-1 text-red-600 hover:underline">등록하러가기</a>
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
										<input class="carouselRadio radio radio-info mx-1 glass" type="radio" name="options" data-idx="${i - 1}" ${i == 1 ? 'checked' : '' }/>
									</c:forEach>
								</div>
							</c:if>
						</div>
					</div>
					
					<div class="profile-content">
						<div class="text-xl border-b border-black p-2">반려묘 관리</div>
						<div class="py-12 px-6">
							<a href="../companionCat/view?memberId=${rq.loginedMemberId }" class="btn">내 반려묘 페이지로 이동</a>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bg-white border shadow-2xl rounded-3xl my-32">
				<div class="p-10 text-3xl">친구</div>
				<div class="p-6">
					<div class="profile-content">
						<div class="text-xl border-b border-black p-2">친구 목록 <span>(${friends.size() }명)</span></div>
						<div class="py-12 mb-12 px-8 grid grid-cols-3 gap-4">
							<c:if test="${friends.size() == 0}">
								<div class="col-start-1 col-end-3">현재 등록된 친구가 없습니다.</div>
							</c:if>
							
							<c:forEach var="friend" items="${friends }" varStatus="status">
								<div class="border shadow-md transition-[transform] duration-[0.4s] hover:scale-105 cursor-pointer">
									<div class="grid grid-cols-7 min-h-16 overflow-hidden">
										<div class="col-start-1 col-end-3 border-r scale-150 rotate-12 relative bg-indigo-50">
											<div class="absolute top-1/2 left-1/2 trnasform -translate-x-1/2 -translate-y-1/2 -rotate-12 scale-[0.6]">
												${status.count }
											</div>
										</div>
										<div class="col-start-3 col-end-8 justify-self-center self-center font-semibold">
											${friend.senderId == rq.loginedMemberId ? friend.receiverNickname : friend.senderNickname }
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>