package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Friend {
	private int id;
	private String acceptDate;
	private String deleteDate;
	private String senderId;
	private String receiverId;
}
