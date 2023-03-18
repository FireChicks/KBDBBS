<%@page import="java.io.PrintWriter"%>
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
	
	int orderID = 0;
	if(request.getParameter("orderID") != null) {
		orderID = Integer.parseInt(request.getParameter("orderID"));
	}
	
	boolean isSeasonAvail = false;
	String[] seasons = null;
	
	ItemDAO itemDAO = new ItemDAO();
	int maxPageNum = itemDAO.maxPageNum();
	
	OrdDAO ordDAO = new OrdDAO();
	Order order = ordDAO.getOrder(orderID);
	
	OrdStatusDAO ordStatusDAO = new OrdStatusDAO();
	String chekedStatus = "style=\"background-color:#d3d3d3;  color:red;\"";
	
	String ordStatus = ordStatusDAO.getStatusInfo(order.getOrderStatus());
	String ordStat   = order.getOrderStatus();
	
	String[] address      = order.getOrderAddress().split("#");
	String[] ordItems     = order.getOrdItemIDs().split("#");
	String[] ordQuantitys = order.getOrdItemQuantitys().split("#");
	
	if(orderID != 0) {
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
		<div class="col-mg-6">
			<div class="jumbotron" style="padding-top : 18px;">			
				<h3 style="text-align: center;">배송 목록</h3>
				<hr>
				<table class="table table-stirped" style="text-align: center; border: 1px solid #dddddd; font-size: 8pt;">
				<thead>
					<tr style="background-color:#d3d3d3;">	
						<td colspan="2" ><h5>주문 내용</h5></td>											
					</tr>
					<tr>						
						<td>주문 ID</td>
						<td><%=order.getOrderID()%></td>
					</tr>
					<tr>	
						<td>주문자 ID</td>
						<td><%=order.getUserID()%></td>
					</tr>
					<tr>	
						<td>주문 날짜</td>	
						<td><%=order.getOrderDate()%></td>	
					</tr>
					<tr>						
						<td>주문 취소 날짜</td>
						<td><%=order.getOrderCancleDate()%></td>
					</tr>
					<tr>						
						<td>주문 완료 날짜</td>
						<td><%=order.getOrderCompleteDate()%></td>
					</tr>
					<tr>	
						<td>결제 가격</td>
						<td><%=order.getOrderPrice()%></td>
					</tr>
					<tr>	
						<td>결제 사용 포인트</td>
						<td><%=order.getOrderUsePoint()%></td>
					</tr>
					<tr>	
						<td>전체 가격</td>
						<td><%=order.getOrderPrice() + order.getOrderUsePoint()%></td>
					</tr>
					<tr>	
						<td>결제 상태</td>	
						<td><%=order.getOrderPaymentStatus()%></td>
					</tr>
					<tr>	
						<td>송장 번호</td>	
						<td><%=order.getInvoiceNumber()%></td>
					</tr>
					<tr>	
						<td>주문 주소</td>	
						<td>
						<%for(int j = 0; j < address.length; j++) {%>
						<%=address[j]%><br>
						<%}%></td>
					</tr>																															
				</thead>
				</table>								
			</div>							
			<div style="display: flex; justify-content: center;" class="btn btn-priamary">
			</div>
		</div>		
	</div>
<%if(ordStat.charAt(0) == '0') {%>

<div class="container">
		<div class="col-mg-2">
			<div class="jumbotron" style="padding-top : 18px;">			
				<h3 style="text-align: center; color:white;">배송 목록</h3>
				<hr>
				<form action="adminAction/statusUpdateAction.jsp">
				<table class="table table-stirped" style="text-align: center; border: 1px solid #dddddd; font-size: 8pt;">
				<thead>
					<tr style="background-color:#d3d3d3;">						
						<td><h5>배송 단계</h5></td>									
					</tr>															
					<tr <%if(ordStat.charAt(1) == '1'){%> <%=chekedStatus%> <%}%>>
						<td>주문 완료</td>
					</tr>
					<tr <%if(ordStat.charAt(1) == '2'){%> <%=chekedStatus%> <%}%>>
						<td >결제 완료</td>
					</tr>
					<tr <%if(ordStat.charAt(1) == '3'){%> <%=chekedStatus%> <%}%>>
						<td >배송 준비중</td>
					</tr>
					<tr <%if(ordStat.charAt(1) == '4'){%> <%=chekedStatus%> <%}%>>
						<td >배송중</td>
					</tr>
					<tr <%if(ordStat.charAt(1) == '5'){%> <%=chekedStatus%> <%}%>>
						<td >배송완료</td>	
					</tr>
					<tr>
						<td> 
						<%if(ordStat.charAt(1) == '3') {%>
						<input type="text" maxlength="50" name="invoiceNumber" id="invoiceNumber" placeholder="송장번호">
						<a id="result"></a>
						<script>
						invoiceNumber.oninput = function() {
  											var con1 = /[^0-9|\-]|[\s|\0]/g; // 특수문자, 공백 검색 정규식 (-,_)제외
											var temp = document.getElementById('invoiceNumber').value;
											var pos1 = temp.match(con1);
											const btn = document.getElementById('btn');
											if(pos1){
												result.innerHTML = "숫자와 특수기호(-)만 사용 가능합니다.";
												btn.disabled = true;
											}else{
												result.innerHTML = "";
												btn.disabled = false;
							}
								
 						 };
						</script>						
						<%}%>
						<input type="submit" class="btn btn-primary" id="btn" value="다음 단계">
						<input type="hidden" value="<%=orderID%>" name="orderID"> </form>	
						<form action="adminAction/statusCancleAction.jsp">
							<input type="submit" class="btn btn-primary" value="취소"></td>	
							<input type="hidden" value="<%=orderID%>" name="orderID">
						</form>
					</tr>									
				</thead>
				</table>											
			</div>						
			<div style="display: flex; justify-content: center;" class="btn btn-priamary">
			</div>
		</div>
	</div>
<%}else if (ordStat.charAt(0) == '1') {%>	
<div class="container">
		<div class="col-mg-4">
			<div class="jumbotron" style="padding-top : 18px;">			
				<h3 style="text-align: center;">배송 목록</h3>
				<hr>
				<form action="adminAction/statusUpdateAction.jsp">
				<table class="table table-stirped" style="text-align: center; border: 1px solid #dddddd; font-size: 8pt;">
				<thead>
					<tr style="background-color:#d3d3d3;">						
						<td><h5>배송 단계</h5></td>									
					</tr>															
					<tr <%if(ordStat.charAt(1) == '1'){%> <%=chekedStatus%> <%}%>>
						<td>반품 요청</td>
					</tr>
					<tr <%if(ordStat.charAt(1) == '2'){%> <%=chekedStatus%> <%}%>>
						<td>반품 중</td>
					</tr>
					<tr <%if(ordStat.charAt(1) == '3'){%> <%=chekedStatus%> <%}%>>
						<td>취소 완료</td>
					</tr>
					<tr>
						<td> <input type="submit" class="btn btn-primary" value="다음 단계"></td>	
						<input type="hidden" value="<%=orderID%>" name="orderID">						
					</tr>									
				</thead>
				</table>	
				</form>							
			</div>						
			<div style="display: flex; justify-content: center;" class="btn btn-priamary">
			</div>
		</div>
	</div>
<%}%>
</main>		
</body>
<%} else { 
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('유효하지않은 주문번호입니다.')");
	script.println("location.href = 'ordManage.jsp'");
	script.println("</script>");
}%>
</html>