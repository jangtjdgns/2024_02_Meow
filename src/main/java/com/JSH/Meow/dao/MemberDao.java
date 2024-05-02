package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.statistics.MemberStatus;

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
			WHERE `status` = 0
			AND authLevel = 1;
			""")
	public List<Member> getMembers();
	
	@Select("""
			SELECT M.*, S.snsType, DATEDIFF(NOW(), M.lastLoginDate) AS lastLoginDaysDiff
			FROM `member` M
			LEFT JOIN sns_info S
			ON M.id = S.memberId
			WHERE M.authLevel = 1
			AND M.id = #{memberId}
			""")
	public Member admGetMemberById(int memberId);
	
	@Select("""
			<script>
				SELECT M.*, S.snsType, DATEDIFF(NOW(), M.lastLoginDate) AS lastLoginDaysDiff
				FROM `member` M
				LEFT JOIN sns_info S
				ON M.id = S.memberId
				WHERE M.authLevel = 1
				<choose>
					<when test="searchType == 'all' and searchKeyword != ''">
						AND (
				            M.name LIKE CONCAT('%', #{searchKeyword}, '%')
				            OR M.loginId LIKE CONCAT('%', #{searchKeyword}, '%')
				            OR M.nickname LIKE CONCAT('%', #{searchKeyword}, '%')
				            OR M.email LIKE CONCAT('%', #{searchKeyword}, '%')
				            OR M.cellphoneNum LIKE CONCAT('%', #{searchKeyword}, '%')
				        )
					</when>
					<when test="searchType == 'name'">
						AND M.name LIKE CONCAT('%', #{searchKeyword}, '%')
					</when>
					<when test="searchType == 'loginId'">
						AND M.loginId LIKE CONCAT('%', #{searchKeyword}, '%')
					</when>
					<when test="searchType == 'nickname'">
						AND M.nickname LIKE CONCAT('%', #{searchKeyword}, '%')
					</when>
					<when test="searchType == 'email'">
						AND M.email LIKE CONCAT('%', #{searchKeyword}, '%')
					</when>
					<otherwise>
						AND M.cellphoneNum LIKE CONCAT('%', #{searchKeyword}, '%')
					</otherwise>
				</choose>
				<choose>
					<when test="memberType == 'native'">
						AND S.snsType IS NULL
					</when>
					<when test="memberType == 'sns'">
						AND S.snsType IS NOT NULL
					</when>
				</choose>
				<if test="order == false">
					ORDER BY M.id ASC
				</if>
				<if test="order == true">
					ORDER BY M.id DESC
				</if>
				LIMIT #{limitFrom}, #{memberCnt};
			</script>
			""")
	public List<Member> admGetMembers(int limitFrom, int memberCnt, String searchType, String searchKeyword, String memberType, boolean order);
	
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
	public List<MemberStatus> getStatus();
}
