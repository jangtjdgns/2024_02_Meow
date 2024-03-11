<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<script src="/js/member/findAccount.js"></script>

<section id="profile-bg" class="py-12 p-mw min-h border-t" style="background: linear-gradient(#EBE8E6, #E5D7D1);">
	<div class="mx-auto max-w-5xl profile-layout">
		<div>
			<div class="bg-white w-72 rounded-3xl p-6 shadow-2xl">
				<div class="pb-4">
					<div class="text-sm font-bold py-2 border-b-2">
						<i class="fa-solid fa-key pr-1"></i>
						<span>계정찾기</span>
					</div>
					<div class="side-btn-wrap flex flex-col pt-2">
						<a class="side-btn btn btn-ghost btn-sm mx-1 btn-active">아이디 찾기</a>
						<a class="side-btn btn btn-ghost btn-sm mx-1">비밀번호 재설정</a>
					</div>
				</div>
			</div>
		</div>
		
		<div id="section-wrap">
			<div class="bg-white border shadow-2xl rounded-3xl pb-10">
				<div class="p-10 text-3xl">
					<i class="fa-solid fa-key pr-1"></i>
					<span>아이디 찾기</span>
				</div>
				<div class="p-6">
					<div class="form-control">
	                    <label class="label">
	                        <span class="label-text">이름</span>
	                    </label>
	                    <input id="name" type="text" placeholder="이름 입력" class="input input-bordered" data-korName="이름" minlength="8" maxlength="20" autocomplete="off" required />
	                </div>
	                
	                <div class="form-control">
	                    <label class="label">
	                        <span class="label-text">이메일</span>
	                    </label>
	                    <input id="email" type="text" placeholder="이메일 입력" class="input input-bordered" data-korName="이메일" minlength="6" maxlength="200" autocomplete="off" required />
	                </div>
	                
	                <div class="text-right pt-6">
		                <button class="btn btn-wide fintBtn" onclick="findLoginId()">찾기</button>
	                </div>
				</div>
			</div>
		</div>
	</div>
</section>
<%@ include file="../common/footer.jsp"%>