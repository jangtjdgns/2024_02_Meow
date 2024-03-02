package com.JSH.Meow.vo;

import com.JSH.Meow.util.Util;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CustomerFeedback {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private String content;
	
	private String nickname;
	
	public String getFormattedRegDate() {
		return Util.formattedDatetime(this.regDate);
	}
	
	// \n을 <br />로 변환
	public String getContent() {
		return this.content.replaceAll("\n", "<br />");
	}
}
