<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<section id="profile-bg" class="py-12 w-full min-h-screen border-t" style="background: linear-gradient(#EBE8E6, #E5D7D1);">
	<div class="mx-auto max-w-6xl profile-layout">
		<div>
			<div class="bg-white w-72 rounded-3xl p-6 shadow-2xl">
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">내 정보</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<div class="side-btn btn btn-ghost btn-sm mx-1">계정 정보 수정</div>
						<div class="side-btn btn btn-ghost btn-sm mx-1">비밀번호 재설정</div>
					</div>
				</div>
			</div>
		</div>
		
		
		<div>
			<div class="bg-white border shadow-2xl rounded-3xl">
				<div class="p-10 text-3xl">계정 정보 수정</div>
				<div class="p-6">
					<form action="doJoin" method="post" class="card-body" onsubmit="joinFormOnSubmit(this); return false;">
						<div class="form-control">
					        <label class="label">
					            <span class="label-text">아이디</span>
					        </label>
							<div class="flex gap-2">
						        <input name="loginId" type="text" placeholder="LoginId" id="loginId" class="input input-bordered w-full" required />
						        <button type="button" class="dupCheckBtn btn">중복확인</button>
						    </div>
				        </div>
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">비밀번호</span>
				            </label>
				            <input name="loginPw" type="password" placeholder="Password" class="input input-bordered" required />
				        </div>
				        
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">이름</span>
				            </label>
				            <input name="name" type="text" placeholder="Name" class="input input-bordered" required/>
				        </div>
				        
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">닉네임</span>
				            </label>
				            <input name="nickname" type="text" placeholder="Nickname" class="input input-bordered" required />
				        </div>
				        
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">나이</span>
				            </label>
				            <input name="age" type="text" placeholder="Age" class="input input-bordered" required />
				        </div>
				        
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">주소</span>
				            </label>
				            <div id="address" class="flex flex-col gap-2">
				            	<input type="hidden" name="address" value="" />
					            <div class="flex gap-2">
					            	<input type="text" id="postcode" placeholder="우편번호" class="input input-bordered w-1/3 readonly">
					            	<button type="button" onclick="getPostInfo()" class="btn">우편번호 찾기</button>
					            </div>
				            	<input type="text" id="roadAddress" placeholder="도로명주소" class="input input-bordered w-full readonly">
								<input type="text" id="jibunAddress" placeholder="지번주소" class="input input-bordered w-full readonly">
					            <div class="flex gap-2">
						            <input type="text" id="detailAddress" placeholder="상세주소" class="input input-bordered w-3/5">
									<input type="text" id="extraAddress" placeholder="참고항목" class="input input-bordered w-2/5 readonly">
					            </div>
				            </div>
				            <!-- <input name="address" type="text" placeholder="Address" class="input input-bordered" required /> -->
				        </div>
				        
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">전화번호</span>
				            </label>
				            <input name="cellphoneNum" type="text" placeholder="Mobile" class="input input-bordered" required />
				        </div>
				        
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">이메일</span>
				            </label>
				            <input name="email" type="email" placeholder="Email" class="input input-bordered" required />
				        </div>
				        
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">프로필 사진</span>
				            </label>
				            <input id="profileImage" name="profileImage" type="file" class="file-input file-input-bordered w-full" accept="image/gif, image/jpeg, image/png" />
				        </div>
				        
				        <div class="form-control">
				            <label class="label">
				                <span class="label-text">소개말</span>
				            </label>
				            <textarea name="aboutMe" placeholder="Introduce me" rows="5" class="textarea textarea-bordered resize-none"></textarea>
				        </div>
				        
				        <div class="form-control mt-6">
				            <button class="btn btn-primary">가입</button>
				        </div>
				    </form>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>