package cart;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import item.Item;

public class CartDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public CartDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/SPBS";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public int deleteCart(int cartID) {
		String SQL = "DELETE FROM cart WHERE cartID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, cartID);		
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int getNext() {
		String SQL = "SELECT cartID  FROM cart ORDER BY cartID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int count(String userID) {
		String SQL = "SELECT count(userID)  FROM cart";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int insert(Cart cart) {
		if(count(cart.getUserID()) == 10) {
			return -2;
		}
		String SQL = "INSERT INTO cart VALUE (?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, cart.getUserID());
			pstmt.setInt(3, cart.getItemID());
			pstmt.setInt(4, cart.getQuantity());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public ArrayList<Cart> getCart(String userID) {
		String SQL = "SELECT *  FROM cart WHERE userID = ? ORDER BY cartID DESC";
		ArrayList<Cart> list = new ArrayList<Cart>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Cart cart = new Cart();
				cart.setCartID(rs.getInt(1));
				cart.setUserID(userID);
				cart.setItemID(rs.getInt(3));
				cart.setQuantity(rs.getInt(4));
				list.add(cart);
			}	
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public Item getItem(int itemID) {
		String SQL = "SELECT * FROM item WHERE itemID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, itemID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Item item = new Item();
				item.setItemID(rs.getInt(1));
				item.setItemName(rs.getString(2));
				item.setItemContent(rs.getString(3));
				item.setItemStock(rs.getInt(4));
				item.setItemPrice(rs.getInt(5));
				item.setItemSeason(rs.getString(6));
				item.setItemContentImagePath(rs.getString(7));
				item.setItemContentImageRealPath(rs.getString(8));
				item.setItemSale(rs.getInt(9));
				item.setItemAvailable(rs.getInt(10));
				item.setItemBigCategory(rs.getString(11));
				item.setItemSmallCategory(rs.getString(12));
				item.setItemSaleCount(rs.getInt(13));
				item.setItemUnit(rs.getString(14));
				return item;
			}			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
}
