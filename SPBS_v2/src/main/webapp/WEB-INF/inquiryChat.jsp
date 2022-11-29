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
        <a href="#" class="nav-link link-dark">
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
				<jsp:include page="chat.jsp"></jsp:include>				 
 		</div>
	</div>
</div>
</main>		
</body>

</html>