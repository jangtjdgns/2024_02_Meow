package com.JSH.Meow.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256 {
	private String encrypt(String text) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(text.getBytes());

        return bytesToHex(md.digest());
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder builder = new StringBuilder();
        for (byte b : bytes) {
            builder.append(String.format("%02x", b));
        }
        return builder.toString();
    }
    
    public boolean passwordsNotEqual(String loginPw, String confirmPw) throws NoSuchAlgorithmException {
    	
    	//비밀번호 불일치 여부
		/* System.out.println(!confirmPw.equals(encrypt(loginPw))); */
	    
    	if(!confirmPw.equals(encrypt(loginPw))) {
    		return true; 
    	}
    	
    	return false;
    }
}
