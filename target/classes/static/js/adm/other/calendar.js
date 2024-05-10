/**
 * 토스트 UI 캘린더 js
 */

 //캘린더를 저장할 변수 (전역)
var calendar;

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
	
    if (view === 'month') {
        const fdt = dateTimeToObject(calendar.getDate());
        startText = `${fdt.year}년 ${fdt.month}월`;
    } else if (view === 'week') {
        startText = `${formatDate(dateTimeToObject(calendar.getDateRangeStart()), 1)} ~ `;
        endText = formatDate(dateTimeToObject(calendar.getDateRangeEnd()), 1);
    } else if (view === 'day') {
        startText = formatDate(dateTimeToObject(calendar.getDate()), 1);
    }
    dateRangeTag.text(startText + endText);		// 날짜 범위 표시
}

// 지정한 날짜가 동일한지 확인 (일정 생성시), 동일하면 경고
function checkDateEquality(e) {
	if(e.start === e.end) {
		alertMsg('<span class="text-sm">정확한 <strong>시작일</strong>과 <strong>종료일</strong>을 설정해주세요.</span>', 'warning');
	}
}

// 등록된 일정 표시
function showEvnet() {
	$.ajax({
		url: '/adm/calendar/getEvents',
	    method: 'get',
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
	    		        state: event.stateName,
	    		        isPrivate: event.private,
	    		        attendees: [loginedMemberNickname],
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

// 일정 등록
function createEvent(eventObj) {
	eventObj.start = formatDateTime(dateTimeToObject(eventObj.start.d.d), 1);
	eventObj.end = formatDateTime(dateTimeToObject(eventObj.end.d.d), 1);
	eventObj.memberId = loginedMemberId;	// 회원 번호를 객체에 추가
	
	$.ajax({
		url: '/adm/calendar/createEvent',
	    method: 'POST',
	    data: {
	    	eventJson: JSON.stringify(eventObj),
	    },
	    dataType: 'json',
	    success: function(data) {
	    	if(data.success) {
	    		// 이벤트 ID
	    		const id = data.data;
	    		// 일정 생성 메서드 (인스턴스 메서드) 
	    		calendar.createEvents([
					{
				      ...eventObj,
				      id: id,
				      attendees: [loginedMemberNickname],
				    },
				]);
	    		alertMsg(data.msg, 'success');
	    	}
	    	checkDateEquality(eventObj);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

// 일정 변경
function updateEvent(eventObj) {
	
	// 변경사항이 없으면 return
	if(Object.keys(eventObj.changes).length === 0) {
		return alertMsg('변경사항이 없습니다.', 'warning');
	}
	
	const id = eventObj.event.id;				// eventId, 일정 ID
	const calId = eventObj.event.calendarId;	// calendarId, 캘린더 목록 ID
	
	// hasOwnProperty, 해당 속성 존재여부 확인
	eventObj.changes.hasOwnProperty('start') ? eventObj.changes.start = formatDateTime(dateTimeToObject(eventObj.changes.start.d.d), 1) : null;
	eventObj.changes.hasOwnProperty('end') ? eventObj.changes.end = formatDateTime(dateTimeToObject(eventObj.changes.end.d.d), 1) : null;
	
	$.ajax({
		url: '/adm/calendar/updateEvent',
	    method: 'POST',
	    data: {
	    	id: id,
	    	eventJson: JSON.stringify(eventObj.changes),
	    },
	    dataType: 'json',
	    success: function(data) {
	    	if(data.success) {
	    		// 일정 수정 메서드 (인스턴스 메서드)
	    		calendar.updateEvent(id, calId, {
	    			  ...eventObj.changes,
	    		});
	    		
	    		alertMsg(data.msg, 'success');
	    	}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}

// 일정 삭제
function deleteEvent(eventObj) {
	$.ajax({
		url: '/adm/calendar/deleteEvent',
	    method: 'GET',
	    data: {
	    	id: eventObj.id,
	    },
	    dataType: 'json',
	    success: function(data) {
	    	if(data.success) {
	    		// 일정 삭제 메서드 (인스턴스 메서드)
	    		calendar.deleteEvent(eventObj.id, eventObj.calendarId);
	    		alertMsg(data.msg, 'error');
	    	}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}


// 로드 후
$(function(){
	
	// 영문요일 한글로 변경
	const dayEngToKor = day => ({ 0: '일', 1: '월', 2: '화', 3: '수', 4: '목', 5: '금', 6: '토' })[day];
	
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
		template: {
			popupIsAllday() { return '하루 종일' },
			popupStateFree() { return '자유' },
			popupStateBusy() { return '바쁨' },
			titlePlaceholder() { return '제목' },
			locationPlaceholder() { return '장소' },
			startDatePlaceholder() { return '시작일' },
			endDatePlaceholder() { return '종료일' },
			popupSave() { return '등록' },
			popupUpdate() { return '변경' },
			popupEdit() { return '수정' },
			popupDelete() { return '삭제' },
			monthGridHeaderExceed(hiddenEvents) { return `<span class="text-sm hover:text-black">+${hiddenEvents}</span>` },
			milestoneTitle() {return `<span class="flex justify-end items-center [font-size:11px] [height:72px]">마일스톤</span>` },
			taskTitle() { return `<span class="flex justify-end items-center [font-size:11px] [height:72px]">작업</span>` },
			alldayTitle() { return `<span class="flex justify-end items-center [font-size:11px] [height:72px]">하루 일정</span>` },
			monthMoreTitleDate: moreTitle => `<span class="toastui-calendar-more-title-date">${moreTitle.date}</span> <span class="toastui-calendar-more-title-day">${dayEngToKor(moreTitle.day)}</span>`,
			monthDayName: model => dayEngToKor(model.day),
			weekDayName: model => `<span class="text-2xl">${model.date}</span>&nbsp;&nbsp;<span>${dayEngToKor(model.day)}</span>`,
  		},
	  	useFormPopup: true,		// 일정 생성 팝업
	  	useDetailPopup: true,	// 일정 상세 팝업
	};
	
	// 캘린더 생성
	calendar = new Calendar(container, options)
	// 테마 설정
	calendar.setTheme({
		// 토요일 색상 변경 (기본색 없음, 구분되게 파란색으로 설정)
	  	common: {
	    	saturday: {
	      		color: 'rgba(64, 64, 255, 0.8)',
	    	},
	  	},
	  	// 월 기준, 더보기 팝업 커스텀 스타일
	  	month: {
		    moreView: {
		      	border: '1px solid grey',
		      	boxShadow: '0 2px 6px 0 grey',
	      		backgroundColor: 'white',
		      	width: 320,
		      	height: 200,
		    },
  		},
	});
	
	setDateRange();		// 캘린더 날짜 범위 표시
	showEvnet();		// 내 일정 표시
	
	// 인스턴스 이벤트 추가
	calendar.on({
		beforeCreateEvent: (eventObj) => { createEvent(eventObj) },		// 일정 생성
		beforeUpdateEvent: (eventObj) => { updateEvent(eventObj) },		// 일정 수정
		beforeDeleteEvent: (eventObj) => { deleteEvent(eventObj) }		// 일정 삭제
	});
})