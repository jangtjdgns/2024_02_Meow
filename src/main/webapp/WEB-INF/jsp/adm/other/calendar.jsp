<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
	//캘린더를 저장할 변수 (전역)
	var calendar;
	var eventId = 1;	// 삭제 할 예정
	
	// 캘린더 view 변경
	function onChangeView(select) {
		calendar.changeView($(select).val());
		setDateRange();
	}
	
	// 캘린더 현재 날짜로 이동
	function onClickTodayBtn() {
		calendar.today();
		setDateRange();
	}
	
	// 캘린더 이전 또는 다음 날 이동
	function moveToNextOrPrevRange(offset) {
  		if (offset === -1) {
    		calendar.prev();
  		} else if (offset === 1) {
    		calendar.next();
  		}
  		setDateRange();
	}
	
	// 캘린더 날짜 범위 표시
	function setDateRange() {
	    const view = calendar.getViewName();
	    const dateRangeTag = $('.date-range');
	    let startText = '';		// 시작일
	    let endText = '';		// 종료일
	    const formatDate = (fdt) => `\${fdt.year}년 \${fdt.month}월 \${fdt.day}일`;	// fdt, format Date Time
		
	    if (view === 'month') {
	        const fdt = getformatDateTime(calendar.getDate());
	        startText = `\${fdt.year}년 \${fdt.month}월`;
	    } else if (view === 'week') {
	        const startFdt = getformatDateTime(calendar.getDateRangeStart());
	        startText = `\${formatDate(startFdt)} ~ `;
	        const endFdt = getformatDateTime(calendar.getDateRangeEnd());
	        endText = formatDate(endFdt);
	    } else if (view === 'day') {
	        const fdt = getformatDateTime(calendar.getDate());
	        startText = formatDate(fdt);
	    }
	    dateRangeTag.text(startText + endText);		// 날짜 범위 표시
	}
	
	// 지정한 날짜가 동일한지 확인 (생성 | 수정 시), 동일하면 경고
	function checkDateEquality(e) {
		if(e.start.d.d.toString() === e.end.d.d.toString()) {
			alertMsg('<span class="text-sm">정확한 <strong>시작일</strong>과 <strong>종료일</strong>을 설정해주세요.</span>', 'warning');
		}
	}
	
	// 기존 일정 나타내기
	function showEvnet() {
		$.ajax({
			url: '/adm/calendar/getEvents',
		    method: 'POST',
		    data: {
		    	memberId: loginedMemberId,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	if(data.success) {
		    		const events = data.data;
		    		const eventsArr = [];
		    		for(let i = 0; i < events.length; i++) {
		    			const event = events[i];
		    			eventsArr.push({
		    		        id: event.id,
		    		        calendarId: event.calendarId,
		    		        title: event.title,
		    		        start: event.startDate,
		    		        end: event.endDate,
		    		        isAllday: event.allday,
		    		        location: event.location,
		    		        state: event.state,
		    		        isPrivate: event.private,
		    		    });
		    		}
		    		calendar.createEvents(eventsArr);
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
	
	
	// DB 일정 생성
	function createEvent(eventObj) {
		$.ajax({
			url: '/adm/calendar/createEvent',
		    method: 'POST',
		    data: {
		    	calendarId: eventObj.calendarId,
		    	startDate: eventObj.start.d.d.toISOString().slice(0, -6),
				endDate: eventObj.end.d.d.toISOString().slice(0, -6),
				memberId: loginedMemberId,
				title: eventObj.title,
				isAllday: eventObj.isAllday,
				location: eventObj.location,
				state: eventObj.state,
				isPrivate: event.isPrivate,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
	
	
	// 로드 후
	$(function(){
		// 캘린더가 표시될 컨테이너(태그)
		const container = document.getElementById('calendar');
		// 캘린더 옵션 설정
		const options = {
			// 기본 뷰 속성
			defaultView: 'month',
		 	// 타임존 속성
		  	timezone: {
		    	zones: [
		      		{
		        		timezoneName: 'Asia/Seoul',
		        		displayLabel: '서울',
		      		},
		      		{
		        		timezoneName: 'Europe/London',
		        		displayLabel: '런던',
		      		},
		    	],
		  	},
		 	// 캘린더 목록 속성
	  		calendars: [
		    	{
		      		id: 'cal1',
		      		name: '😊개인',
		     		backgroundColor: 'limegreen',
		    	},
		    	{
		      		id: 'cal2',
		      		name: '🏢직장',
		      		backgroundColor: 'deepskyblue',
		    	},
		    	{
		      		id: 'cal3',
		      		name: '🎉기념일',
		      		backgroundColor: 'violet',
		    	},
		  	],
		  	useFormPopup: true,		// 일정 생성 팝업
		  	useDetailPopup: true,	// 일정 상세 팝업
		};
		
		// 캘린더 생성
		calendar = new Calendar(container, options)
		// 캘린더 날짜 범위 표시
		setDateRange();
		// 토요일 색상 변경 (기본색 없음, 구분되게 파란색으로 설정)
		calendar.setTheme({
		  	common: {
		    	saturday: {
		      		color: 'rgba(64, 64, 255, 0.8)',
		    	},
		  	},
		});
		
		showEvnet();
		
		
		/* 객체 리터럴로 바꿔도 좋을듯 */
		// 일정 생성 이벤트 추가 (인스턴스 이벤트)
		calendar.on('beforeCreateEvent', (eventObj) => {
			// 일정 생성 메서드 (인스턴스 메서드)
			calendar.createEvents([
				{
			      ...eventObj,
			      id: 'event' + eventId,
			    },
			]);
			const getEvnet = calendar.getEvent('event' + eventId++, eventObj.calendarId);
			createEvent(eventObj);
			checkDateEquality(eventObj)
		});
		
		// 일정 수정 이벤트 추가 (인스턴스 이벤트)
		calendar.on('beforeUpdateEvent', (eventObj) => {
			const id = eventObj.event.id;
			const calId = eventObj.event.calendarId;
			// 일정 수정 메서드 (인스턴스 메서드)
			calendar.updateEvent(id, calId, {
				  ...eventObj.changes,
			});
			// checkDateEquality(calendar.getEvent(id, calId));
		});
		
		// 일정 삭제 이벤트 추가 (인스턴스 이벤트)
		calendar.on('beforeDeleteEvent', (eventObj) => {
			// 일정 삭제 메서드 (인스턴스 메서드)
			calendar.deleteEvent(eventObj.id, eventObj.calendarId);
			alertMsg('삭제되었습니다.', 'error');
		});
		
		/* calendar.createEvents([
			{
			    id: 'event1',
			    calendarId: 'cal1',
			    title: '점심 약속',
			    start: '2024-05-03T12:00:00',
			    end: '2024-05-03T13:00:00',
			},
			{
			    id: 'event2',
			    calendarId: 'cal2',
			    title: '주간 회의',
			    start: '2024-05-03T13:00:00',
			    end: '2024-05-03T14:00:00',
			},
			{
				id: 'event3',
				calendarId: 'cal1',
				title: '여행',
				start: '2024-05-04',
				end: '2024-05-04',
				isAllday: true,
				category: 'allday',
			},
			{
				id: 'event4',
				calendarId: 'cal2',
				title: '휴가',
				start: '2024-05-04',
				end: '2024-05-04',
				isAllday: true,
				category: 'allday',
			},
		]); */
	})
</script>
<div class="grid h-full" style="grid-template-rows: 4rem 1fr">
	<div class="flex items-center justify-between">
		<!-- navbar -->
		<nav class="navbar gap-2">
			<select class="select select-bordered select-sm change-view" autocomplete="off" onchange="onChangeView(this)">
				<option value="month" selected>월</option>
				<option value="week">주</option>
				<option value="day">일</option>
			</select>
			<button class="btn btn-sm today" onclick="onClickTodayBtn()">오늘</button>
			<button class="btn btn-sm btn-circle prev" onclick="moveToNextOrPrevRange(-1)"><i class="fa-solid fa-angle-left"></i></button>
			<button class="btn btn-sm btn-circle next" onclick="moveToNextOrPrevRange(1)"><i class="fa-solid fa-angle-right"></i></button>
			<span class="date-range"></span>
		</nav>
		<div class="w-96 flex justify-end pr-4 text-xl"><span class="font-bold">${rq.loginedMemberNickname }</span>&nbsp;님의 캘린더</div>
	</div>
	
	<!-- calendar -->
	<div id="calendar" class="[min-height:600px] h-full"></div>
</div>