package com.JSH.Meow.config.component;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;

@Component
public class UploadComponent {
	
	// 기본 업로드 경로
	@Value("${upload.directory}")
    @Getter
    private String uploadDirectory;
	
	@Getter
	private String fileName;
	
	// 회원 프로필 이미지 업로드 경로
	@Value("/images/upload/profile/member/")
	private String profileMemberImagePath;
	
	// 반려묘 프로필 이미지 업로드 경로
	@Value("/images/upload/profile/companionCat/")
	private String profileCompanionCatImagePath;
	
	// 파일 업로드 (현재 프로필 이미지만 업로드 하게끔 로직 구현)
	public void uploadFile(MultipartFile file, String type) throws IOException {
		String directory = null;
		String originalFileName = file.getOriginalFilename();
		
		// 프로필 이미지 타입 확인 후 경로 지정
		if(isImageTypeValid(file)) {
			// 타입에 따라서 경로 설정(member, companionCat)
			directory = uploadDirectory + (type.equals("member") ? profileMemberImagePath : profileCompanionCatImagePath);
			UUID randomUUID = UUID.randomUUID();
			fileName = randomUUID.toString() + "_" + originalFileName;
		}
		
		// 업로드
        Path targetPath = Path.of(directory, fileName);
        byte[] fileBytes = file.getBytes();
        Files.write(targetPath, fileBytes);
    }
	
	
	// 파일 삭제
	public void deleteProfileImage(String profileImage) {
		
		// 상대경로
		String relativePath = profileImage.replace("\\", "/");
		// 절대경로
		String absolutePath = System.getProperty("user.dir") + "/src/main/resources/static/" + relativePath;
		
		// 절대 경로를 통한 삭제 진행
		File file = new File(absolutePath);
        if (file.exists()) {
           file.delete();
        }
	}
	
	
	// 확장자 검사
	public boolean isImageTypeValid(MultipartFile image) {
		String[] supportedExt = {"jpg", "jpeg", "png", "gif"};
		String fileName = image.getOriginalFilename();
		String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1);	// 확장자만 얻기
		
		for(String ext: supportedExt) {
			if(ext.equals(fileExt)) {
				return true;
			}
		}
		
		return false;
	}
	
	
	// 프로필 이미지 경로 가져오기
	public String getProfileImagePath(String type) {
		Path path = Path.of(type.equals("member") ? profileMemberImagePath : profileCompanionCatImagePath, fileName);
		return path.toString();
	}
}
