package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReqRes {
	private int id;
	// 친구요청도 포함시키면 요청일, 응답일 추가해야할 듯
	private int requesterId;
	private int recipientId;
	private String status;
	private String code;
}
