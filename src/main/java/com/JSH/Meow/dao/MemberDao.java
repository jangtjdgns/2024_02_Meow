package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.JSH.Meow.vo.Member;

@Mapper
public interface MemberDao {
	@Insert("""
			<script>
				INSERT INTO `member`
					SET regDate = NOW()
					, updateDate = NOW()
					, loginId = #{loginId}
					, loginPw = #{loginPw}
					, `name` = #{name}
					, nickname = #{nickname}
					, age = #{age}
					, address = #{address}
					, cellphoneNum = #{cellphoneNum}
					, email = #{email}
					, lastLoginDate = NOW()
					, profileImage = #{profileImage}
					, aboutMe = #{aboutMe}
			</script>
			""")
	public void joinMember(String loginId, String loginPw, String name, String nickname, int age, String address, String cellphoneNum, String email, String profileImage, String aboutMe);
	
	@Select("""
			SELECT * FROM `member`
			WHERE id = #{id}
			""")
	public Member getMemberById(int id);
	
	@Select("""
			SELECT * FROM `member`
			WHERE loginId = #{loginId}
			""")
	public Member getMemberByLoginId(String loginId);

	@Select("""
			SELECT * FROM `member`
			WHERE nickname = #{nickname}
			""")
	public Member getMemberByIdNickname(String nickname);
	
	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();
	
}
