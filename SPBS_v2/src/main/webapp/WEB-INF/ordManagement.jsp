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
	int pageNumber = 1;
	if(request.getParameter("pageNumber") != null) {
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
	String searchText = "";
	String search = null;
	boolean searchBbs = false;
	boolean isDesc = true;
	if(request.getParameter("search") != null) {
		searchBbs = true;
		search = request.getParameter("search");
		searchText = request.getParameter("searchText");
	}
	
	boolean isSort = false;
	String sortBy = "";
	if(request.getParameter("sortBy") != null) {
		if(request.getParameter("sortBy").equals("")) {
			isSort = false;
		} else {
			isSort = true;
			sortBy = request.getParameter("sortBy");
		}
	}
	
	if(request.getParameter("isDesc") != null) {
		if(request.getParameter("isDesc").equals("false")) {
			isDesc = false;
		} else {
			isDesc = true;
		}
	}	

	if(searchText.equals("")) {
		searchBbs = false;
	}
	
	boolean isSeasonAvail = false;
	String[] seasons = null;
	
	ItemDAO itemDAO = new ItemDAO();
	int maxPageNum = itemDAO.maxPageNum();
	
	OrdDAO ordDAO = new OrdDAO();
	ArrayList<Order> orderList = null;
	if(!searchBbs) {
		orderList = ordDAO.getOrders(pageNumber);	
	} else {
		orderList = ordDAO.getOrders(searchText, pageNumber);
	}
	
	OrdStatusDAO ordStatusDAO = new OrdStatusDAO();
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
        <a href="../admin/ordManage.jsp" class="nav-link active" aria-current="page">
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
        <a href="inquryAdmin.jsp" class="nav-link link-dark">
          <svg class="bi pe-none me-2" width="16" height="16"><use xlink:href="#table"/></svg>
          문의
        </a>
      </li>
    </ul>      
  </div>
  <div class="container">
		<div class="col-mg-10">
			<div class="jumbotron" style="padding-top : 18px;">			
				<h3 style="text-align: center;">배송 목록</h3>
				<hr>
				<table class="table table-stirped" style="text-align: center; border: 1px solid #dddddd; font-size: 8pt;">
				<thead>
					<tr>
						<td><a href="itemManage.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%>&sortBy=itemID&isDesc=<%=isDesc%>">주문<br>ID</a></td>
						<td><a href="itemManage.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%>&sortBy=itemName&isDesc=<%=isDesc%>">주문자<br>이름</a></td>
						<td><a href="itemManage.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%>&sortBy=itemPrice&isDesc=<%=isDesc%>">주문<br>상태</a></td>
						<td><a href="itemManage.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%>&sortBy=itemStock&isDesc=<%=isDesc%>">주문<br>날짜</a></td>
						<td>주문<br>취소 날짜</td>
						<td>주문<br>완료 날짜</td>
						<td>주문<br>가격</td>
						<td>주문<br>사용 포인트</td>
						<td>주문<br>총 가격</td>
						<td>결제<br>방법</td>
						<td>주문<br>주소</td>
						<td>송장<br>번호</td>	
						<td>주문<br>상품</td>	
						<td>주문<br>양</td>											
					</tr>
					<%for(int i = 0; i < orderList.size(); i++) {%>	
					<%String[] address      = orderList.get(i).getOrderAddress().split("#");
					  String[] ordItems     = orderList.get(i).getOrdItemIDs().split("#");
					  String[] ordQuantitys = orderList.get(i).getOrdItemQuantitys().split("#");%>																	
					<tr>
						<td><%=orderList.get(i).getOrderID()%></td>
						<td><%=orderList.get(i).getUserID()%></td>
						<td><a href="statusManage.jsp?orderID=<%=orderList.get(i).getOrderID()%>"><%=ordStatusDAO.getStatusInfo(orderList.get(i).getOrderStatus())%></a></td>
						<td><%=orderList.get(i).getOrderDate()%></td>
						<td><%=orderList.get(i).getOrderCancleDate()%></td>
						<td><%=orderList.get(i).getOrderCompleteDate()%></td>
						<td><%=orderList.get(i).getOrderPrice()%></td>
						<td><%=orderList.get(i).getOrderUsePoint()%></td>
						<td><%=orderList.get(i).getOrderPrice() + orderList.get(i).getOrderUsePoint()%></td>
						<td><%=orderList.get(i).getOrderPaymentStatus()%></td>
						
						<td>
						<%for(int j = 0; j < address.length; j++) {%>
						<%=address[j]%><br>
						<%}%></td>
						
						<td>송장<br>번호</td>
						
						<td>
						<%for(int j = 0; j < ordItems.length; j++) {%>	
						<%=ordItems[j]%>&nbsp;
						<%}%></td>
						
						<td>
						<%for(int j = 0; j < ordItems.length; j++) {%>		
						<%=ordQuantitys[j]%>&nbsp;				
						<%}%></td>
					</tr>
					<%}%>										
				</thead>
				</table>
						
				<%
				if(pageNumber != 1) {
			%>
				<a href="ordManage.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%= pageNumber - 1%>" class="btn btn-light btn-arraw-Left">이전</a>
			<%
				} if(ordDAO.nextPage(pageNumber + 1, search, searchText)) {
			%>
				<a href="ordManage.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%= pageNumber + 1%>" class="btn btn-light btn-arraw-Left">다음</a>
			<%
				}
			%>		
			<form action = "ordManage.jsp">
				<select name="search" id="searchOption" class="form-select" aria-label="Default select example" onChange={this.onChange.bind(this)}>
					<option value="userID" <%if(search != null){ if(search.matches("userID")) {%> <%="selected"%> <%} else {%> <%=""%> <%}}%> >유저 ID</option>				
				</select> 				
				<input name="searchText" type="text"  value=<%=searchText%>>
				<input type="hidden" name="isDesc" value="<%=isDesc%>">
				<input type="hidden" name="sortBy" value="<%=sortBy%>">
				<input type="submit" class="btn btn-success btn-sm" value="조회">
			</form>								
			</div>						
			<div style="display: flex; justify-content: center;" class="btn btn-priamary">
			</div>
		</div>
	</div>	
</main>		
</body>

</html>