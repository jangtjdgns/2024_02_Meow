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

import jakarta.servlet.http.HttpServletRequest;

@Service
public class SnsInfoService {
	
	private SnsInfoDao snsInfoDao;
	
	public SnsInfoService(SnsInfoDao snsInfoDao) {
		this.snsInfoDao = snsInfoDao;
	}
	
	public void saveSnsMemberInfo(String snsId, String snsType, int memberId, String name, String mobile, String email) {
		snsInfoDao.saveSnsMemberInfo(snsId, snsType, memberId, name, mobile, email);
	}

	public String getSnsTypeBymemberId(int memberId) {
		return snsInfoDao.getSnsTypeBymemberId(memberId);
	}
}
