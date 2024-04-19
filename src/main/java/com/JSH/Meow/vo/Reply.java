package com.JSH.Meow.vo;

import com.JSH.Meow.util.Util;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Reply {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private String relTypeCode;
	private int relId;
	private String body;
	
	private String writerName;
	private String profileImage;
	private int boardId;
	
	
	public String getConvertNToBr() {
		return this.body.replaceAll("\n", "<br />");
	}
	
	public String getConvertBrToN() {
		return this.body.replaceAll("<br />", "\n");
	}
	
	// regDate
	public String getFormatRegDate() {
		   return Util.formattedDatetime(this.regDate);
	}
	
	// updateDate
	public String getFormatUpdateDate() {
		return Util.formattedDatetime(this.updateDate);
	}
}
