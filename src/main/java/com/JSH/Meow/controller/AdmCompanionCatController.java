package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;

import com.JSH.Meow.service.CompanionCatService;
import com.JSH.Meow.service.UploadService;
import com.JSH.Meow.vo.Rq;

@Controller
public class AdmCompanionCatController {
	private CompanionCatService companionCatService;
	private Rq rq;
	
	public AdmCompanionCatController(CompanionCatService companionCatService, UploadService uploadService, Rq rq) {
		this.companionCatService = companionCatService;
		this.rq = rq;
	}
	
	// 반려묘 정보 가져오기
		/* function admGetCompanionCat(memberId) {
			$.ajax({
				url: '/adm/companionCat/detail',
			    method: 'GET',
			    data: {
			    	memberId: memberId,
			    },
			    dataType: 'json',
			    success: function(data) {
			    	
			    	$(".member").empty();
			    	
			    	if(data.success) {
			    		const cats = data.data;
			    		console.log(cats);
			    	}
				},
			      	error: function(xhr, status, error) {
			      	console.error('Ajax error:', status, error);
				},
			});
		} */
}
