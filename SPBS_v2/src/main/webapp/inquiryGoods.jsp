<%@page import="parameter.ItemPageParameter"%>
<%@page import="item.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page import="item.ItemShowDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
	boolean isBigSort = false;
	boolean isSmallSort = false;
	if(request.getParameter("itemBigCategory") != null) {
		itemBigCategory = request.getParameter("itemBigCategory");
		isBigSort = true;
	}
	
	
	
	boolean isSeasonAvail = false;
	String[] seasons = null;
	ItemShowDAO itemDAO = new ItemShowDAO();
	int maxPageNum = itemDAO.maxPageNum();
	
	int bigCategoryNum = itemDAO.bigCategoryCount();
	String[] bigCategorys = itemDAO.bigCategorys().split("#"); //1차 카테고리 가져오기
	
	int smallCategoryNum = 0;
	String[] smallCategorys = null;
	
	if(isBigSort) {
		if(request.getParameter("itemSmallCategory") != null) {
			itemSmallCategory = request.getParameter("itemSmallCategory");
			isSmallSort = true;			
		}
		if(itemBigCategory != null && !itemBigCategory.equals("")) {
		smallCategoryNum = itemDAO.smallCategoryCount(itemBigCategory.trim());
		smallCategorys = itemDAO.smallCategorys(itemBigCategory.trim()).split("#"); //2차 카테고리 가져오기
		}
	}
%>

<%
					ItemPageParameter itemPara = new ItemPageParameter();
					itemPara.setDesc(isDesc);
					itemPara.setSearch(searchBbs);
					itemPara.setSortBy(isSort);
					itemPara.setBigSort(isBigSort);
					itemPara.setSmallSort(isSmallSort);
					itemPara.setItemBigCategory(itemBigCategory);
					itemPara.setItemSmallCategory(itemSmallCategory);
					itemPara.setPageNumber(pageNumber);
					itemPara.setSearch(search);
					itemPara.setSearchText(searchText);
					itemPara.setSortBy(sortBy);
					ArrayList<Item> items;
					if((!isSort || sortBy.equals(""))&& (!searchBbs || search.equals("")) && (!isBigSort || itemBigCategory.equals(""))) {
						if(isDesc) {
						items = itemDAO.getList(pageNumber);	
						} else {
						items = itemDAO.getList(pageNumber, isDesc);	
						}
					}else{
					 	items = itemDAO.getList(itemPara);		
					}
