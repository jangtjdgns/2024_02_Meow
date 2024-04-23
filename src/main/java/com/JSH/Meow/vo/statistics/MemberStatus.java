package com.JSH.Meow.vo.statistics;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MemberStatus {
	// 회원 상태 확인용
	private int status;
	private int count;
	private double percent;
}
