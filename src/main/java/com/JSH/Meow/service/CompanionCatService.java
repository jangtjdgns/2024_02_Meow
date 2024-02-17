package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.CompanionCatDao;
import com.JSH.Meow.vo.CompanionCat;

@Service
public class CompanionCatService {
	private CompanionCatDao companionCatDao;
	
	public CompanionCatService(CompanionCatDao companionCatDao) {
		this.companionCatDao = companionCatDao;
	}

	public List<CompanionCat> getCompanionCats(int memberId) {
		return companionCatDao.getCompanionCats(memberId);
	}

	public void doRegister(int memberId, String name, String gender, String birthDate, String profileImage, String aboutCat) {
		companionCatDao.doRegister(memberId, name, gender, birthDate, profileImage, aboutCat);
	}
		
}
