
// 날짜 및 시간 특정 부분 가져오기
function getCurrentDateTimePart(type){
	const date = new Date();
	
	let dateVal;
	
	switch(type) {
		case 'year':
			dateVal = date.getFullYear();
			break;
		case 'month':
			dateVal = date.getMonth() + 1;
			break;
		case 'day':
			dateVal = date.getDate();
			break;
		case 'hours':
			dateVal = date.getHours();
			break;
		case 'minutes':
			dateVal = date.getMinutes();
			break;
		case 'second':
			dateVal = date.getSeconds();
			break;
	}
	
	return dateVal < 10 ? '0' + dateVal : dateVal;
}

// 날짜&시간 데이터를 ISO 8601 형식(ex. 2024-01-01T13:00:00)으로 변환하는 함수 (캘린더에서 사용)
function formatToISODateTime() {
	
}

// 시간차 계산 (요청 시간)
function getTimeDiff(time) {
    let timeDiffSec;
    const minute = 60;				// 분
    const hour = 60 * minute;		// 시간
    const day = 24 * hour;			// 일

	timeDiffSec = parseInt(time / minute)+ "분 전";
	
	if (time >= hour) {
        timeDiffSec = parseInt(time / hour) + "시간 전";
    }
    
    if (time >= day) {
        timeDiffSec = parseInt(time / day) + "일 전";
    }

    return timeDiffSec;
}


// 날짜 기준으로 나이 구하기
function getAgeByDate(date) {
	let birthDate = new Date(date);	// 생일, 2000-01-01
	let curDate = new Date();		// 현재 날짜
	
	let timeDiff = Math.abs(curDate.getTime() - birthDate.getTime());		// 현재시간 - 생일
	let daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));				// timeDiff를 일수로 바꿈
	let yearsDiff = Math.ceil(daysDiff / 365);								// daysDiff를 365로 나눠 나이를 계산
	
	return yearsDiff;
}

// 현재 날짜와 등록한 날짜의 일 수 구하기(아직 사용은 안함)
function getCalcDateDiffInDays(date){
	let getDate = new Date(date);
	let curDate = new Date();
	
	let timeDiff = Math.abs(curDate.getTime() - getDate.getTime());
	let daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
	
	return daysDiff;
}


/**
 * [자정 기준, 조회수 쿠키 제거 함수]
 * - 브라우저를 닫거나, 서버가 꺼져있는 경우에서 자정이 될때 초기화 불가능
 * - 서버에서도 자정에 쿠키를 제거하는 로직을 구현하면 좋을듯
 * */
deleteCookieAtMidnight();
function deleteCookieAtMidnight() {
	
    let curDate = new Date();
    let midnight = new Date(curDate);
    midnight.setHours(24, 0, 0, 0); // 자정으로 설정
    
    // 자정과 현재 시간 간격
    let timeUntilMidnight = midnight.getTime() - curDate.getTime();
    
    // 현재 시간이 자정 시간보다 큰 경우 다음날 자정으로 설정
    if (timeUntilMidnight < 0) {
        timeUntilMidnight += 24 * 60 * 60 * 1000; 	// 24시간을 더함
    }
    
    setTimeout(function() {
        document.cookie = 'hitCnt' + '=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        deleteCookieAtMidnight();
    }, timeUntilMidnight);
}