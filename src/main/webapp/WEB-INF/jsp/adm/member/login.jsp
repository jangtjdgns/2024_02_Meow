<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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

<div class="hero min-h-screen bg-base-200">
  	<div class="hero-content flex-col lg:flex-row-reverse border py-40 px-20 bg-white rounded-box">
    	<div class="text-center lg:text-left pl-10">
      		<h1 class="text-5xl font-bold pb-12">관리자 로그인</h1>
      		<div class="[width:600px] text-lg">
	      		<div>
	      			<span>안녕하세요</span>
	     			<span class="font-bold" style="background: linear-gradient(to right top, #fbc2eb, #a6c1ee); color: transparent; -webkit-background-clip: text;">Meow</span>
	      			<span>의 관리자 페이지 입니다.</span>
	      		</div>
	      		<div class="pt-3 pb-12">해당 페이지에서는 일반 유저의 경우 로그인이 제한 됩니다.</div>
	      		<div class="flex items-center gap-3">
	      			<a href="/" class="btn"><img src="/images/favicon/cat-pow.ico" />Meow 홈페이지 바로가기</a>
	      			<a href="../../usr/member/login" class="btn">Meow 로그인 페이지 바로가기</a>
	      		</div>
      		</div>
    	</div>
    	
    	<div class="card shrink-0 w-full max-w-sm shadow-2xl bg-base-100">
      		<form action="doLogin" method="post" class="card-body" onsubmit="loginFormOnSubmit(this); return false;">
        		<div class="form-control">
          			<label class="label">
            			<span class="label-text">관리자 아이디</span>
          			</label>
          			<input name="loginId" type="text" placeholder="관리자 아이디 입력" class="input input-bordered" minlength="8" maxlength="20" required />
        		</div>
        		<div class="form-control">
	          		<label class="label">
	            		<span class="label-text">비밀번호</span>
	          		</label>
	          		<input name="loginPw" type="password" placeholder="비밀번호 입력" class="input input-bordered" minlength="10" maxlength="30" required />
        		</div>
        		<div class="form-control mt-6">
          			<button class="btn btn-primary">관리자 로그인</button>
        		</div>
      		</form>
    	</div>
  	</div>
</div>

<%@ include file="../common/footer.jsp"%>