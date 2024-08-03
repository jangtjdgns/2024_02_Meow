package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.CompanionCat;

@Mapper
public interface CompanionCatDao {
	
	@Select("""
			SELECT * FROM companion_cat
			WHERE memberId = #{memberId};
			""")
	public List<CompanionCat> getCompanionCats(int memberId);
	
	@Insert("""
			<script>
				INSERT INTO companion_cat
				SET regDate = NOW()
				    , updateDate = NOW()
				    , memberId = #{memberId}
				    , `name` = #{name}
				    , gender = #{gender}
				    <if test="birthDate != null">
				    	, birthDate = #{birthDate}
				    </if>
				    <if test="profileImage != null">
				    	, profileImage = #{profileImage}
				    </if>
				    <if test="aboutCat != null">
				    	, aboutCat = #{aboutCat}
				    </if>
			</script>
			""")
	public void doRegister(int memberId, String name, String gender, String birthDate, String profileImage, String aboutCat);
	
	@Select("""
			SELECT COUNT(*) FROM companion_cat
			WHERE memberId = #{memberId}
			""")
	public int getCatCountById(int memberId);
	
	@Select("""
			SELECT * FROM companion_cat
			WHERE id = #{catId}
			""")
	public CompanionCat getCompanionCatById(int catId);
	
	@Update("""
			<script>
				UPDATE companion_cat
				SET updateDate = NOW()
					<if test="name != null and name != ''">
						, name = #{name}
					</if>
					<if test="gender != null and gender != ''">
						, gender = #{gender}
					</if>
					<if test="birthDate != null and birthDate != ''">
						, birthDate = #{birthDate}
					</if>
					<if test="imagePath != null and imagePath != ''">
						, profileImage = #{imagePath}
					</if>
					<if test="aboutCat != null and aboutCat != ''">
						, aboutCat = #{aboutCat}
					</if>
					WHERE id = #{catId}
			</script>
			""")
	public void doModify(int catId, String name, String gender, String birthDate, String imagePath, String aboutCat);
	
	@Delete("""
			DELETE FROM companion_cat
			WHERE id = #{catId}
			""")
	public void doDelete(int catId);
	
}
