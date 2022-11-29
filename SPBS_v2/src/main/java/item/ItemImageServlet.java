package item;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ItemImageServlet")
public class ItemImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String itemID = request.getParameter("itemID");		
		if(itemID == null || itemID.equals("")) {
			response.getWriter().write("");
		} else {
			itemID = URLDecoder.decode(itemID, "UTF-8");
			String itemImagePath = new ItemDAO().getImage(Integer.parseInt(itemID));						
			if(itemImagePath != null && !itemImagePath.equals("")) {							
				String[] imagePaths = itemImagePath.split("#");
				itemImagePath = imagePaths[0];
			}else{
				itemImagePath	= "/SPBS/resources/이미지 없음.png";
			}					
			response.getWriter().write(itemImagePath + "");
		}
	}

}
