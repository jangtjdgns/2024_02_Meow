package com.JSH.Meow.service;

import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.JSH.Meow.component.UploadComponent;

@Service
public class UploadService {
	
	private UploadComponent uploadComponent;
	
	public UploadService(UploadComponent uploadComponent) {
		this.uploadComponent = uploadComponent;
	}
	
	// 파일 업로드
	public void uploadFile(MultipartFile image, String type) throws IOException {
		uploadComponent.uploadFile(image, type);
	}
	
	// 이미지 확장자 확인
	public boolean isImageTypeValid(MultipartFile image) {
		return uploadComponent.isImageTypeValid(image);
	}
	
	// 프로필 이미지 경로 가져오기
	public String getProfileImagePath(String type) {
		return uploadComponent.getProfileImagePath(type);
	}
	
	// 파일 삭제
	public void deleteProfileImage(String profileImage) {
		uploadComponent.deleteProfileImage(profileImage);
	}
}
