package com.JSH.Meow.vo;

import com.JSH.Meow.util.Util;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Article {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private int boardId;
	private String title;
	private String body;
	private String hitCnt;
	
	private String writerName;
	private int replyCnt;
	private int reactionLikeCnt;
	
	public String getFormattedRegDate() {
		return Util.formattedDatetime(this.regDate);
	}
	
	public String getFormattedUpdateDate() {
		return Util.formattedDatetime(this.updateDate);
	}
}
