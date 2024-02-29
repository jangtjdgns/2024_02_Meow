package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CustomerCenter {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private String type;
	private String title;
	private String body;
	private String imagePath;
	private String status;
	
	private String nickname;
	
	public String getType() {
		String type = null;
		
		if(this.type.equals("inquiry")) {
			type = "문의"; 
		} else if(this.type.equals("report")) {
			type = "신고";
		} else if(this.type.equals("bug")) {
			type = "버그제보";
		} else {
			type = "기타건의사항";
		}
		
		return type;
	}
	
	public String getStatus() {
		
		return this.status.equals("progress") ? "처리중" : "처리완료";
	}
}
