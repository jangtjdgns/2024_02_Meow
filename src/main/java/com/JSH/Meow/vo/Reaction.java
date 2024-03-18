package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Reaction {
	private int id;
	private String regData;
	private int memberId;
	private String relTypeCode;
	private int relId;
	private int reactionType;
	private int point;
}
