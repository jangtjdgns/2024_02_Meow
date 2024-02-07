<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<script>
	const loginFormOnSubmit = function(form){
		form.loginId.value = form.loginId.value.trim();
		form.loginPw.value = form.loginPw.value.trim();
		
		if (form.loginId.value.length == 0) {
			alert('아이디를 입력해주세요');
			form.loginId.focus();
			return;
		}
		
		if (form.loginPw.value.length == 0) {
			alert('비밀번호를 입력해주세요');
			form.loginPw.focus();
			return;
		}
		
		form.submit();
	}
</script>

<section class="m-width">
	<div class="hero b-mh flex items-start justify-center pt-20" style="background-image: url(https://cdn.pixabay.com/photo/2020/08/15/18/02/paws-5491105_1280.png); background-size: cover">
	    <div class="hero-content">
	        <div class="text-center lg:text-right pr-10">
	            <h1 class="text-5xl font-bold">안녕하세요!</h1>
	            <p class="py-6">Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda excepturi exercitationem
	                quasi. In deleniti eaque aut repudiandae et a id nisi.</p>
	        </div>
	        <div class="card shrink-0 w-full max-w-sm shadow-2xl bg-base-100">
	            <form action="doLogin" method="post" class="card-body" onsubmit="loginFormOnSubmit(this); return false;">
	                <div class="form-control">
	                    <label class="label">
	                        <span class="label-text font-NanumSquareNeo">아이디</span>
	                    </label>
	                    <input name="loginId" type="text" placeholder="LoginId" class="input input-bordered" required />
	                </div>
	                <div class="form-control">
	                    <label class="label">
	                        <span class="label-text font-NanumSquareNeo">비밀번호</span>
	                    </label>
	                    <input name="loginPw" type="password" placeholder="Password" class="input input-bordered" required />
	                    <label class="label">
	                    	<div>
	                        	<a href="#" class="label-text-alt link link-hover">아이디 /</a>
	                        	<a href="#" class="label-text-alt link link-hover">비밀번호 찾기</a>
	                        </div>
	                        <a href="#" class="label-text-alt link link-hover">비밀번호 재설정</a>
	                    </label>
	                </div>
	                <div class="form-control mt-6">
	                    <button class="btn btn-primary">로그인</button>
	                </div>
	                
	                <div class="btn naver-login-btn mt-2">
				        <a href="login/naver" class="naver-login-btn-font">N</a>
				    </div>
	            </form>
	        </div>
	    </div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>