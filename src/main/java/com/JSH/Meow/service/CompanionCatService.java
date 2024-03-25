package com.JSH.Meow.service;

import java.io.IOException;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.JSH.Meow.config.component.UploadComponent;
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

	public CompanionCat getCompanionCatById(int catId) {
		return companionCatDao.getCompanionCatById(catId);
	}

	public void doModify(int catId, String name, String gender, String birthDate, String imagePath, String aboutCat) {
		companionCatDao.doModify(catId, name, gender, birthDate, imagePath, aboutCat);
	}
	
	public void doDelete(int catId) {
		companionCatDao.doDelete(catId);
	}

	public boolean isImageTypeValid(MultipartFile image) {
		return uploadComponent.isImageTypeValid(image);
	}

	public void uploadFile(MultipartFile image, String type) throws IOException {
		uploadComponent.uploadFile(image, type);
	}
	
	public String getProfileImagePath(String type) {
		return uploadComponent.getProfileImagePath(type);
	}

	public void deleteProfileImage(String profileImage) {
		uploadComponent.deleteProfileImage(profileImage);
	}
		
}
