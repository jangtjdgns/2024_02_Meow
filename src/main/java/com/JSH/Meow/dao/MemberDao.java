package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.Status;

@Mapper
public interface MemberDao {
	@Insert("""
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
	public Member getMemberByNickname(String nickname);
	
	@Select("""
			SELECT * FROM `member`
			WHERE email = #{email}
			""")
	public Member getMemberByEmail(String email);
	
	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();

	@Select("""
			SELECT * FROM `member`
			WHERE id != #{loginedMemberId}
			""")
	public List<Member> getMembersExceptLoginedMember(int loginedMemberId);

	@Select("""
			SELECT * FROM `member`
			WHERE `status` = 0;
			""")
	public List<Member> getMembers();
	
	@Update("""
			UPDATE `member`
			SET updateDate = NOW()
				, name = #{name}
				, age = #{age}
				, address = #{address}
				, cellphoneNum = #{cellphoneNum}
				, email = #{email}
			WHERE id = #{memberId}
			""")
	public void doModify(int memberId, String name, int age, String address, String cellphoneNum, String email);
	
	@Update("""
			UPDATE `member`
			SET `status` = #{status}
			WHERE id = #{memberId}
			""")
	public void doDelete(int memberId, int status);
	
	@Select("""
			<script>
				SELECT M.*, S.snsType
				FROM `member` M
				LEFT JOIN sns_info S
				ON M.id = S.memberId
				WHERE M.name = #{name}
				AND M.email = #{email}
				<if test="loginId != null and loginId != ''">
					AND M.loginId = #{loginId}
				</if>
			</script>
			""")
	public Member getMemberByCredentials(String name, String loginId, String email);
	
	@Select("""
			UPDATE `member`
			SET updateDate = NOW()
				, loginPw = #{resetLoginPw}
			WHERE id = #{memberId}
			""")
	public void doResetLoginPw(int memberId, String resetLoginPw);
	
	@Select("""
			SELECT `status`,
			    COUNT(*) AS `count`,
			    ROUND(
			        (COUNT(*) / (SELECT COUNT(*) FROM `member`)
			    ) * 100, 2) AS percent
			FROM `member`
			GROUP BY `status`;
			""")
	public List<Status> getStatus();
}
