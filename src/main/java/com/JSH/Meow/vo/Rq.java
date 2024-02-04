package com.JSH.Meow.vo;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class Rq {
	
	private HttpServletRequest req;
	private HttpServletResponse res;
	
	public Rq(HttpServletRequest req, HttpServletResponse res) {
		this.req = req;
		this.res = res;
	}
	
	public String jsReturnOnView(String msg) {
		this.req.setAttribute("msg", msg);
		return "usr/common/jsReturnOnView";
	}
}
