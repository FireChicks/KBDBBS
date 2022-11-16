<%@page import="order.OrdStatusDAO"%>
<%@page import="order.Order"%>
<%@page import="order.OrdDAO"%>
<%@page import="cart.Cart"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="item.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page import="cart.CartDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.outer-div {
  width : 1000px;
  height : 300px;
  background-color : blue;
}

.inner-div {
  width : 100px;
  height : 100px;
  background-color: red;
  margin: auto;
}
</style>
</head>
<body>
<jsp:include page="index.jsp"></jsp:include>
<% 
if(session.getAttribute("userID") != null) {
	OrdDAO ordDAO = new OrdDAO();
	OrdStatusDAO ordStatDAO = new OrdStatusDAO();
    ArrayList<Item> ItemList = new ArrayList<Item>();
    int pageNumber = 1;
    if(request.getParameter("pageNumber") != null){
    	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
    }
 	ArrayList<Order> orders = ordDAO.getOrders((String)session.getAttribute("userID"), pageNumber);   
%>
<style>
  tr td {
  	border:1px solid;
  	text-align:center;
  	margin-left: 50px;
  }
</style>
<script>
var count = 0;
var price = 0;
</script>
<div class="container">
		<div style="width:100%;">
		<div  style="width:2000px; margin: 0 auto;">
			<div class="jumbotron" style="padding-top : 50px;">
				<h3>구매 내역</h3>		
				<table>
					<tr>
						<td>
							번호
						</td>
						<td>
							주문 번호
						</td>
						<td>
							주문 상태
						</td>
						<td>
							주문 날짜
						</td>
						<td>
							주문 취소 날짜
						</td>
						<td>
							주문 완료 날짜
						</td>
						<td>
							주문 총 가격
						</td>
						<td>
							주문 포인트 사용량
						</td>
						<td>
							결제 방법
						</td>
						<td>
							주문 주소
						</td>
						<td>
							송장 번호
						</td>
						<td>
							주문 상세
						</td>
					</tr>
					<%for(int i = 0; i < orders.size(); i++) { %>
					<% String[] Address = orders.get(i).getOrderAddress().split("#");%>
					<tr>
						<td>
							 <%=i+1%>
						</td>
						<td>
							 <%=orders.get(i).getOrderID()%>
						</td>
						<td>
							 <%=ordStatDAO.getStatusInfo(orders.get(i).getOrderStatus())%>
						</td>
						<td>
							 <%=orders.get(i).getOrderDate() %>
						</td>
						<td>
							 <%if(orders.get(i).getOrderCancleDate() != null){%><%=orders.get(i).getOrderCancleDate()%><%}else{%><%=""%><%}%>
						</td>
						<td>
							 <%if(orders.get(i).getOrderCompleteDate() != null){%><%=orders.get(i).getOrderCompleteDate()%><%}else{%><%=""%><%}%>
						</td>
						<td>
							 <%=orders.get(i).getOrderPrice() + orders.get(i).getOrderUsePoint()%>
						</td>
						<td>
							 <%=orders.get(i).getOrderUsePoint()%>
						</td>
						<td>
							 <%=orders.get(i).getOrderPaymentStatus()%>
						</td>
						<td>
							 <%for(int j = 0; j < Address.length; j++) {%><%=Address[j]+" "%><%}%>
						</td>
						<td>
							 <%=orders.get(i).getInvoiceNumber()%>
						</td>
						<td>
							<a class="btn btn-success" href="orderDetail.jsp?orderID=<%=orders.get(i).getOrderID()%>">상세</a>
						</td>
					</tr>
					<%}%>
				</table>
				<%
				if(pageNumber != 1) {
			%>
				<a href="orderHistory.jsp?pageNumber=<%= pageNumber - 1%>" class="btn btn-light btn-arraw-Left">이전</a>
			<%
				} if(ordDAO.nextPage((String)session.getAttribute("userID"),pageNumber + 1)) {
			%>
				<a href="orderHistory.jsp?pageNumber=<%= pageNumber + 1%>" class="btn btn-light btn-arraw-Left">다음</a>
			<%
				}
			%>		
			</div>		
			</div>
		</div>
	</div>
<%}else{ 
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('먼저 로그인 해주시기 바랍니다.')");
	script.println("history.back()");
	script.println("</script>");
}%>
</body>
</html>