<%@page import="item.ItemDAO"%>
<%@page import="order.OrdDAO"%>
<%@page import="user.User"%>
<%@page import="user.UserDAO"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
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
	String userID = (String) session.getAttribute("userID");
	UserDAO userDAO = new UserDAO();
	User user = userDAO.getUser(userID);
	CartDAO cartDAO = new CartDAO();
	ArrayList<Cart> cartLists = cartDAO.getCart(userID);
    ArrayList<Item> ItemList = new ArrayList<Item>();
    OrdDAO orderDAO = new OrdDAO();
    ItemDAO itemDAO = new ItemDAO();
    
    int resultPrice = 0;
    if(request.getParameter("usedPoint") != null) {	
    	resultPrice = Integer.parseInt(request.getParameter("usedPoint"));
    }
    
    int itemListSize = Integer.parseInt(request.getParameter("itemListSize"));
    String itemIDcol = "";
    String itemQuantitys = ""; 
    
    ArrayList<String> itemIDs = new ArrayList<String>();
	for(int i = 0; i < itemListSize; i++) {
    	itemIDs.add(request.getParameter("itemIDs"));
	}
	
	int point = Integer.parseInt(request.getParameter("point"));
	
	for(int i = 0; i < itemListSize; i++) {
    	itemIDcol += request.getParameter("itemID" + i) + "#" ;
    	itemQuantitys += request.getParameter("quantitys"+i) + "#";
    }
    itemIDcol = itemIDcol.substring(0, itemIDcol.length() -1);
    itemQuantitys = itemQuantitys.substring(0, itemQuantitys.length() -1);
    
    String postcode = request.getParameter("postcode");
	String roadAddress = request.getParameter("roadAddress");
	String jibunAddress = request.getParameter("jibunAddress");
	String detailAddress = request.getParameter("detailAddress");
	String address = postcode + "#" + roadAddress + "#" + detailAddress;   
	
	if(orderDAO.startOrder(userID, resultPrice, point, "무통장 입금", address, itemIDcol, itemQuantitys) == 1) {
		userDAO.updatePoint(userID, point);
		String[] deleteItemIDs = itemIDcol.split("#");
		String[] deleteItemQuantitys = itemQuantitys.split("#");
		for(int i = 0; i < itemListSize; i++) {
			if(cartDAO.deleteCart(userID, Integer.parseInt(deleteItemIDs[i])) != 1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('포인트를 사용해 주문을 완료했지만 데이터베이스 오류로 카트에서 삭제하지 못하였습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			if(itemDAO.updateStock(Integer.parseInt(deleteItemIDs[i]), Integer.parseInt(deleteItemQuantitys[i])) != 1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('포인트를 사용해 주문을 완료했지만 데이터베이스 오류로 재고값을 줄이질 못했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
		}
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('성공적으로 포인트를 " + point +" 만큼 사용해 주문을 완료했습니다.')");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.')");
		script.println("history.back()");
		script.println("</script>");
	}
%>
<%}else{ 
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('먼저 로그인 해주시기 바랍니다.')");
	script.println("history.back()");
	script.println("</script>");
}%>
</body>
</html>