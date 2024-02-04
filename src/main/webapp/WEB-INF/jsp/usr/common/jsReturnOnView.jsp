<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	let msg = '${msg }'.trim();
	
	console.log(msg);
	
	if(msg) {
		alert(msg);
	}
	
	history.back();
</script>