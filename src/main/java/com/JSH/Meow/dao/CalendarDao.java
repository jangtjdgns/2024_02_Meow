package com.JSH.Meow.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Calendar;

@Mapper
public interface CalendarDao {
	
	@Select("""
			SELECT * FROM calendar
			WHERE id = #{id}
			""")
	public Calendar getCalendarById(int id);
	
	@Insert("""
			<script>
				INSERT INTO calendar
				<set>
	                calendarId = #{calendarId}
					, regDate = NOW()
					, updateDate = NOW()
					, startDate = #{start}
					, endDate = #{end}
					, memberId = #{memberId}
					, title = #{title}
					, isAllday = #{isAllday}
					, location = #{location}
					, `state` = #{state}
					, isPrivate = #{isPrivate}
	            </set>
			</script>
			""")
	public void createEvent(Map<String, Object> eventMap);
	
	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();
	
	@Select("""
			SELECT * FROM calendar
			WHERE memberId = #{memberId}
			""")
	public List<Calendar> getEvnets(int memberId);
	
	@Update("""
			<script>
				UPDATE calendar
				<set>
					updateDate = NOW()
	                <if test="eventMap.calendarId != null">, calendarId = #{eventMap.calendarId}</if>
	                <if test="eventMap.start != null">, startDate = #{eventMap.start}</if>
	                <if test="eventMap.end != null">, endDate = #{eventMap.end}</if>
	                <if test="eventMap.title != null">, title = #{eventMap.title}</if>
	                <if test="eventMap.isAllday != null">, isAllday = #{eventMap.isAllday}</if>
	                <if test="eventMap.location != null">, location = #{eventMap.location}</if>
	                <if test="eventMap.state != null">, state = #{eventMap.state}</if>
	                <if test="eventMap.isPrivate != null">, isPrivate = #{eventMap.isPrivate}</if>
	            </set>
				WHERE id = #{id}
			</script>
			""")
	public void updateEvent(int id, Map<String, Object> eventMap);
	
	@Delete("""
			DELETE FROM calendar
			WHERE id = #{id}
			""")
	public void deleteEvent(int id);

}
