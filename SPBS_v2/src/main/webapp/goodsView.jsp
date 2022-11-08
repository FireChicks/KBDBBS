<%@page import="cart.Cart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="cart.CartDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="item.Item"%>
<%@page import="item.ItemDAO"%>
<%@page import="item.ItemShowDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<style>
.outer-div {
  width : 100%;
  height : 300px;
}

.inner-div {
  width : 500px;
  height : 100px;
  margin: auto;
}
td{
	width:100px;
	border:1px;	
}
</style>
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
	if(request.getParameter("itemID") != null) {
	
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
	if(itemBigCategory != null && !itemBigCategory.equals("")) {
	smallCategoryNum = itemDAO.smallCategoryCount(itemBigCategory.trim());
	smallCategorys = itemDAO.smallCategorys(itemBigCategory	.trim()).split("#"); //2차 카테고리 가져오기
	}
	itemSmallCategory = item.getItemSmallCategory();
	
	CartDAO cartDAO = new CartDAO();
	int index = -1;
	ArrayList<Cart> cartList = null;
	if(session.getAttribute("userID") != null) {
		cartList = cartDAO.getCart((String) session.getAttribute("userID"));
		for(int i = 0; i < cartList.size(); i++ ) {
				if(cartList.get(i).getItemID() == itemID) {
					index = i;
			}		
		}
	}
%>
<style>
option {
	width:200px;
}
</style>
<jsp:include page="index.jsp"></jsp:include>
<div class='outer-div'>
  <div class='inner-div' style=" width:800px;">
  <div style=" margin:0 auto; width:800px;">
  <div class="jumbotron" style="padding-top : 20px;">
  	<table style="width:600px;">
  		<tr>
	  		<td><form action = "goods.jsp">
			아이템 1차 카테고리 : 
				<select id="itemBigCategory" name="itemBigCategory" class="form-select" aria-label="Default select example" onChange={this.onChange.bind(this)}>
					<option value="%">전체</option>
					<%for(int i=0; i < bigCategoryNum; i++) {%>
					<option value="<%=bigCategorys[i]%>" <%if(isBigSort){ if(itemBigCategory.equals(bigCategorys[i])) {%> <%="selected"%> <%} else {%> <%=""%> <%}}%> ><%=bigCategorys[i]%></option>	
					<%} %>		
				</select> 				
				<input type="hidden" name="isDesc" value="<%=isDesc%>">
				
				<script>
				$(document).ready(function(){
   					 $('#itemBigCategory').on('change', function() {
   						alert(this.value);
   						var url = "goods.jsp?itemBigCategory="+this.value+"&searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%>&sortBy=<%=sortBy%>&isDesc=<%=isDesc%>"; 
   						location.replace(url);  
    				});
				});
			</script> 				
			</form></td>
	  		
	  		<td> <%if(isBigSort && !itemBigCategory.equals("전체")){%>
	  		<form action = "goods.jsp">
			아이템 2차 카테고리 : 
				<select id="itemSmallCategory" name="itemSmallCategory" class="form-select" aria-label="Default select example" onChange={this.onChange.bind(this)}>
					<option value="%">선택 안함</option>	
					<%for(int i=0; i < smallCategoryNum; i++) {%>
					<option value="<%=smallCategorys[i]%>" <%if(isSmallSort){ if(itemSmallCategory.equals(smallCategorys[i].trim())) {%> <%="selected"%> <%} else {%> <%=""%> <%}}%> ><%=smallCategorys[i]%></option>	
					<%} %>		
				</select> 				
				<input type="hidden" name="isDesc" value="<%=isDesc%>">
				
				<script>
				$(document).ready(function(){
   					 $('#itemSmallCategory').on('change', function() {
   						alert(this.value);
   						var url = "goods.jsp?itemSmallCategory="+this.value+"&searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%>&itemBigCategory=<%=itemBigCategory%>&sortBy=<%=sortBy%>&isDesc=<%=isDesc%>"; 
   						location.replace(url);  
    				});
				});
			</script> 				
			</form>
			<%}%>
			</td>	  		  		
  		</tr>
  </table>  	  
  </div>
  </div>
  </div>

<style>
	.exp {
		border-bottom:1px solid;
	}
</style>
	
<div class="container">
		<div style="width:100%;">
		<div  style="width:800px; margin: auto;">
			<div class="jumbotron">
				<div>
				<form action="cartAction.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%><%if(isBigSort){%>&itemBigCategory=<%=itemBigCategory%><%}%><%if(isSmallSort){%>&itemSmallCategory=<%=itemSmallCategory%><%}%>&sortBy=<%=sortBy%>&isDesc=<%=isDesc%>">
				<input type="hidden" name="itemID" value="<%=itemID%>">
				<hr>
				<table>
				<tr>
					<td rowspan="7">
						<img src="<%if(item.getItemContentImagePath() != null && !item.getItemContentImagePath().equals("")) { %>							
											<%String[] imagePaths = item.getItemContentImagePath().split("#");%><%=imagePaths[0]%><%}else{%><%="/SPBS/resources/이미지 없음.png"%><%}%>" bordr="2" width="400px" height="100%" alt="파일위치오류">	
					</td>
				</tr>
				<tr>
					<td style="width : 10%;">
					</td>
					<td style="width : 40%; text-align : right;" class="exp">
						<small>상품코드 <%=item.getItemID()%></small>
					</td>
				</tr>
				<tr>
					<td>
					</td>
					<td style="text-align:center;" class="exp">
						<%=item.getItemName()%>
					</td>
				</tr>
				<tr>
					<td>
					</td>
					<td class="exp">
						<small>단위</small> <%=item.getItemUnit()%>
					</td>
				</tr>
				<tr>
					<td>
					</td>
					<td class="exp">
						<small>판매가</small> <%=item.getItemPrice()%> <small>원</small>
					</td>
				</tr>
				<tr>
					<td>
					</td>
					<td class="exp">
						<small>수량</small> <input type="number" value="1" name="quantity" min="1" max="<%if(index == -1) {%><%=item.getItemStock()%><%}else{%><%=item.getItemStock() - cartList.get(index).getQuantity()%><%}%>"/>						
					<%if(index != -1) {%>
						현재 장바구니의 양 : <%=cartList.get(index).getQuantity()%>
					<%}%>
					<br> 현재 재고 : <%=item.getItemStock() %>
					</td>
				</tr>
				<tr>
					<td>
					</td>	
					<td class="exp">
						<input <%if(item.getItemStock() == 0){%><%="disabled"%><%}%> type="submit" class="btn btn-light" value="장바구니"> <input type="submit" class="btn btn-primary" value="바로 구매">
					</td>
				</tr>
				</table>
				</form>
				<hr>				
				</div>
				<div>
				상세정보
				</div>
				<div>
				상품후기
				</div>
				<div>
				상품문의
				</div>
				<div>
				교환 반품 정보
				</div>
			</div>		
			</div>
		</div>
	</div>
<%}else{
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('정상적이지 않은 접근입니다!')");
	script.println("location.href = 'goods.jsp'");
	script.println("</script>");	
}%>
}
</body>
</html>