package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.CalendarDao;
import com.JSH.Meow.vo.Calendar;

@Service
public class CalendarService {
	private CalendarDao calendarDao;
	
	public CalendarService(CalendarDao calendarDao) {
		this.calendarDao = calendarDao;
	}

	public void createEvent(String calendarId, String startDate, String endDate, int memberId,
			String title, boolean isAllday, String location, String state, boolean isPrivate) {
		calendarDao.createEvent(calendarId, startDate, endDate, memberId, title, isAllday, location, state, isPrivate);
	}

	public List<Calendar> getEvents(int memberId) {
		return calendarDao.getEvnets(memberId);
	}
}
