# 노션 MEOW
- [프로젝트 포트폴리오](https://www.notion.so/Meow-cb421fca444b4c51a9eac40d889e47cd?pvs=4)
<br/><br/><br/>


# Page Map
### 1. User Page
#### 1) 메인
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 메 인 | UsrHomeController | /usr/home/main.jsp | `/usr/home/main` |

#### 2) 로그인
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 로그인 | UsrMemberController | /usr/member/login.jsp | `/usr/member/login` |

#### 3) 회원가입
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 자체 회원가입 | UsrMemberController | /usr/member/join.jsp | `/usr/member/join` |
| SNS 회원가입 | OAuth2Controller | /usr/member/snsAuth.jsp | `/usr/member/oauth/signup/{snsType}` |

#### 4) 반려묘
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 내 반려묘 | UsrCompanionCatController | /usr/companionCat/view.jsp | `/usr/companionCat/view` |
| 반려묘 등록 | UsrCompanionCatController | /usr/companionCat/register.jsp | `/usr/companionCat/reigster` |
| 반려묘 수정 | UsrCompanionCatController | /usr/companionCat/modify.jsp | `/usr/companionCat/modify` |

#### 5) 게시판
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 게시글 목록 | UsrArticleController | /usr/article/list | `/usr/article/list` |
| 게시글 상세보기 | UsrArticleController | /usr/article/detail | `/usr/article/detail` |
| 게시글 작성 | UsrArticleController | /usr/article/write | `/usr/article/write` |
| 게시글 수정 | UsrArticleController | /usr/article/modify | `/usr/article/modify` |

#### 6) 고객센터
<p>${\textsf{\color{red}*}}$ AJAX 기반 동적 콘텐츠 로딩 방식 사용</p>

| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 메 인 | UsrCustomerCenterController | /usr/customerCenter/main.jsp | `/usr/customer/main` |
| 문 의 | UsrCustomerCenterController | /usr/customerCenter/write.jsp | `/usr/customer/main` |
| 접수내역 | UsrCustomerCenterController | /usr/customerCenter/write.jsp | `/usr/customer/main` |
| FAQ | UsrCustomerCenterController | /usr/customerCenter/faq.jsp | `/usr/customer/main` |
| 의견수렴 | UsrCustomerCenterController | /usr/customerCenter/feedback.jsp | `/usr/customer/main` |
| 바로가기 | UsrCustomerCenterController | /usr/customerCenter/allPages.jsp | `/usr/customer/main` |

#### 7) 프로필
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 내프로필 | UsrMemberController | /usr/member/profile.jsp | `/usr/member/profile` |

#### 8) 계정관리
<p>${\textsf{\color{red}*}}$ AJAX 기반 동적 콘텐츠 로딩 방식 사용</p>

| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 메 인 | UsrMemberController | /usr/member/userAccount.jsp | `/usr/member/userAccount` |
| 계정정보 수정 | UsrMemberController | /usr/member/modify.jsp | `/usr/member/userAccount` |
| 비밀번호 재설정 | UsrMemberController | /usr/member/resetLoginLogined.jsp | `/usr/member/userAccount` |
| 계정 탈퇴 | UsrMemberController | /usr/member/delete.jsp | `/usr/member/userAccount` |

#### 9) 계정찾기
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 아이디 찾기 | UsrMemberController | /usr/member/findLoginId.jsp | `/usr/find/loginId` |
| 비밀번호 재설정 | UsrMemberController | /usr/member/resetLoginPw.jsp | `/usr/reset/loginPw` |

#### 10) 채팅 팝업창
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 채팅창 | UsrChatController | /usr/common/chatPupUp.jsp | `/usr/chat/popUp` |

<br/><br/>

### 2. Admin Page
<p>${\textsf{\color{red}*}}$ 로그인 페이지를 제외한 모든 관리자 페이지는 AJAX 기반 동적 콘텐츠 로딩 방식을 사용합니다.</p>

#### 1) 관리자 로그인
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 로그인 | AdmMemberController | /adm/member/login.jsp | `/adm/member/login` |

#### 2) 메인
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 메 인 | AdmHomeController | /adm/home/main.jsp | `/adm/home/main` |

#### 3) 회원 관리
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 회원 목록 | AdmMemberController | /adm/memberManagement/list.jsp | `/adm/home/main` |
| 회원 신고 조치 | AdmReportController | /adm/common/report.jsp | `/adm/home/main` |

#### 4) 게시판 관리
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 게시글 목록 | AdmArticleController | /adm/articleManagement/list.jsp | `/adm/home/main` |
| 게시글 신고 조치 | AdmReportController | /adm/common/report.jsp | `/adm/home/main` |

#### 5) 댓글 관리
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 댓글 목록 | AdmReplyController | /adm/replyManagement/list.jsp | `/adm/home/main` |
| 댓글 신고 조치 | AdmReportController | /adm/common/report.jsp | `/adm/home/main` |

#### 6) 건의사항 및 문의 관리
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 접수 목록 | AdmCustomerCenterController | /adm/inquiryManagement/list.jsp | `/adm/home/main` |

#### 7) 지도
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 지역별 회원 목록 | AdmMemberController | /adm/map/showMap.jsp | `/adm/home/main` |

#### 8) 기타
| Page | Controller | JSP Path | `URL` Path |
| --- | --- | --- | --- |
| 일정 | AdmCalendarController | /adm/other/calendar.jsp | `/adm/home/main` |
| 요청기록 | ComReqResController | /adm/other/requestHistory.jsp | `/adm/home/main`|

<br/><br/><br/>

# 파일 트리
### 1. Server
```bash
📦java.com.JSH.Meow
 ┣ 📜MeowApplication.java
 ┣ 📜ServletInitializer.jav
 ┣ 📂component
 ┃ ┣ 📜GithubComponent.java
 ┃ ┣ 📜GoogleComponent.java
 ┃ ┣ 📜KakaoComponent.java
 ┃ ┣ 📜NaverComponent.java
 ┃ ┗ 📜UploadComponent.java
 ┣ 📂config
 ┃ ┣ 📜EnvConfig.java
 ┃ ┣ 📜MyWebMvcConfigurer.java
 ┃ ┗ 📜WebSocketConfig.java
 ┣ 📂controller
 ┃ ┣ 📜AdmArticleController.java
 ┃ ┣ 📜AdmCalendarController.java
 ┃ ┣ 📜AdmCompanionCatController.java
 ┃ ┣ 📜AdmCustomerCenterController.java
 ┃ ┣ 📜AdmHomeController.java
 ┃ ┣ 📜AdmMemberController.java
 ┃ ┣ 📜AdmReplyController.java
 ┃ ┣ 📜AdmReportController.java
 ┃ ┣ 📜ComReqResController.java
 ┃ ┣ 📜OAuth2Controller.java
 ┃ ┣ 📜UsrArticleController.java
 ┃ ┣ 📜UsrChatController.java
 ┃ ┣ 📜UsrCompanionCatController.java
 ┃ ┣ 📜UsrCustomerCenterController.java
 ┃ ┣ 📜UsrFriendController.java
 ┃ ┣ 📜UsrHomeController.java
 ┃ ┣ 📜UsrMemberController.java
 ┃ ┣ 📜UsrReactionController.java
 ┃ ┣ 📜UsrReplyController.java
 ┃ ┗ 📜UsrReportController.java
 ┣ 📂dao
 ┃ ┣ 📜ArticleDao.java
 ┃ ┣ 📜BoardDao.java
 ┃ ┣ 📜CalendarDao.java
 ┃ ┣ 📜ChatDao.java
 ┃ ┣ 📜CompanionCatDao.java
 ┃ ┣ 📜CustomerCenterDao.java
 ┃ ┣ 📜FriendDao.java
 ┃ ┣ 📜MemberDao.java
 ┃ ┣ 📜MemberDeletionDao.java
 ┃ ┣ 📜ReactionDao.java
 ┃ ┣ 📜ReplyDao.java
 ┃ ┣ 📜ReportDao.java
 ┃ ┣ 📜ReqResDao.java
 ┃ ┗ 📜SnsInfoDao.java
 ┣ 📂handler
 ┃ ┗ 📜SocketHandler.java
 ┣ 📂interceptor
 ┃ ┣ 📜AdminInterceptor.java
 ┃ ┣ 📜BeforeActionInterceptor.java
 ┃ ┣ 📜HttpSessionHandshakeInterceptor.java
 ┃ ┣ 📜NeedLoginInterceptor.java
 ┃ ┗ 📜NeedLogoutInterceptor.java
 ┣ 📂service
 ┃ ┣ 📜ArticleService.java
 ┃ ┣ 📜BoardService.java
 ┃ ┣ 📜CalendarService.java
 ┃ ┣ 📜ChatService.java
 ┃ ┣ 📜CompanionCatService.java
 ┃ ┣ 📜CustomerCenterService.java
 ┃ ┣ 📜EmailService.java
 ┃ ┣ 📜FriendService.java
 ┃ ┣ 📜MemberDeletionService.java
 ┃ ┣ 📜MemberService.java
 ┃ ┣ 📜OAuth2Service.java
 ┃ ┣ 📜ReactionService.java
 ┃ ┣ 📜ReplyService.java
 ┃ ┣ 📜ReportService.java
 ┃ ┣ 📜ReqResService.java
 ┃ ┣ 📜SnsInfoService.java
 ┃ ┗ 📜UploadService.java
 ┣ 📂util
 ┃ ┣ 📜SHA256.java
 ┃ ┗ 📜Util.java
 ┗ 📂vo
   ┣ 📂statistics
   ┃ ┣ 📜MemberStatus.java
   ┃ ┣ 📜ReplyStatus.java
   ┃ ┗ 📜text
   ┣ 📜Article.java
   ┣ 📜Board.java
   ┣ 📜Calendar.java
   ┣ 📜Chat.java
   ┣ 📜CompanionCat.java
   ┣ 📜CustomerFeedback.java
   ┣ 📜Email.java
   ┣ 📜Friend.java
   ┣ 📜Inquiry.java
   ┣ 📜Interval.java
   ┣ 📜Member.java
   ┣ 📜Reaction.java
   ┣ 📜Reply.java
   ┣ 📜Report.java
   ┣ 📜ReqRes.java
   ┣ 📜ResultData.java
   ┣ 📜Rq.java
   ┗ 📜SnsInfo.java
```

### 2. resources
```bash
📦resources
 ┣ 📂env                                             // 1. env 폴더 
 ┃ ┗ 📜env.yml
 ┣ 📂META-INF
 ┣ 📂static
 ┃ ┣ 📂css                                           // 2. CSS 폴더
 ┃ ┃ ┣ 📜common.css                                  // 공용 CSS
 ┃ ┃ ┗ 📜font.css                                    // 폰트 CSS
 ┃ ┣ 📂images                                        // 3. 이미지 폴더
 ┃ ┃ ┣ 📂article
 ┃ ┃ ┃ ┗ 📜medal.png
 ┃ ┃ ┣ 📂companionCat
 ┃ ┃ ┃ ┗ 📜cat.png
 ┃ ┃ ┣ 📂favicon
 ┃ ┃ ┃ ┗ 📜cat-pow.ico
 ┃ ┃ ┣ 📂marker
 ┃ ┃ ┃ ┣ 📜1.png
 ┃ ┃ ┃ ┣ 📜2.png
 ┃ ┃ ┃ ┣ 📜3.png
 ┃ ┃ ┃ ┗ 📜4.png
 ┃ ┃ ┣ 📂sns_login_icon
 ┃ ┃ ┃ ┣ 📜google.png
 ┃ ┃ ┃ ┗ 📜kakao.png
 ┃ ┃ ┣ 📂upload                                      // 업로드 폴더
 ┃ ┃ ┃ ┣ 📂article
 ┃ ┃ ┃ ┃ ┗ 📜게시글 이미지 업로드 파일
 ┃ ┃ ┃ ┗ 📂profile
 ┃ ┃ ┃ ┃ ┣ 📂companionCat
 ┃ ┃ ┃ ┃ ┃ ┗ 📜반려묘 프로필 이미지 업로드 파일
 ┃ ┃ ┃ ┃ ┗ 📂member
 ┃ ┃ ┃ ┃ ┃ ┗ 📜유저 프로필 이미지 업로드 파일
 ┃ ┃ ┣ 📜btnG_완성형.png
 ┃ ┃ ┣ 📜Meow-logo-big-op-0.png
 ┃ ┃ ┣ 📜Meow-logo-big.png
 ┃ ┃ ┣ 📜Meow-logo-small.png
 ┃ ┃ ┗ 📜Meow-logo.png
 ┃ ┗ 📂js                                            // 4. 자바스크립트 폴더
 ┃ ┃ ┣ 📂adm
 ┃ ┃ ┃ ┣ 📂common
 ┃ ┃ ┃ ┃ ┗ 📜report.js
 ┃ ┃ ┃ ┣ 📂home
 ┃ ┃ ┃ ┃ ┗ 📜pieChart.js
 ┃ ┃ ┃ ┗ 📂other
 ┃ ┃ ┃ ┃ ┣ 📜calendar.js
 ┃ ┃ ┃ ┃ ┗ 📜requestHistory.js
 ┃ ┃ ┣ 📂common
 ┃ ┃ ┃ ┣ 📜alert.js
 ┃ ┃ ┃ ┣ 📜carousel.js
 ┃ ┃ ┃ ┣ 📜dateTime.js
 ┃ ┃ ┃ ┣ 📜finalConsonantCheck.js
 ┃ ┃ ┃ ┣ 📜inputUtils.js
 ┃ ┃ ┃ ┣ 📜reaction.js
 ┃ ┃ ┃ ┣ 📜report.js
 ┃ ┃ ┃ ┗ 📜reqRes.js
 ┃ ┃ ┣ 📂companionCat
 ┃ ┃ ┃ ┗ 📜registerAndModify.js
 ┃ ┃ ┣ 📂map
 ┃ ┃ ┃ ┣ 📜AdmShowMap.js
 ┃ ┃ ┃ ┗ 📜UsrShowMap.js
 ┃ ┃ ┣ 📂member
 ┃ ┃ ┃ ┣ 📜delete.js
 ┃ ┃ ┃ ┣ 📜findLoginId.js
 ┃ ┃ ┃ ┣ 📜join.js
 ┃ ┃ ┃ ┣ 📜profile.js
 ┃ ┃ ┃ ┗ 📜resetLoginPw.js
 ┃ ┃ ┣ 📜chatPopUp.js
 ┃ ┃ ┗ 📜main.js
 ┣ 📂templates
 ┗ 📜application.yml
```

### 3. webapp
```bash
📦webapp.WEB-INF.jsp
 ┣ 📂adm                                             // 1. 관리자 jsp 폴더
 ┃ ┣ 📂articleManagement
 ┃ ┃ ┗ 📜list.jsp
 ┃ ┣ 📂common
 ┃ ┃ ┣ 📜footer.jsp
 ┃ ┃ ┣ 📜header.jsp
 ┃ ┃ ┗ 📜report.jsp
 ┃ ┣ 📂home
 ┃ ┃ ┣ 📜main.jsp
 ┃ ┃ ┗ 📜mainContent.jsp
 ┃ ┣ 📂inquiryManagement
 ┃ ┃ ┗ 📜list.jsp
 ┃ ┣ 📂map
 ┃ ┃ ┗ 📜showMap.jsp
 ┃ ┣ 📂member
 ┃ ┃ ┗ 📜login.jsp
 ┃ ┣ 📂memberManagement
 ┃ ┃ ┗ 📜list.jsp
 ┃ ┣ 📂other
 ┃ ┃ ┣ 📜calendar.jsp
 ┃ ┃ ┗ 📜requestHistory.jsp
 ┃ ┗ 📂replyManagement
 ┃ ┃ ┗ 📜list.jsp
 ┣ 📂test                                            // 2. 테스트 jsp 폴더
 ┃ ┗ 📜test.jsp
 ┗ 📂usr                                             // 3. 유저 jsp 폴더
   ┣ 📂article
   ┃ ┣ 📜detail.jsp
   ┃ ┣ 📜hotArticles.jsp
   ┃ ┣ 📜list.jsp
   ┃ ┣ 📜modify.jsp
   ┃ ┗ 📜write.jsp
   ┣ 📂common
   ┃ ┣ 📜chatPopUp.jsp
   ┃ ┣ 📜footer.jsp
   ┃ ┣ 📜head.jsp
   ┃ ┣ 📜header.jsp
   ┃ ┣ 📜jsReturnOnView.jsp
   ┃ ┣ 📜scrollButtons.jsp
   ┃ ┣ 📜toastUi.jsp
   ┃ ┗ 📜toastUiCdn.jsp
   ┣ 📂companionCat
   ┃ ┣ 📜modify.jsp
   ┃ ┣ 📜register.jsp
   ┃ ┗ 📜view.jsp
   ┣ 📂customerCenter
   ┃ ┣ 📜allPages.jsp
   ┃ ┣ 📜faq.jsp
   ┃ ┣ 📜feedback.jsp
   ┃ ┣ 📜history.jsp
   ┃ ┣ 📜main.jsp
   ┃ ┗ 📜write.jsp
   ┣ 📂home
   ┃ ┗ 📜main.jsp
   ┗ 📂member
     ┣ 📜delete.jsp
     ┣ 📜findLoginId.jsp
     ┣ 📜join.jsp
     ┣ 📜login.jsp
     ┣ 📜modify.jsp
     ┣ 📜profile.jsp
     ┣ 📜resetLoginPw.jsp
     ┣ 📜resetLoginPwLogined.jsp
     ┣ 📜snsAuth.jsp
     ┣ 📜userAccount.jsp
     ┗ 📜userAccountDefault.jsp
```
