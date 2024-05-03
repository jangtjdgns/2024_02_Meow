<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
	/* function createEvents() {
		
	} */
	$(function(){
		const container = document.getElementById('calendar');
		const options = {
		  defaultView: 'month',
		  timezone: {
		    zones: [
		      {
		        timezoneName: 'Asia/Seoul',
		        displayLabel: 'Seoul',
		      },
		      {
		        timezoneName: 'Europe/London',
		        displayLabel: 'London',
		      },
		    ],
		  },
		  calendars: [
		    {
		      id: 'cal1',
		      name: '개인',
		      backgroundColor: '#03bd9e',
		    },
		    {
		      id: 'cal2',
		      name: '직장',
		      backgroundColor: '#00a9ff',
		    },
		  ],
		};
		
		const calendar = new Calendar(container, options)
		
		calendar.createEvents([
			{
			    id: 'event1',
			    calendarId: 'cal2',
			    title: '주간 회의',
			    start: '2024-05-03T13:00:00',
			    end: '2024-05-03T14:00:00',
			},
			{
			    id: 'event2',
			    calendarId: 'cal1',
			    title: '점심 약속',
			    start: '2024-05-04T12:00:00',
			    end: '2024-05-04T13:00:00',
			},
			{
				id: 'event3',
				calendarId: 'cal2',
				title: '휴가',
				start: '2024-05-04',
				end: '2024-05-04',
				isAllday: true,
				category: 'allday',
			},
		]);
		
		calendar.setOptions({
		  useFormPopup: true,
		  useDetailPopup: true,
		});
		
		/* calendar.setTheme({
		  common: {
		    gridSelection: {
		      backgroundColor: 'rgba(81, 230, 92, 0.05)',
		      border: '1px dotted #515ce6',
		    },
		  },
		}); */
		
		$('.toastui-calendar-popup-confirm').click(function(){
			console.log('hi');
		})
	})
</script>

<div id="calendar" class="[min-height:600px] h-full"></div>