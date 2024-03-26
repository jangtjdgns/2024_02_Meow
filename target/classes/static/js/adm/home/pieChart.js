/**
 * 토스트 UI 파이 차트 js
 */

// 파이 차트 데이터
let pieChartData = {
	categories: ['회원 상태'],
	series: [
    	{
    		id: 0,
      		name: '활동',
      		data: 0,
    	},
    	{
    		id: 1,
      		name: '정지',
      		data: 0,
    	},
    	{
    		id: 2,
      		name: '휴면',
      		data: 0,
    	},
    	{
    		id: 3,
      		name: '탈퇴',
      		data: 0,
    	},
    	{
    		id: 4,
    		name: '강제 탈퇴',
    		data: 0,
		},
	]
};

const today = `\${getDateTime('year')}.\${getDateTime('month')}.\${getDateTime('day')}.`
let options = {
	chart: {title: '회원 상태 현황'},
	series: {
	    dataLabels: {
	      	visible: true,
	      	anchor: 'outer'
	    }
	}
};

// 회원 상태 현황 가져와서 차트 데이터에 저장
const getStatus = function(){
	$.ajax({
		url: '/adm/member/getStatus',
	    method: 'GET',
	    dataType: 'json',
	    success: function(data) {
	    	let sum = 0;
	    	
	    	const status = data.data;
	    	
	    	for(let i = 0; i < pieChartData.series.length; i++) {
	    		for(let j = 0; j < status.length; j++) {
		    		if(pieChartData.series[i].id == status[j].status) {
		    			sum += status[j].count;
		    			pieChartData.series[i].name += '(' + status[j].count + ')';
		    			pieChartData.series[i].data += status[j].percent;
		    			break;
		    		}
	    		}
	    	}
	    	
	    	// pi 차트 생성 및 렌더링
	    	options.chart.title += '(' + sum + ')'
			const pieChart = document.getElementById('pieChart');
			new toastui.Chart.pieChart({ el: pieChart, data: pieChartData, options: options });
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
		complete: function() {
            setTimeout(getStatus, 10 * 60 * 1000);
        },
        timeout: 10 * 60 * 1000
	});
}


$(function(){
	getStatus();
})