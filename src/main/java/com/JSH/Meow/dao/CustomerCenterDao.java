package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.CustomerFeedback;
import com.JSH.Meow.vo.Inquiry;

@Mapper
public interface CustomerCenterDao {
	
	@Insert("""
			INSERT INTO inquiry
			SET regDate = NOW()
			    , memberId = #{memberId}
			    , `type` = #{type}
			    , title = #{title}
			    , `body` = #{body}
			    , imagePath = #{imagePath}
			    , `status` = 'progress'
			""")
	void submitRequest(int memberId, String type, String title, String body, String imagePath);
	
	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();
	
	@Select("""
			SELECT C.*, M.nickname
			FROM inquiry C
			INNER JOIN `member` M
			ON C.memberId = M.id
			WHERE C.memberId = #{memberId}
			""")
	List<Inquiry> getInquiryHistory(int memberId);
	
	@Select("""
			SELECT * FROM inquiry
			WHERE id = #{receiptId}
			""")
	Inquiry getInquiryByReceiptId(int receiptId);
	
	@Select("""
			SELECT C.*, M.nickname
			FROM customer_feedback C
			INNER JOIN `member` M
			ON C.memberId = M.id
			ORDER BY C.id DESC
			""")
	List<CustomerFeedback> getFeedback();
	
	@Insert("""
			INSERT INTO customer_feedback
			SET regDate = NOW(),
			updateDate = NOW(),
			memberId = #{memberId},
			content = #{content}
			""")
	void doWriteFeedback(int memberId, String content);
	
	@Select("""
			SELECT C.*, M.nickname
			FROM customer_feedback C
			INNER JOIN `member` M
			ON C.memberId = M.id
			WHERE C.id = #{feedbackId}
			""")
	CustomerFeedback getCustomerFeedbackByFeedbackId(int feedbackId);
	
	@Update("""
			UPDATE customer_feedback
			SET updateDate = NOW()
				, content = #{content}
			WHERE id = #{feedbackId}
			""")
	void doModifyFeedback(int feedbackId, String content);
	
	@Select("""
			SELECT COUNT(*) FROM inquiry
			WHERE `status` = 'progress';
			""")
	int getProgressCount();
	
	@Select("""
			<script>
				SELECT I.*, M.nickname
				FROM inquiry I
				INNER JOIN `member` M
				ON I.memberId = M.id
				WHERE I.status = #{status}
				<choose>
					<when test="inquiryType == 2">
						AND I.type = 'inquiry'
					</when>
					<when test="inquiryType == 3">
						AND I.type = 'report'
					</when>
					<when test="inquiryType == 4">
						AND I.type = 'bug'
					</when>
					<when test="inquiryType == 5">
						AND I.type = 'suggestion'
					</when>
				</choose>
				<if test="order == false">
					ORDER BY I.id DESC
				</if>
				<if test="order == true">
					ORDER BY I.id ASC
				</if>
				LIMIT #{limitFrom}, #{inquiryCnt}
			</script>
			""")
	List<Inquiry> getInquiries(int limitFrom, int inquiryCnt, String status, int inquiryType, boolean order);
	
	@Select("""
			SELECT I.*, M.nickname
			FROM inquiry I
			INNER JOIN `member` M
			ON I.memberId = M.id
			WHERE I.id = #{id}
			""")
	Inquiry admGetInquiryById(int id);
	
}
