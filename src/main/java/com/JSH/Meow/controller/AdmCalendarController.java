package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.CalendarService;
import com.JSH.Meow.vo.Calendar;
import com.JSH.Meow.vo.ResultData;

@Controller
public class AdmCalendarController {
	
	private CalendarService calendarService;
	
	public AdmCalendarController(CalendarService calendarService) {
		this.calendarService = calendarService;
	}
	
	// 일정 조회, ajax
	@RequestMapping("/adm/calendar/getEvents")
	@ResponseBody
	public ResultData<List<Calendar>> getEvents(int memberId) {
		
		List<Calendar> events = calendarService.getEvents(memberId);
		
		if(events.size() == 0) {
			return ResultData.from("F-1", "등록된 일정이 없습니다.", events);
		}
		
		return ResultData.from("S-1", "등록된 일정 데이터를 반환합니다.", events);
	}
	
	// 일정 추가, ajax
	@RequestMapping("/adm/calendar/createEvent")
	@ResponseBody
	public ResultData createEvent(String calendarId, String startDate, String endDate, int memberId,
			String title, boolean isAllday, String location, String state, boolean isPrivate) {
		
		calendarService.createEvent(calendarId, startDate, endDate, memberId, title, isAllday, location, state, isPrivate);
		
		return ResultData.from("S-1", "일정 추가 완료");
	}
}
