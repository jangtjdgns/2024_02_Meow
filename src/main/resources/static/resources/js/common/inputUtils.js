// input과 관련된 유틸리티

// form 관련 input, textarea 태그의 값이 변경될 때를 감지하는 이벤트 함수
function bindFormInputEvent(selector, errorClass) {
    $(selector).change(function () {
        $(this).removeClass(errorClass);
        if ($(this).val().trim().length == 0) {
            $(this).addClass(errorClass);
        }
    });
}