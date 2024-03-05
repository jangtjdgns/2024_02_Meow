package com.JSH.Meow.config.component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;

@Component
public class UploadComponent {
	
	@Value("${upload.directory}")
    @Getter
    private String uploadDirectory;
	
	@Getter
	private String filePath;
	
	public boolean isImageTypeValid(MultipartFile image) {
		String imagePath = "image/";
		String[] supportedExt = {"jpg", "jpeg", "png", "gif"};
		
		String imageType = image.getContentType();
		
		for(int i = 0; i < supportedExt.length; i++) {
			if(imagePath.concat(supportedExt[i]).equals(imageType)) {
				return true;
			}
		}
		return false;
	}
	
	public void uploadFile(MultipartFile file) throws IOException {
		String directory = null;
		String originalFileName = file.getOriginalFilename();
		String fileName = null;
		
		// 이미지 파일인지 확인
		if(isImageTypeValid(file)) {
			directory = uploadDirectory + "/profile/member";
			UUID randomUUID = UUID.randomUUID();
			fileName = randomUUID.toString() + "_" + originalFileName;
		}
		
        Path targetPath = Path.of(directory, fileName);
        filePath = targetPath.toString();
        Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
    }
}
