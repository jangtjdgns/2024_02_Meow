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
	    				<tr class="text-center">
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
	    			$('.request-body').append(request);
	    			$('.request-body').append(request);
	    		}
	    	}
	    	
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
	
	$(function(){
		// $('#request-container thead').
		var element = $('#request-container thead');
		var offset = element.offset();
		
		$(".t-head>div").css('width', element.width() - 20);
		
		$('#request-container>div').on('scroll', function() {
		    if($(this).scrollTop() >= element.height()) {
		    	$(".t-head").removeClass('-translate-y-14');
		    	$(".t-head").addClass('translate-y-3');
		    } else {
		    	$(".t-head").addClass('-translate-y-14');
		    	$(".t-head").removeClass('translate-y-3');
		    }
		});
	})
</script>

<div id="request-container" class="w-full h-full p-4 overflow-y-hidden relative">
	<div class="t-head absolute left-1/2 -translate-x-1/2 h-10 -translate-y-14 z-20 bg-white border flex items-center shadow" style="transition: transform .4s">
		<div class="grid text-xs text-center text-gray-500 font-bold"
			style="grid-template-columns: 56px 288px 288px 1fr 1fr 96px 96px">
			<div>번호</div>
			<div>요청일</div>
			<div>응답일</div>
			<div>요청자(번호)</div>
			<div>응답자(번호)</div>
			<div>응답상태</div>
			<div>관련 항목</div>
		</div>
	</div>
	<div class="border h-full overflow-y-auto">
		<table class="table text-center">
			<thead>
				<tr class="text-center h-10">
					<th class="w-14">번호</th>
					<th class="w-72">요청일</th>
					<th class="w-72">응답일</th>
					<th class="">요청자(번호)</th>
					<th class="">응답자(번호)</th>
					<th class="w-24">응답상태</th>
					<th class="w-24">관련 항목</th>
				</tr>
			</thead>
			
			<tbody class="request-body">
				<tr><th class="text-center" colspan=8>현재 조회되는 요청기록이 없습니다.</th></tr>
			</tbody>
		</table>
	</div>
</div>