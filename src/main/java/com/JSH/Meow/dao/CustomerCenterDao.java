package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.CustomerCenter;
import com.JSH.Meow.vo.CustomerFeedback;

@Mapper
public interface CustomerCenterDao {
	
	@Insert("""
			INSERT INTO customer_center
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
			FROM customer_center C
			INNER JOIN `member` M
			ON C.memberId = M.id
			WHERE C.memberId = #{memberId}
			""")
	List<CustomerCenter> getInquiryHistory(int memberId);
	
	@Select("""
			SELECT * FROM customer_center
			WHERE id = #{receiptId}
			""")
	CustomerCenter getInquiryByReceiptId(int receiptId);
	
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
}
