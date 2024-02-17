package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.JSH.Meow.vo.CompanionCat;

@Mapper
public interface CompanionCatDao {
	
	@Select("""
			SELECT * FROM companion_cat
			WHERE memberId = #{memberId};
			""")
	List<CompanionCat> getCompanionCats(int memberId);
	
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
	void doRegister(int memberId, String name, String gender, String birthDate, String profileImage, String aboutCat);
	
}
