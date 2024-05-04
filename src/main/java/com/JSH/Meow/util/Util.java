package com.JSH.Meow.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Util {

	// String - null, blank check
	public static boolean isEmpty(String str) {

		if (str == null) {
			return true;
		}

		return str.trim().length() == 0;
	}
	
	public static boolean isEmpty(Integer num) {
		
		return num == null;
	}

	// String foramt
	public static String f(String format, Object... args) {
		return String.format(format, args);
	}

	// js, history.back()
	public static String jsHistoryBack(String msg) {

		if (msg == null) {
			msg = "";
		}

		return Util.f("""
					<script>
						const msg = '%s'.trim();

						if (msg.length > 0) {
							alert(msg);
						}

						history.back();
					</script>
				""", msg);
	}

	// js, location.replace()
	public static String jsReplace(String msg, String uri) {

		if (msg == null) {
			msg = "";
		}

		if (uri == null) {
			uri = "";
		}

		return Util.f("""
					<script>
						const msg = '%s'.trim();
						if (msg.length > 0) {
							alert(msg);
						}

						location.replace('%s');
					</script>
				""", msg, uri, uri);
	}

	// datetime format
	public static String formattedDatetime(String date) {
		DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yy.MM.dd.(E) HH:mm");
		LocalDateTime dateTime = LocalDateTime.parse(date, inputFormatter);
		return dateTime.format(outputFormatter);
	}
	
	// 지도에 마커 표시용
	public static String convertAddressJsonToString(String address) {
        ObjectMapper objectMapper = new ObjectMapper();
        
        try {
            // JSON 문자열을 JsonNode로 파싱
            JsonNode jsonNode = objectMapper.readTree(address);
            
            // 필요한 정보 추출
            address = "";
            address += jsonNode.get("sido").asText();
            address += jsonNode.get("bname").asText();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return address;
	}
	
	// Json 데이터를 Map 타입으로 변환
	public static Map<String, Object> jsonToMap(String jsonData) {
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, Object> mapData = null;
        try {
        	mapData = objectMapper.readValue(jsonData, Map.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
		return mapData;
	}
}
