package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.component.UploadComponent;
import com.JSH.Meow.dao.CompanionCatDao;
import com.JSH.Meow.vo.CompanionCat;

@Service
public class CompanionCatService {
	private CompanionCatDao companionCatDao;
	private UploadComponent uploadComponent;
	
	public CompanionCatService(CompanionCatDao companionCatDao, UploadComponent uploadComponent) {
		this.companionCatDao = companionCatDao;
		this.uploadComponent = uploadComponent;
	}

	public List<CompanionCat> getCompanionCats(int memberId) {
		return companionCatDao.getCompanionCats(memberId);
	}

	public void doRegister(int memberId, String name, String gender, String birthDate, String profileImage, String aboutCat) {
		companionCatDao.doRegister(memberId, name, gender, birthDate, profileImage, aboutCat);
	}
	
	public int getCatCountById(int memberId) {
		return companionCatDao.getCatCountById(memberId);
	}

	public CompanionCat getCompanionCatById(int catId) {
		return companionCatDao.getCompanionCatById(catId);
	}

	public void doModify(int catId, String name, String gender, String birthDate, String imagePath, String aboutCat) {
		companionCatDao.doModify(catId, name, gender, birthDate, imagePath, aboutCat);
	}
	
	public void doDelete(int catId) {
		companionCatDao.doDelete(catId);
	}
}
