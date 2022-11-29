<%@page import="item.ItemDAO"%>
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
	ItemDAO itemDAO = new ItemDAO();
	OrdStatusDAO ordStatDAO = new OrdStatusDAO();
    ArrayList<Item> ItemList = new ArrayList<Item>();
    int pageNumber = 1;
 	ArrayList<Order> orders = ordDAO.getOrders((String)session.getAttribute("userID"), pageNumber);  
 	
 	int orderID = 0;
	if(request.getParameter("orderID") != null) {
		orderID = Integer.parseInt(request.getParameter("orderID"));
	}
	Order order = ordDAO.getOrder(orderID);
	
	OrdStatusDAO ordStatusDAO = new OrdStatusDAO();
	String chekedStatus = "style=\"background-color:#d3d3d3;  color:red;\"";
	
	String ordStatus = ordStatusDAO.getStatusInfo(order.getOrderStatus());
	String ordStat   = order.getOrderStatus();
	
	String[] address      = order.getOrderAddress().split("#");
	String[] ordItems     = order.getOrdItemIDs().split("#");
	String[] ordQuantitys = order.getOrdItemQuantitys().split("#");
	
	 ArrayList<Item> ordItemList = new ArrayList<Item>();
	    
	    for(int i = 0; i < ordItems.length; i ++) {
	    	ordItemList.add(itemDAO.getItem(Integer.parseInt(ordItems[i])));
	    }
	
	if(orderID != 0) {
	 			
%>

<div class="container">
		<div class="col-mg-6">
			<div class="jumbotron" style="padding-top : 18px;">			
				<h3 style="text-align: center;">배송 목록</h3>
				<hr>
				<table class="table table-stirped" style="text-align: center; border: 1px solid #dddddd; font-size: 8pt;">
				<thead>
					<tr style="background-color:#d3d3d3;">	
						<td colspan="4" ><h5>주문 내용</h5></td>											
					</tr>
					<tr>						
						<td>주문 ID</td>
						<td colspan="3"><%=order.getOrderID()%></td>
					</tr>
					<tr>	
						<td>주문자 ID</td>
						<td colspan="3"><%=order.getUserID()%></td>
					</tr>
					<tr>	
						<td>주문 날짜</td>	
						<td colspan="3"><%=order.getOrderDate()%></td>	
					</tr>
					<tr>						
						<td>주문 취소 날짜</td>
						<td colspan="3"><%=order.getOrderCancleDate()%></td>
					</tr>
					<tr>						
						<td>주문 완료 날짜</td>
						<td colspan="3"><%=order.getOrderCompleteDate()%></td>
					</tr>
					<tr>	
						<td>결제 가격</td>
						<td colspan="3"><%=order.getOrderPrice()%></td>
					</tr>
					<tr>	
						<td>결제 사용 포인트</td>
						<td colspan="3"><%=order.getOrderUsePoint()%></td>
					</tr>
					<tr>	
						<td>전체 가격</td>
						<td colspan="3"><%=order.getOrderPrice() + order.getOrderUsePoint()%></td>
					</tr>
					<tr>	
						<td>결제 상태</td>	
						<td colspan="3"><%=order.getOrderPaymentStatus()%></td>
					</tr>
					<tr>	
						<td>송장 번호</td>	
						<td colspan="3"><%=order.getInvoiceNumber()%></td>
					</tr>
					<tr>	
						<td>주문 주소</td>	
						<td colspan="3">
						<%for(int j = 0; j < address.length; j++) {%>
						<%=address[j]%><br>
						<%}%></td>
					</tr>
					<tr>
						<td colspan="4" style="background-color:#d3d3d3;">주문 상품</td>
					</tr>
					<tr>
						<td>이미지</td>
						<td>상품명</td>
						<td>가격</td>
						<td>주문양</td>						
					</tr>
					<tr>	
						<%for(int i = 0 ; i < ordItemList.size(); i ++) {%>							
					<tr>						
						<td>
							<img src="<%if(ordItemList.get(i).getItemContentImagePath() != null && !ordItemList.get(i).getItemContentImagePath().equals("")) { %>							
												<%String[] imagePaths = ordItemList.get(i)	.getItemContentImagePath().split("#");%><%=imagePaths[0]%><%}else{%><%="/SPBS/resources/이미지 없음.png"%><%}%>" bordr="2" width="100px" height="80px" alt="파일위치오류">
						</td>
						<td style="width:50%;">
							<a href="goodsView.jsp?itemID=<%=ordItemList.get(i).getItemID()%>"><%=ordItemList.get(i).getItemName()%></a>
						</td>
						<td>
							<%=ordItemList.get(i).getItemPrice()%>원
						</td>					
						<td>
							<input id="quantity<%=i%>" type="number" value="<%=ordQuantitys[i]%>" name="quantity<%=i%>" min="1" max="<%=ordItemList.get(i).getItemStock()%>" disabled/>
						</td>										
					</tr>	
					<%}%>																															
				</thead>
				</table>
				<a href="orderHistory.jsp" class="btn btn-primary">주문 내역 확인</a>
				<%if(order.getOrderStatus().charAt(0) == '0') {%>
				<a href="orderCancle.jsp?orderID=<%=orderID%>" class="btn btn-warning">주문 취소</a>	
				<%}%>								
			</div>							
			<div style="display: flex; justify-content: center;" class="btn btn-priamary">
			</div>
		</div>		
	</div>

<%	} else {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('주문ID가 유효하지 않습니다.')");
	script.println("history.back()");
	script.println("</script>");
}
}else{ 
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('먼저 로그인 해주시기 바랍니다.')");
	script.println("history.back()");
	script.println("</script>");
}%>
</body>
</html>