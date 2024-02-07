package com.JSH.Meow.vo;

import java.io.IOException;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import com.JSH.Meow.util.Util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.Getter;

@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class Rq {
	
	@Getter
	private int loginedMemberId;
	@Getter
	private String loginedMemberNickname;
	@Getter
	private String loginedMemberProfileImage;
	
	private HttpServletRequest req;
	private HttpServletResponse res;
	private HttpSession session;
	
	public Rq(HttpServletRequest req, HttpServletResponse res) {
		this.req = req;
		this.res = res;
		
		this.session = req.getSession();
		
		int loginedMemberId = 0;
		
		if(this.session.getAttribute("loginedMemberId") != null) {
			loginedMemberId = (int) this.session.getAttribute("loginedMemberId");
			loginedMemberNickname = (String) this.session.getAttribute("loginedMemberNickname");
			loginedMemberProfileImage = (String) this.session.getAttribute("loginedMemberProfileImage");
		}
		
		this.loginedMemberId = loginedMemberId;
	}
	
	public String jsReturnOnView(String msg) {
		this.req.setAttribute("msg", msg);
		return "usr/common/jsReturnOnView";
	}
	
	// session login
	public void login(Member member) {
		this.session.setAttribute("loginedMemberId", member.getId());
		this.session.setAttribute("loginedMemberNickname", member.getNickname());
		this.session.setAttribute("loginedMemberProfileImage", member.getProfileImage());
	}
		
	// session logout
	public void logout() {
		this.session.removeAttribute("loginedMemberId");
		this.session.removeAttribute("loginedMemberNickname");
		this.session.removeAttribute("loginedMemberProfileImage");
	}

	// jsPrintHistoryBack
	public void jsPrintHistoryBack(String msg) {
		res.setContentType("text/html; charset=UTF-8;");
		
		try {
			res.getWriter().append(Util.jsHistoryBack(msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
