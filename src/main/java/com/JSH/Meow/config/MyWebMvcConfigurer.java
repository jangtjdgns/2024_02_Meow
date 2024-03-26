package com.JSH.Meow.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.JSH.Meow.interceptor.AdminInterceptor;
import com.JSH.Meow.interceptor.BeforeActionInterceptor;
import com.JSH.Meow.interceptor.NeedLoginInterceptor;
import com.JSH.Meow.interceptor.NeedLogoutInterceptor;

@Configuration
public class MyWebMvcConfigurer implements WebMvcConfigurer {

	private BeforeActionInterceptor beforeActionInterceptor;
	private NeedLoginInterceptor needLoginInterceptor;
	private NeedLogoutInterceptor needLogoutInterceptor;
	private AdminInterceptor adminInterceptor;

	public MyWebMvcConfigurer(BeforeActionInterceptor beforeActionInterceptor
			, NeedLoginInterceptor needLoginInterceptor
			, NeedLogoutInterceptor needLogoutInterceptor
			, AdminInterceptor adminInterceptor) {
		this.beforeActionInterceptor = beforeActionInterceptor;
		this.needLoginInterceptor = needLoginInterceptor;
		this.needLogoutInterceptor = needLogoutInterceptor;
		this.adminInterceptor = adminInterceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		InterceptorRegistration ir;
		ir = registry.addInterceptor(beforeActionInterceptor);
		ir.addPathPatterns("/**");
		ir.addPathPatterns("/favicon.ico");
		ir.excludePathPatterns("/resource/**");
		
		// 로그인 필요
		ir = registry.addInterceptor(needLoginInterceptor);
		ir.addPathPatterns("/usr/article/write");
		ir.addPathPatterns("/usr/article/doWrite");
		ir.addPathPatterns("/usr/article/modify");
		ir.addPathPatterns("/usr/article/doModify");
		ir.addPathPatterns("/usr/article/doDelete");
		ir.addPathPatterns("/usr/member/doLogout");
		ir.addPathPatterns("/usr/member/profile");
		ir.addPathPatterns("/usr/member/userAccount");
		ir.addPathPatterns("/usr/member/doModify");
		ir.addPathPatterns("/usr/member/doDelete");
		ir.addPathPatterns("/usr/companionCat/view");
		ir.addPathPatterns("/usr/companionCat/register");
		ir.addPathPatterns("/usr/companionCat/doRegister");
		ir.addPathPatterns("/usr/companionCat/doDelete");
		ir.addPathPatterns("/usr/chat/popUp");
		ir.addPathPatterns("/usr/send/mail");
		ir.addPathPatterns("/usr/reaction/doReaction");
		ir.addPathPatterns("/usr/reply/doWrite");
		ir.addPathPatterns("/usr/reply/doModify");
		ir.addPathPatterns("/usr/reply/doDelete");
		ir.addPathPatterns("/usr/customer/submitRequest");
		ir.addPathPatterns("/usr/customer/doWriteFeedback");
		ir.addPathPatterns("/usr/customer/doModifyFeedback");

		// 로그아웃 필요
		ir = registry.addInterceptor(needLogoutInterceptor);
		ir.addPathPatterns("/usr/member/login");
		ir.addPathPatterns("/usr/member/doLogin");
		ir.addPathPatterns("/usr/member/login/naver");
		ir.addPathPatterns("/usr/member/doLogin/naver");
		ir.addPathPatterns("/usr/member/join");
		ir.addPathPatterns("/usr/member/doJoin");
		ir.addPathPatterns("/usr/find/loginId");
		ir.addPathPatterns("/usr/doFind/loginId");
		
		ir.addPathPatterns("/adm/member/login");
		ir.addPathPatterns("/adm/member/doLogin");
		
		// 관리자 권한 필요
		ir = registry.addInterceptor(adminInterceptor);
		ir.addPathPatterns("/adm/home/main");
	}

}
