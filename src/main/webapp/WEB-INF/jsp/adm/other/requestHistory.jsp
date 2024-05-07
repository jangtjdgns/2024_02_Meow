<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
	$.ajax({
		url: '/adm/reqRes/reqHistory',
	    method: 'get',
	    data: {
	    },
	    dataType: 'json',
	    success: function(data) {
	    	
	    	if(data.success) {
	    		$('.request-body').empty();
	    		
	    		const requests = data.data;
	    		
	    		for(let req of requests) {
	    			let statusColor = '';
	    			
	    			if(req.status == 'refuse') {
	    				statusColor = 'red';
	    			} else if(req.status == 'accepted') {
	    				statusColor = 'green'
	    			} else if(req.status == 'pending') {
	    				statusColor = 'blue';
	    			} else {
	    				statusColor = 'black';
	    			}
	    			
	    			let request = `
	    				<tr>
	    					<td>\${req.id}</td>
	    					<td>\${req.requestDate}</td>
	    					<td>\${req.responseDate == null ? '-' : req.responseDate}</td>
	    					<td>\${req.requesterNickname}</td>
	    					<td>\${req.recipientNickname}</td>
	    					<td class="text-\${statusColor}-600">\${req.statusName}</td>
	    					<td>\${req.codeName}</td>
	    				</tr>
	    			`;
	    			
	    			$('.request-body').append(request);
	    		}
	    	}
	    	
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
</script>

<div id="request-container" class="w-full h-full p-4 overflow-y-auto">
	<table class="table text-center">
		<thead>
			<tr class="text-center">
				<th class="w-8">번호</th>
				<th class="w-52">요청일</th>
				<th class="w-52">응답일</th>
				<th>요청자(번호)</th>
				<th>응답자(번호)</th>
				<th>응답상태</th>
				<th>관련 항목</th>
			</tr>
		</thead>
		
		<tbody class="request-body">
			<tr><th class="text-center" colspan=8>현재 조회되는 요청기록이 없습니다.</th></tr>
		</tbody>
	</table>
</div>