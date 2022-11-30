<%@page import="chat.Chat"%>
<%@page import="chat.ChatDAO"%>
<%@page import="user.User"%>
<%@page import="user.UserDAO"%>
<%@page import="order.OrdStatusDAO"%>
<%@page import="order.Order"%>
<%@page import="order.OrdDAO"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="item.ItemDAO" %>
<%@ page import="item.Item" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	tr {
	width: 800px;
	height: 10px;
	margin-top: 10px;
	padding-top: 10px;
	}
</style>
</head>
<body>
<jsp:include page="index.jsp"></jsp:include>
<%
int userPageNumber = 1;
UserDAO userDAO = new UserDAO();
ArrayList<User> userList = userDAO.getUserList(userPageNumber);

ChatDAO chatDAO = new ChatDAO();
ArrayList<Chat> inquiryList = chatDAO.getChatListByInquiry();
String toID = null;
if(request.getParameter("toID") != null) {
	toID = (String) request.getParameter("toID");
}
%>
<main class="d-flex flex-nowrap">
<div class="b-example-divider b-example-vr"></div>

  <div class="d-flex flex-column flex-shrink-0 p-3 bg-light" style="width: 280px;">
    <a href="../admin/admin.jsp" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
      <svg class="bi pe-none me-2" width="40" height="32"><use xlink:href="#bootstrap"/></svg>
      <span class="fs-4">관리자 메뉴</span>
    </a>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
      <li class="nav-item">
        <a href="../admin/itemManage.jsp" class="nav-link link-dark">
          <svg class="bi pe-none me-2" width="16" height="16"><use xlink:href="itemMangement.jsp"/></svg>
          상품 관리
        </a>
      </li>
      <li>
        <a href="../admin/ordManage.jsp" class="nav-link link-dark" aria-current="page">
          <svg class="bi pe-none me-2" width="16" height="16"><use xlink:href="ordManage.jsp"/></svg>
          배송 관리
        </a>
      </li>
      <li>
        <a href="../admin/bbs.jsp" class="nav-link link-dark">
          <svg class="bi pe-none me-2" width="16" height="16"><use xlink:href="#table"/></svg>
          특집 글 관리
        </a>
      </li>
      <li>
        <a href="#" class="nav-link link-dark">
          <svg class="bi pe-none me-2" width="16" height="16"><use xlink:href="#grid"/></svg>
          후기 관리
        </a>
      </li>
      <li>
        <a href="#" class="nav-link link-dark">
          <svg class="bi pe-none me-2" width="16" height="16"><use xlink:href="#people-circle"/></svg>
          메인 이미지 관리
        </a>
      </li>
      <li>
        <a href="inquryAdmin.jsp" class="nav-link active">
          <svg class="bi pe-none me-2" width="16" height="16"><use xlink:href="#table"/></svg>
          문의
        </a>
      </li>
    </ul>      
  </div>
<div class="container">
		<div class="col-xs-12">
			<div class="jumbotron" style="padding-top : 18px;">			
				<h3 style="text-align: center;">문의 조회</h3>
				<hr>			
				<div>
				 <table class="table table-stirped" style="text-align: center; border: 1px solid #dddddd; font-size: 12pt;">
 	<tr>
 		<td colspan="2">
 			아이디 조회
 		</td>
 	</tr>
 	<tr>
 		<td>
 			아이디
 		</td>
 		<td>
 			문의 확인
 		</td>
 	</tr>
 	<%for(int i = 0; i < userList.size(); i++) {%>
 	<tr>
 		<td>
 			<%=userList.get(i).getUserID()%>
 		</td>
 		<td>
 			<a class="btn btn-primary" href="inquryChat.jsp?toID=<%=userList.get(i).getUserID()%>">확인</a>
 		</td>
 	</tr>
 	<%}%>
 </table>
 </div>
 <br>
 <br>
 <br>
 <hr>
 <br>
 <br>
 <br>
 <div>
  <table class="table table-stirped" style="text-align: center; border: 1px solid #dddddd; font-size: 12pt;">
 	<tr>
 		<td colspan="5">
 			알림 확인
 		</td>
 	</tr>
 	<tr>
 		<td>
 			알림 번호
 		</td>
 		<td>
 			문의 ID
 		</td>
 		<td>
 			문의 시각
 		</td>
 		<td>
 			문의 내용
 		</td>
 		<td>
 			문의 확인
 		</td>
 	</tr>
 	<%for(int i = 0; i < inquiryList.size(); i++) {%>
 	<tr>
 		<td>
 			<%=i%>
 		</td>
 		<td>
 			<%=inquiryList.get(i).getToID()%>
 		</td>
 		<td>
 			<%=inquiryList.get(i).getChatTime()%>
 		</td>
 		<td>
 			<%if(inquiryList.get(i).getInquiryType() == 0) {%>
 				<a href="itemUpdate.jsp?itemID=<%=inquiryList.get(i).getInquiryID()%>"><%=inquiryList.get(i).getInquiryID()%>번 상품 문의</a>
 			<%}else if (inquiryList.get(i).getInquiryType() == 1) {%>
 				<a href="statusManage.jsp?orderID=<%=inquiryList.get(i).getInquiryID()%>"><%=inquiryList.get(i).getInquiryID()%>번 주문 문의</a>
 			<%}%>
 		</td>
 		<td>
 			<a class="btn btn-primary" href="inquryChat.jsp?toID=<%=inquiryList.get(i).getToID()%>">확인</a>
 		</td>
 	</tr>
 	<%}%>
 </table>
 </div>
		</div>
	</div>
</main>		
</body>

</html>