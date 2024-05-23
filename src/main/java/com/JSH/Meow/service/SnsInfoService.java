package com.JSH.Meow.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.JSH.Meow.dao.SnsInfoDao;
import com.JSH.Meow.vo.SnsInfo;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class SnsInfoService {
	
	private SnsInfoDao snsInfoDao;
	
	public SnsInfoService(SnsInfoDao snsInfoDao) {
		this.snsInfoDao = snsInfoDao;
	}
	// 삭제 예정
	/*
	public void saveSnsMemberInfo(String snsId, String snsType, int memberId, String name, String mobile, String email) {
		snsInfoDao.saveSnsMemberInfo(snsId, snsType, memberId, name, mobile, email);
	}
	*/
	public String getSnsTypeByMemberId(int memberId) {
		return snsInfoDao.getSnsTypeByMemberId(memberId);
	}

	public SnsInfo getSnsInfoBySnsId(String snsId) {
		return snsInfoDao.getSnsInfoBySnsId(snsId);
	}

	public void saveSnsMemberInfo(SnsInfo snsInfo) {
		snsInfoDao.saveSnsMemberInfo(snsInfo.getSnsId(), snsInfo.getSnsType(), snsInfo.getMemberId()
				, snsInfo.getName(), snsInfo.getMobile(), snsInfo.getEmail(), snsInfo.getProfileImage());
	}
}
