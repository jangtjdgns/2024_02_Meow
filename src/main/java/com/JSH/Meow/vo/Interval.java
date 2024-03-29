package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
 * 게시글 작성 빈도 확인
 * */

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Interval {
	private String date;
	private int articleCnt;
}
