package com.JSH.Meow.service;

import java.util.Random;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.JSH.Meow.vo.Email;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {
	
	private JavaMailSender javaMailSender;
	
	public EmailService(JavaMailSender javaMailSender) {
		this.javaMailSender = javaMailSender;
	}
	
	public String sendMail(String email) {
		String authCode = createAuthCode();
		
		Email emailInfo = new Email();
		emailInfo.setTo(email);
		emailInfo.setSubject("[Meow] 회원가입 인증번호");
		emailInfo.setMessgae(""
				+ "<div style='margin: 50px 100px'>"
				+ "<h2>안녕하세요!</h2>"
				+ "<h2>고양이를 위한 소중한 공간, Meow 입니다!🐱💖</h2><br>"
				+ "<div style='border:2px solid; border-radius: 1rem; padding: 20px; text-align: center; font-weight: bold;'>"
				+ "<div>회원가입 인증 코드 6자리 입니다.</div>"
				+ "<div id='mailAuthCode' style='font-size: 2rem; margin-top: .5rem;'>" + authCode + "</div>"
				+ "</div></div>");
        

		// MIME은 이메일에서 텍스트 이외의 다양한 데이터를 다룰 수 있게 하는 표준
		// 텍스트, 이미지, 첨부 파일 등을 처리 가능
		MimeMessage mimeMessage = javaMailSender.createMimeMessage();

        try {
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, false, "UTF-8");
            mimeMessageHelper.setTo(emailInfo.getTo()); 				// 메일 수신자
            mimeMessageHelper.setSubject(emailInfo.getSubject()); 		// 메일 제목
            mimeMessageHelper.setText(emailInfo.getMessgae(), true); 	// 메일 본문 내용
            javaMailSender.send(mimeMessage);
            
            System.out.println("Success");
            return authCode;

        } catch (MessagingException e) {
            System.out.println("Fail");
            throw new RuntimeException(e);
        }
	}
	
	// 6자리 인증 번호 생성 메서드
	public String createAuthCode() {
		Random random = new Random();
		StringBuffer key = new StringBuffer();		// 가변한 문자열을 처리하기 위한 클래스
		
		for(int i = 0; i < 6; i++) {
			int idx = random.nextInt(3);			// 0~2 까지 난수 생성
			
			switch (idx) {
	            case 0: key.append((char) ((int) random.nextInt(26) + 65)); break;	// idx 0일때 대문자 변환 후 key에 추가
	            default: key.append(random.nextInt(9));			// idx 1~2 일때 0~9의 난수 생성 후 key에 추가
	        }
		}
		
		return key.toString();
	}
}
