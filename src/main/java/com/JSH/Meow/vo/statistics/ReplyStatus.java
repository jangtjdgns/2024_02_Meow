package com.JSH.Meow.vo.statistics;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReplyStatus {
	/* 댓글 작성 빈도 관련 */
	private String date;
	private String replyCnt;
}
