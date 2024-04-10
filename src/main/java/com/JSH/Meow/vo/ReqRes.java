package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReqRes {
	private int id;
	private String requestDate;
	private String responseDate;
	private int requesterId;
	private int recipientId;
	private String status;
	private String code;
	
	private String writerName;
	private int timeDiffSec;
	
	public String getCodeName() {
		String code = null;
		
		switch(this.code) {
			case "friend": code = "친구"; break;
			case "chat": code = "채팅"; break;
			case "inquiry": code = "문의"; break;
		}
		
		return code;
	}
}
