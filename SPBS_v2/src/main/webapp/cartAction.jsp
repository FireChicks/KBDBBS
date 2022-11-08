<%@page import="item.Item"%>
<%@page import="item.ItemShowDAO"%>
<%@page import="cart.CartDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>   
<!DOCTYPE html>
<html>
<head>
<jsp:useBean id="cart" class="cart.Cart" scope="page" />
<jsp:setProperty name="cart" property="quantity" />	
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
int pageNumber = 1;
if(request.getParameter("pageNumber") != null) {
	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
}

int itemID = 1;
if(request.getParameter("itemID") != null) {
	itemID = Integer.parseInt(request.getParameter("itemID"));
} 

String searchText = "";
String search = "itemID";
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


if(searchText == null || searchText.equals("")) {
	searchBbs = false;
}

String itemBigCategory = ""; //1차 카테고리 받기
String itemSmallCategory = "";
boolean isBigSort = true;
boolean isSmallSort = true;
	
boolean isSeasonAvail = false;
String[] seasons = null;
ItemShowDAO itemDAO = new ItemShowDAO();
int maxPageNum = itemDAO.maxPageNum();

int bigCategoryNum = itemDAO.bigCategoryCount();
String[] bigCategorys = itemDAO.bigCategorys().split("#"); //1차 카테고리 가져오기

int smallCategoryNum = 0;
String[] smallCategorys = null;
	
Item item = itemDAO.getItem(itemID);
itemBigCategory = item.getItemBigCategory();

if(itemBigCategory != null) {
	itemSmallCategory = request.getParameter("itemSmallCategory");
	isSmallSort = true;			
}

		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");		
		
		cart.setItemID(itemID);
		cart.setUserID(userID);
		
		CartDAO cartDAO = new CartDAO();		
		int result = cartDAO.insert(cart);
	    if (result == -2) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('장바구니에 보관 가능한 개수는 최대 10개입니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else if (result == -3) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('현재 재고보다 더 많은양을 장바구니에 집어넣으셨습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('장바구니에 성공적으로 저장했습니다.')");
			script.println("location.href = 'goods.jsp?itemID=" + itemID + "&itemBigCategory=" + "&itemSmallCategory=" + "&isDesc=" + isDesc + "&sortBy=" + sortBy +"'");
			script.println("</script>");
		}
} else { 
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('먼저 로그인 해주시기 바랍니다.')");
	script.println("history.back()");
	script.println("</script>");
}
%>
</body>
</html>