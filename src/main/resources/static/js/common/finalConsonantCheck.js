/**
 * 받침 확인 js
 */

 // 마지막 글자가 받침을 가지는지 확인하는 함수
function hasFinalConsonant(word) {
  	if (typeof word !== 'string') return null;
 
  	let lastLetter = word[word.length - 1];			// 마지막 글자만 추출
  	let uni = lastLetter.charCodeAt(0);				// 마지막 글자 유니코드 변환
 
  	if (uni < 44032 || uni > 55203) return null;	// 검증
 
  	return (uni - 44032) % 28 != 0;					// 종성(28개)을 제외한 나머지를 반환
}

// 받침에 따른 조사, 보조사 반환
function msgByFinalConsonant(name, idx){
	switch(idx) {
		case 0: return hasFinalConsonant(name) ? '은' : '는';	// 이는 || 는
		case 1: return hasFinalConsonant(name) ? '이를' : '를';
		// 필요에 따라 추가 예정
	}
}