%>
<jsp:include page="index.jsp"></jsp:include>
<div class='outer-div'>
  <div class='inner-div' style=" width:1000px;">
  <div style=" margin:0 auto; width:1000px;">
  <div class="jumbotron" style="padding-top : 20px;">
  	<table style="width:100%;">
  		<tr>
	  		<td><form action = "inquiryGoods.jsp">
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
   						var url = "inquiryGoods.jsp?itemBigCategory="+this.value+"&searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%>&sortBy=<%=sortBy%>&isDesc=<%=isDesc%>"; 
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
   						var url = "inquiryGoods.jsp?itemSmallCategory="+this.value+"&searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%>&itemBigCategory=<%=itemBigCategory%>&sortBy=<%=sortBy%>&isDesc=<%=isDesc%>"; 
   						location.replace(url);  
    				});
				});
			</script> 				
			</form>
			<%}%>
			</td>
	  		
	  		<td style="text-align: left;"><form action = "goods.jsp">
			정렬기준 
				<select id="sortBy" name="sortBy" id="searchOption" class="form-select" aria-label="Default select example" onChange={this.onChange.bind(this)}>
					<option value="itemID" <%if(search != null){ if(sortBy.matches("itemID")) {%> <%="selected"%> <%} else {%> <%=""%> <%}}%> >아이템 ID</option>
					<option value="itemName" <%if(search != null){ if(sortBy.matches("itemName")){%><%="selected"%> <%} else{%> <%=""%> <%}}%> >아이템 이름</option>
					<option value="itemPrice" <%if(search != null){ if(sortBy.matches("itemPrice")){%><%="selected"%> <%} else{%> <%=""%> <%}}%> >아이템 가격</option>
					<option value="itemStock" <%if(search != null){ if(sortBy.matches("itemStock")){%><%="selected"%> <%} else{%> <%=""%> <%}}%> >아이템 재고</option>
					<option value="itemSaleCount" <%if(search != null){ if(sortBy.matches("itemSaleCount")){%><%="selected"%> <%} else{%> <%=""%> <%}}%> >아이템 판매량</option>					
					
				</select> 				
				<input type="hidden" name="isDesc" value="<%=isDesc%>">	
				<script>
				$(document).ready(function(){
   					 $('#sortBy').on('change', function() {
   						alert(this.value);
   						var url = "inquiryGoods.jsp?sortBy="+this.value+"&searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%><%if(isBigSort){%>&itemBigCategory=<%=itemBigCategory%><%}%><%if(isSmallSort){%>&itemSmallCategory=<%=itemSmallCategory%><%}%>&isDesc=<%=isDesc%>"; 
   						location.replace(url);  
    				});
				});				

			</script></form> </td>
	  		
	  		<td style="text-align: right;"><%if(isDesc) {%>
								<a href="inquiryGoods.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%><%if(isBigSort){%>&itemBigCategory=<%=itemBigCategory%><%}%><%if(isSmallSort){%>&itemSmallCategory=<%=itemSmallCategory%><%}%>&sortBy=<%=sortBy%>&isDesc=true" class="btn btn-primary btn-arraw-Right">내림차 순</a>
								<a href="inquiryGoods.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%><%if(isBigSort){%>&itemBigCategory=<%=itemBigCategory%><%}%><%if(isSmallSort){%>&itemSmallCategory=<%=itemSmallCategory%><%}%>&sortBy=<%=sortBy%>&isDesc=false" class="btn btn-light btn-arraw-Right">오름차 순</a>
								<%} else { %>
								<a href="inquiryGoods.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%><%if(isBigSort){%>&itemBigCategory=<%=itemBigCategory%><%}%><%if(isSmallSort){%>&itemSmallCategory=<%=itemSmallCategory%><%}%>&sortBy=<%=sortBy%>&isDesc=true" class="btn btn-light btn-arraw-Right">내림차 순</a>
								<a href="inquiryGoods.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%=pageNumber%><%if(isBigSort){%>&itemBigCategory=<%=itemBigCategory%><%}%><%if(isSmallSort){%>&itemSmallCategory=<%=itemSmallCategory%><%}%>&sortBy=<%=sortBy%>&isDesc=false" class="btn btn-primary btn-arraw-Right">오름차 순</a>
								<%} %>
			</td>
  		</tr>
  </table>
  	  
  </div>
  </div>
  </div> 
  <div style="padding-top : 50px; width:1000px; margin:0 auto;">
    <%for(int i =0; i < items.size(); i++){%>				
    <script>
  	function itemInquiryActionFunction<%=i%>() {
  		var inquriyCon = confirm('상품번호 <%=items.get(i).getItemID()%>번 <%=items.get(i).getItemName()%>상품을 문의하시겠습니까?');
  		return inquriyCon;
  	}
  </script>				
  	<div style="float:left; width:24%; text-align: center; margin-top:30px; margin-right:10px; margin-bottom:20px; padding-bottom:10px;">
  	<a href="inquiryGoodsAction.jsp?itemID=<%=items.get(i).getItemID()%>" onclick="return itemInquiryActionFunction<%=i%>();">
  	<img src="<%if(items.get(i).getItemContentImagePath() != null && !items.get(i).getItemContentImagePath().equals("")) { %>							
											<%String[] imagePaths = items.get(i).getItemContentImagePath().split("#");%><%=imagePaths[0]%><%}else{%><%="/SPBS/resources/이미지 없음.png"%><%}%>" bordr="2" width="80%" height="150px" alt="파일위치오류"></a> <br>
  	<a href="inquiryGoodsAction.jsp?itemID=<%=items.get(i).getItemID()%>" onclick="return itemInquiryActionFunction<%=i%>();"></a><b><%=items.get(i).getItemName()%></b></a><br>
  	<a style="text-align:left; color:gray;"><%=items.get(i).getItemUnit() %></a><br>
  	<a style="text-align:left;"><%=items.get(i).getItemPrice()%> 	원</a>
  	</div>	
  <%}%>
		<div style="position: fixed;
					left: 0;
    				bottom: 0;
    				width: 100%;">
  <%
				if(pageNumber != 1) {
			%>
				<a href="inquiryGoods.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%= pageNumber - 1%>&isDesc=<%=isDesc%>&sortBy=<%=sortBy%>" class="btn btn-light btn-arraw-Left">이전</a>
			<%
				} if(itemDAO.nextPage(pageNumber + 1, search, searchText)) {
			%>
				<a href="inquiryGoods.jsp?searchText=<%=searchText%>&search=<%=search%>&pageNumber=<%= pageNumber + 1%>&isDesc=<%=isDesc%>&sortBy=<%=sortBy%>" class="btn btn-light btn-arraw-Left">다음</a>
			<%
				}
			%>						
			<a href="itemAdd.jsp" class="btn btn-primary float-right btn-sm">추가</a>			
			<form action = "itemManage.jsp?searchText=<%=searchText%>&search=<%=search%>&isDesc=<%=isDesc%>" method="post">
			페이지 이동 : 
			<%if(!searchBbs){ %>
			<input type="number" value="<%=pageNumber%>" name="pageNumber" min="1" max="<%=maxPageNum%>"/>
			<input type="submit" class="btn btn-success btn-sm" value="이동">
			<input type="hidden" name="isDesc" value="<%=isDesc%>">
			<input type="hidden" name="sortBy" value="<%=sortBy%>">
			<%} else {%>
			<input type="number" value="<%=pageNumber%>" name="pageNumber" min="1" max="<%=itemDAO.maxPageNum(pageNumber, search, searchText)%>"/>
			<input type="submit" class="btn btn-success btn-sm" value="이동">
			<input type="hidden" name="isDesc" value="<%=isDesc%>">
			<input type="hidden" name="sortBy" value="<%=sortBy%>">
			<%}%>
			</form>	 
		</div>
	</div> 	
</div>	
</body>
</html>