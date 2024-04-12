package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReportDao {
	
	@Insert("""
			INSERT INTO report
			SET regDate = NOW()
				, reporterId = #{reporterId}
				, reportedTargetId = #{reportedTargetId}
				, relTypeCode = #{relTypeCode}
				, relId = #{relId}
				, `body` = #{reportBody}
				, `type` = #{reportType}
			""")
	void doReport(int reporterId, int reportedTargetId, String relTypeCode, String relId, String reportBody, int reportType);

}
