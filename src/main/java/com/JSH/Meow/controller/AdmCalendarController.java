package com.JSH.Meow.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.CalendarService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Calendar;
import com.JSH.Meow.vo.ResultData;
import com.fasterxml.jackson.databind.ObjectMapper;

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
	public ResultData<Integer> createEvent(String eventJson) {
		
		calendarService.createEvent(Util.jsonToMap(eventJson));
		
		int eventId = calendarService.getLastInsertId();
		
		return ResultData.from("S-1", "일정이 등록되었습니다.", eventId);
	}
	
	// 일정 수정, ajax
	@RequestMapping("/adm/calendar/updateEvent")
	@ResponseBody
	public ResultData updateEvent(int id, String eventJson) {
		
		Calendar calendar = calendarService.getCalendarById(id);
		
		if(calendar == null) {
			return ResultData.from("F-1", Util.f("%d번 일정이 존재하지 않습니다.", id));
		}
		
		calendarService.updateEvent(id, Util.jsonToMap(eventJson));
		
		return ResultData.from("S-1", "일정이 변경되었습니다.");
	}
	
	// 일정 삭제, ajax
	@RequestMapping("/adm/calendar/deleteEvent")
	@ResponseBody
	public ResultData deleteEvent(int id) {
		
		Calendar calendar = calendarService.getCalendarById(id);
		
		if(calendar == null) {
			return ResultData.from("F-1", Util.f("%d번 일정이 존재하지 않습니다.", id));
		}
		
		calendarService.deleteEvent(id);
		
		return ResultData.from("S-1", "일정이 삭제되었습니다.");
	}
}
