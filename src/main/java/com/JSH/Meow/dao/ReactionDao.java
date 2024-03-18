package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.JSH.Meow.vo.Reaction;

@Mapper
public interface ReactionDao {
	
	@Select("""
			SELECT *
				FROM reaction
				WHERE memberId = #{memberId}
				AND relTypeCode = #{relTypeCode}
				AND relId = #{relId}
				AND reactionType = #{reactionType}
			""")
	public Reaction getreaction(int memberId, String relTypeCode, int relId, int reactionType);
	
	@Insert("""
			INSERT INTO reaction
				SET regDate = NOW()
					, memberId = #{memberId}
					, relTypeCode = #{relTypeCode}
					, relId = #{relId}
					, reactionType = #{reactionType}
					, `point` = 1
			""")
	public void insertPoint(int memberId, String relTypeCode, int relId, int reactionType);
	

	@Delete("""
			DELETE FROM reaction
				WHERE memberId = #{memberId}
				AND relTypeCode = #{relTypeCode}
				AND relId = #{relId}
				AND reactionType = #{reactionType}
			""")
	public void deletePoint(int memberId, String relTypeCode, int relId, int reactionType);
	
	@Select("""
			SELECT IFNULL(SUM(POINT), 0) `point`
			FROM reaction
			WHERE relTypeCode = #{relTypeCode}
				AND relId = #{relId}
				AND reactionType = #{reactionType}
			""")
	public int getReactionCount(String relTypeCode, int relId, int reactionType);
}
