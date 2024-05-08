/**
 * 요청 기록 js
 */

 // 요청 기록 표시
	function showReqHistory() {
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
		    					<td class="w-14">${req.id}</td>
		    					<td>${req.requestDate}</td>
		    					<td>${req.responseDate == null ? '-' : req.responseDate}</td>
		    					<td>${req.requesterNickname}<span class="badge badge-sm badge-ghost ml-2">${req.requesterId}</span></td>
		    					<td>${req.recipientNickname}<span class="badge badge-sm badge-ghost ml-2">${req.recipientId}</span></td>
		    					<td class="text-${statusColor}-600">${req.statusName}</td>
		    					<td>${req.codeName}</td>
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
	}
	// 테이블 열(th) 제목 표시
	function showHideTitle() {
		const thead = $('#request-container thead');
		
		$(".t-head>div").css('width', thead.width() - 15);
		
		$('#request-container>div').on('scroll', function() {
		    if($(this).scrollTop() >= thead.height()) {
		    	$(".t-head").removeClass('-translate-y-16');
		    	$(".t-head").addClass('translate-y-3');
		    } else {
		    	$(".t-head").addClass('-translate-y-16');
		    	$(".t-head").removeClass('translate-y-3');
		    }
		});
	}
	
	$(function(){
		showReqHistory();
		showHideTitle();
		
		$(window).resize(function() {
			showHideTitle();
		});
		
		// 오름차순, 내림차순 정렬
		$('.sort-btn').click(function(){
			$('.sort-btn').prop('checked', $(this).prop('checked'));
			
			const tbodyTrRows = $('.request-body').find('tr'); 
			
			$('.request-body').empty();
			for(let i = tbodyTrRows.length - 1; i >= 0 ; i--) {
				const tr = tbodyTrRows[i];
				$('.request-body').append(tr);
			}
		})
	})