package com.JSH.Meow.config.component;

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
	
	@Value("/images/upload/profile/member/")
	private String profileMemberImagePath;
	
	public void uploadFile(MultipartFile file) throws IOException {
		String directory = null;
		String originalFileName = file.getOriginalFilename();
		
		// 프로필 이미지 파일인지 확인, 이후에 게시글 이미지, 프로필 이미지 분리필요할듯
		if(isImageTypeValid(file)) {
			directory = uploadDirectory + profileMemberImagePath;				// 프로필 이미지 경우
			UUID randomUUID = UUID.randomUUID();
			fileName = randomUUID.toString() + "_" + originalFileName;
		}
		
		// 업로드
        Path targetPath = Path.of(directory, fileName);
        byte[] fileBytes = file.getBytes();
        Files.write(targetPath, fileBytes);
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
	public String getProfileImagePath() {
		Path path = Path.of(profileMemberImagePath, fileName);
		return path.toString();
	}
}
