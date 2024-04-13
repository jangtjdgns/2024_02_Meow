package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Report;

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
	
	@Select("""
			<script>
				SELECT R.*, M1.nickname reporterNickname, M2.nickname reportedTargetNickname
				FROM report R
				LEFT JOIN `member` M1
				ON R.reporterId = M1.id
				LEFT JOIN `member` M2
				ON R.reportedTargetId = M2.id
				WHERE R.relTypeCode = #{relTypeCode}
				<if test="status == 'unprocessed'">				
					AND R.updateDate IS NULL
				</if>
				<if test="status == 'processed'">				
					AND R.updateDate IS NOT NULL
				</if>
			</script>
			""")
	List<Report> getReportsByRelTypeCode(String relTypeCode, String status);
	
	@Select("""
			SELECT R.*
			    , M1.nickname reporterNickname
			    , M2.nickname reportedTargetNickname
			FROM report R
			LEFT JOIN `member` M1
			ON R.reporterId = M1.id
			LEFT JOIN `member` M2
			ON R.reportedTargetId = M2.id
			WHERE R.id = #{reportId}
			""")
	Report getReportById(int reportId);
	
	@Update("""
				UPDATE report
				SET updateDate = NOW()
					, `processing` = #{processingType}
				WHERE id = #{reportId}
			""")
	void reportProcessing(int reportId, int processingType);

}
