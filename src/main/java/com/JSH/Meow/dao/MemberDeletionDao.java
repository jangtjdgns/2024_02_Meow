package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberDeletionDao {

	@Insert("""
			<script>
				INSERT INTO member_deletion_reason
				SET regDate = NOW()
				    , updateDate = NOW()
				    , memberId = 8
				    , deletionReasonCode = #{deletionReasonCode}
				    <if test="customDeletionReason != null and customDeletionReason.length() > 0">
				    	, customDeletionReason = #{customDeletionReason}
				    </if>
			</script>
			""")
	public void writeDeletionReason(int memberId, String deletionReasonCode, String customDeletionReason);

}
