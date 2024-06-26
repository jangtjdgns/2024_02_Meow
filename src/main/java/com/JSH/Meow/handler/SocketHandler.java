package com.JSH.Meow.handler;

import java.util.HashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.JSH.Meow.service.ChatService;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.ReqResService;
import com.JSH.Meow.util.Util;

import jakarta.servlet.http.HttpSession;

@Component
public class SocketHandler extends TextWebSocketHandler {
	
	HashMap<String, WebSocketSession> sessionMap = new HashMap<>(); 	//웹소켓 세션을 담아둘 맵
	// HashMap<String, HttpSession> HttpSessionMap = new HashMap<>();
	
	// memberService, 유저 아이디를 가져오기 위함
	private MemberService memberService;
	private ChatService chatService;
	private ReqResService reqResService;

    // 생성자를 통해 HttpSession, 서비스, Rq 주입
    public SocketHandler(MemberService memberService, ChatService chatService, ReqResService reqResService) {
        this.memberService = memberService;
        this.chatService = chatService;
        this.reqResService = reqResService;
    }

	// 메시지 전송
	@Override
	public void handleTextMessage(WebSocketSession session, TextMessage message) {
		
		// 클라이언트로부터 수신한 텍스트 메시지
		String jsonMsg = message.getPayload();
		
		sendMsg(session, jsonMsg);
	}
	
	//소켓 연결
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		
		onWebSocketOpenClose(session, "님이 접속하셨습니다.", "open");
		super.afterConnectionEstablished(session);
		sessionMap.put(session.getId(), session);			 	// 웹소켓 세션을 맵에 추가
	}
	
	//소켓 종료
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		HttpSession httpSession = (HttpSession) session.getAttributes().get("HTTP_SESSION");
		int senderId = (int) httpSession.getAttribute("loginedMemberId");
		chatService.deleteRoom(senderId);			// 방 삭제
		reqResService.deleteRoom(senderId);
		
        sessionMap.remove(session.getId()); 					// 웹소켓 세션을 맵에서 제거
        onWebSocketOpenClose(session, "님이 종료하셨습니다.", "close");
        super.afterConnectionClosed(session, status);
	}
	
	
	// 웹소켓을 열고 닫을때 메시지 출력
	private void onWebSocketOpenClose(WebSocketSession session, String content, String type) {
		HttpSession httpSession = (HttpSession) session.getAttributes().get("HTTP_SESSION");
        String sender = (String) httpSession.getAttribute("loginedMemberNickname");
        String jsonMsg = Util.f("{\"sender\":\"%s\",\"content\":\"%s\",\"type\":\"%s\"}", sender, content, type);
        sendMsg(session, jsonMsg);
	}
	
	
	// 메시지 전송 메서드
	private void sendMsg(WebSocketSession session, String jsonMsg){
		
		// 기본 Uri
		String defaultUri = "ws://localhost:8085/chating/";
		String uri = session.getUri().toString();
		int roomId = Integer.parseInt(uri.substring(defaultUri.length()));
		
		// 메시지 전송
		for(String key : sessionMap.keySet()) {
			WebSocketSession wss = sessionMap.get(key);
			
			if (wss == null) {
				continue;
			}
			
			// 확인용 roomId
			int chkRoomId = Integer.parseInt(wss.getUri().toString().substring(defaultUri.length()));
			
			// roomId가 일치한 경우 메시지 전송
			if(roomId == chkRoomId) {
				try {
					wss.sendMessage(new TextMessage(jsonMsg));
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
}
