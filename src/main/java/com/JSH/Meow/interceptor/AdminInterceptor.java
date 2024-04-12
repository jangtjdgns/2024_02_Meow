package com.JSH.Meow.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// 관리자 권한 확인 인터셉터
@Component
public class AdminInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		Rq rq = (Rq) request.getAttribute("rq");
        Integer authLevel = rq.getAuthLevel();
        
        // 비로그인 일 때 (authLevel == null), 관리자 로그인 페이지로 이동 
        if(Util.isEmpty(authLevel)) {
        	response.sendRedirect("/adm/member/login");
            return false;
        }
        
        // 관리자가 아닐 때, 뒤로가기
        if (authLevel != 0) {
        	rq.jsPrintHistoryBack("관리자 전용 페이지 입니다.");
            return false;
        }
		
		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}