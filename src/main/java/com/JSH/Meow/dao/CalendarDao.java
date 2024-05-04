package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.JSH.Meow.vo.Calendar;

@Mapper
public interface CalendarDao {
	
	@Insert("""
			INSERT INTO calendar
				SET calendarId = #{calendarId}
					, regDate = NOW()
					, updateDate = NOW()
					, startDate = #{startDate}
					, endDate = #{endDate}
					, memberId = #{memberId}
					, title = #{title}
					, isAllday = #{isAllday}
					, location = #{location}
					, `state` = #{state}
					, isPrivate = #{isPrivate}
			""")
	public void createEvent(String calendarId, String startDate, String endDate, int memberId, String title,
			boolean isAllday, String location, String state, boolean isPrivate);
	
	@Select("""
			SELECT * FROM calendar
			WHERE memberId = #{memberId}
			""")
	public List<Calendar> getEvnets(int memberId);
	
}
