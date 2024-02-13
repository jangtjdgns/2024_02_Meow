package com.JSH.Meow.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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
}
