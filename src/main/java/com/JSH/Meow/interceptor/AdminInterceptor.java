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
        
        // 세션에 authLevel이 없거나 관리자가 아닌 경우 처리
        // authLevel이 null 인경우는 비로그인 일때
        if (Util.isEmpty(authLevel) || authLevel != 0) {
        	rq.jsPrintHistoryBack("관리자 전용 페이지 입니다.");
            return false;
        }
		
		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}