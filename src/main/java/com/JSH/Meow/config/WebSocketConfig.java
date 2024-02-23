package com.JSH.Meow.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.JSH.Meow.handler.SocketHandler;
import com.JSH.Meow.interceptor.HttpSessionHandshakeInterceptor;
import com.JSH.Meow.service.ChatService;
import com.JSH.Meow.service.MemberService;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

	// 웹소켓 핸들러 클래스를 주입받음
	@Autowired
	private SocketHandler socketHandler;
	
	// memberService
	private MemberService memberService;
	private ChatService chatService;
	
	// 의존성 주입
    public WebSocketConfig(MemberService memberService, ChatService chatService) {
        this.memberService = memberService;
        this.chatService = chatService;
    }
    
	// WebSocketConfigurer 인터페이스의 메서드를 구현
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		// socketHandler를 엔드포인트 /chating/{roomId}로 등록
		// 클라이언트가 엔드포인트 /chating/{roomId}로 연결 시 socketHandler가 연결 처리
		registry.addHandler(socketHandler, "/chating/{roomId}")		// {roomId} 방 구분
			.addInterceptors(new HttpSessionHandshakeInterceptor());		
	}
}
