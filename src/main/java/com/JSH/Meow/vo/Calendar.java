package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Calendar {
	private int id;
    private String calendarId;
    private String regDate;
    private String updateDate;
    private String startDate;
    private String endDate;
    private int memberId;
    private String title;
    private boolean isAllday;
    private String location;
    private String state;
    private boolean isPrivate;
    
    public String getStateName() {
    	switch(this.state) {
    		case "Busy": return "바쁨";
    		case "Free": return "자유";    		
    	}
    	return this.state;
    }
}
