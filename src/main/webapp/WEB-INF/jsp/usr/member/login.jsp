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
	
	// 글 작성하는 함수 
	function textWriterAnimation() {
	  	const text1 = "Meow에서는 귀여운 고양이 친구들과의 만남이 가능합니다!";
	  	const text2 = "함께 즐거운 시간을 보내고, 고양이들의 사랑스러운 이야기를 들어보세요.";
	  	const text3 = "여러분을 기다리고 있어요!";
	
	  	let idx1 = 0;
	  	let idx2 = 0;
	  	let idx3 = 0;
	
	  	function write() {
			if (idx1 < text1.length || idx2 < text2.length || idx3 < text3.length) {
	      		if (idx1 < text1.length) {
	        		$("#login-text1").append(text1[idx1]);
	        		idx1++;
	      		}
			
		      	if (idx2 < text2.length) {
		        	$("#login-text2").append(text2[idx2]);
		        	idx2++;
		      	}
		      	
		      	if (idx3 < text3.length) {
		        	$("#login-text3").append(text3[idx3]);
		        	idx3++;
		      	}
      			setTimeout(write, 60);
    		}
  		}
		write();
	}
	
	$(function(){
		textWriterAnimation();
	})
</script>

<section>
	<div class="hero b-mh flex items-start justify-center pt-20 border-t moveBg" style="background-image: url(https://cdn.pixabay.com/photo/2020/08/15/18/02/paws-5491105_1280.png); background-size: 105% cover;">
	    <div class="hero-content">
	        <div class="text-center lg:text-right pr-10">
	            <h1 class="text-5xl [color:#a6c1ee] font-bold font-meetme">안녕하세요!
	            	<span style="background: linear-gradient(to right top, #fbc2eb, #a6c1ee); color: transparent; -webkit-background-clip: text;">Meow</span> 입니다!
	            </h1>
	            <div class="py-6 [width:600px] text-lg [color:#35374B] font-Cutelively">
	            	<p id="login-text1" class="hover:[font-size:1.15rem]"></p>
	            	<p id="login-text2" class="hover:[font-size:1.15rem]"></p>
	            	<p id="login-text3" class="hover:[font-size:1.15rem]"></p>
	            </div>
	        </div>
	        
	        <div class="card shrink-0 w-full max-w-sm shadow-2xl bg-base-100">
	            <form action="doLogin" method="post" class="card-body" onsubmit="loginFormOnSubmit(this); return false;">
	            	<!-- 아이디 -->
	                <div class="form-control">
	                    <label class="label">
	                        <span class="label-text">아이디</span>
	                    </label>
	                    <input name="loginId" type="text" placeholder="아이디 입력" class="input input-bordered" minlength="8" maxlength="20" required />
	                </div>
	                
	                <!-- 비밀번호 -->
	                <div class="form-control">
	                    <label class="label">
	                        <span class="label-text">비밀번호</span>
	                    </label>
	                    <input name="loginPw" type="password" placeholder="비밀번호 입력" class="input input-bordered" minlength="10" maxlength="30" required />
	                    <label class="label">
	                    	<div>
	                        	<a href="../find/loginId" class="label-text-alt link link-hover">아이디 찾기 |</a>
	                        	<a href="../reset/loginPw" class="label-text-alt link link-hover">비밀번호 재설정</a>
	                        </div>
	                        <a href="join" class="label-text-alt link link-hover">회원가입</a>
	                    </label>
	                </div>
	                <div class="form-control mt-6">
	                    <button class="btn btn-primary">로그인</button>
	                </div>
	                
	                <div class="mt-2 flex justify-between">
	                	<!-- 원래는 로고만 있는 축약형 사용은 금지임. 소셜로그인 디자인 가이드를 참고해야함 -->
		                <div><a href="login/naver" class="btn border-0 w-[60px] h-[60px] font-SBAggroB text-[36px] bg-[#03c75a] text-white pt-[5px] hover:bg-[#03ba55]">N</a></div>
		                <div><a href="login/kakao" class="btn border-0 w-[60px] h-[60px] bg-[#FEE500] pt-0 hover:bg-[#f5d800]"><img src="/images/sns_login_icon/kakao.png" class="scale-[1.3]" /></a></div>
		                <div><a href="login/google" class="btn border-0 w-[60px] h-[60px]"><img src="/images/sns_login_icon/google.png" class="scale-[1.3]" /></a></div>
		                <div><a href="login/github" class="btn p-0 border-0 w-[60px] h-[60px] overflow-hidden"><i class="fa-brands fa-square-github scale-[5]" style="color: #000000;"></i></a></div>
				    </div>
	            </form>
	        </div>
	    </div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>