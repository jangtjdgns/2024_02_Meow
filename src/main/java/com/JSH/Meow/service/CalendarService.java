package com.JSH.Meow.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.CalendarDao;
import com.JSH.Meow.vo.Calendar;

@Service
public class CalendarService {
	private CalendarDao calendarDao;
	
	public CalendarService(CalendarDao calendarDao) {
		this.calendarDao = calendarDao;
	}
	
	public Calendar getCalendarById(int id) {
		return calendarDao.getCalendarById(id);
	}
	
	public void createEvent(Map<String, Object> eventMap) {
		calendarDao.createEvent(eventMap);
	}
	
	public int getLastInsertId() {
		return calendarDao.getLastInsertId();
	}
	
	public List<Calendar> getEvents(int memberId) {
		return calendarDao.getEvnets(memberId);
	}

	public void updateEvent(int id, Map<String, Object> eventMap) {
		calendarDao.updateEvent(id, eventMap);
	}

	public void deleteEvent(int id) {
		calendarDao.deleteEvent(id);
	}

}
