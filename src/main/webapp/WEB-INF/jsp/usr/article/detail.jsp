<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../common/header.jsp"%>

<!-- dompurify -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/dompurify/2.3.0/purify.min.js"></script>

<!-- 토스트 UI 에디터 코어 -->
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

<!-- 토스트 UI 에디터 플러그인, 컬러피커 -->
<link rel="stylesheet" href="https://uicdn.toast.com/tui-color-picker/latest/tui-color-picker.css" />
<script src="https://uicdn.toast.com/tui-color-picker/latest/tui-color-picker.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor-plugin-color-syntax/latest/toastui-editor-plugin-color-syntax.min.css" />
<script src="https://uicdn.toast.com/editor-plugin-color-syntax/latest/toastui-editor-plugin-color-syntax.min.js"></script>

<script>
	function ToastEditorView__init() {
	    const $initialValueEl = $("#body");
	    const initialValue = $initialValueEl.val();

	    var viewer = new toastui.Editor.factory({
	      	el: document.querySelector("#viewer"),
	      	initialValue: initialValue,
	      	viewer:true,
	      	plugins: [
	    	  toastui.Editor.plugin.colorSyntax,
	    	]
	    });
		
	    $("#viewer").data('viewer', viewer);
	}
	
	$(function(){
		ToastEditorView__init();
	})
</script>

<section>
	<textarea id="body" class="hidden">${article.body}</textarea>
	<div>${article.id }</div>
	<div>${article.regDate }</div>
	<div>${article.updateDate }</div>
	<div>${article.title }</div>
	<div id="viewer"></div>
	
	<div>
		<a href="doDelete?id=${article.id }" class="btn">삭제</a>
		<a href="modify?id=${article.id }" class="btn">수정</a>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>