package com.JSH.Meow.component;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.JSH.Meow.util.Util;

import lombok.Getter;

@Component
public class UploadComponent {
	
	// 기본 업로드 경로
	@Value("${upload.directory.default}")
    @Getter
    private String uploadDirectory;
	
	// 게시글 이미지 업로드 경로
	@Value("${upload.directory.article}")
	private String articleImagePath;
	
	// 회원 프로필 이미지 업로드 경로
	@Value("${upload.directory.profile.member}")
	private String profileMemberImagePath;
	
	// 반려묘 프로필 이미지 업로드 경로
	@Value("${upload.directory.profile.cat}")
	private String profileCompanionCatImagePath;
	
	@Getter
	private String fileName;
	
	
	// 파일 업로드
	public void uploadFile(MultipartFile file, String type) throws IOException {
		String directory = null;
		String originalFileName = Util.removeSpaces(file.getOriginalFilename());
		
		// 프로필 이미지 타입 확인 후 경로 지정
		if(isImageTypeValid(file)) {
			// 타입에 따라서 경로 설정(member, companionCat)
			directory = uploadDirectory + filePath(type);
			UUID randomUUID = UUID.randomUUID();
			fileName = randomUUID.toString() + "_" + originalFileName;
		}
		
		// 업로드
		try {
	        Path targetPath = Path.of(directory, fileName);
	        byte[] fileBytes = file.getBytes();
	        Files.write(targetPath, fileBytes);
	    } catch (IOException e) {
	        throw new IOException("파일 업로드 실패: " + e.getMessage());
	    }
    }
	
	
	// 파일 경로
	private String filePath(String type) {
		switch(type) {
		case "article":
			return articleImagePath;
		case "member":
			return profileMemberImagePath;
		case "companionCat":
			return profileCompanionCatImagePath;
		}
		
		return "";
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
		Path path = Path.of(filePath(type), fileName);
		
		return path.toString().replace("\\", "/");
	}
}
