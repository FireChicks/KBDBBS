package chat;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import message.MessageDAO;

public class ChatDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public ChatDAO() {
		try {
			String dbURL = "jdbc:mysql://192.168.123.111:3306/spbs";
			String dbID = "dldi1021";
			String dbPassword = "@Dlwodbs5025";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<Chat> getChatListByInquiry() {
		ArrayList<Chat> chatList = new ArrayList<Chat>();
		String SQL = "SELECT * FROM CHAT WHERE InquiryType = 0 OR InquiryType = 1 ORDER BY chatTime desc"; 
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Chat chat = new Chat();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID"));
				chat.setToID(rs.getString("toID"));
				chat.setChatContent(rs.getString("chatContent"));
				chat.setInquiryID(rs.getString("inquiryID"));
				chat.setInquiryType(rs.getInt("inquiryType"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11,13));
				String timeType = "오전";
				if(chatTime >= 13) {
					timeType = "오후";
					chatTime -= 12;
				}					
				chat.setChatTime(rs.getString("chatTime").substring(0,11) + " " + timeType + " " + chatTime + " : " + rs.getString("chatTime").substring(14,16) + "" );
				chatList.add(chat);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return chatList;
	}
	
	public ArrayList<Chat> getChatListByID(String fromID, String toID, String chatID) {
		ArrayList<Chat> chatList = new ArrayList<Chat>();
		String SQL = "SELECT * FROM CHAT WHERE (((fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?)) AND chatID > ?) ORDER BY chatTime"; 
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, Integer.parseInt(chatID));
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Chat chat = new Chat();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID"));
				chat.setToID(rs.getString("toID"));
				chat.setChatContent(rs.getString("chatContent"));
				chat.setInquiryID(rs.getString("inquiryID"));
				chat.setInquiryType(rs.getInt("inquiryType"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11,13));
				String timeType = "오전";
				if(chatTime >= 13) {
					timeType = "오후";
					chatTime -= 12;
				}					
				chat.setChatTime(rs.getString("chatTime").substring(0,11) + " " + timeType + " " + chatTime + " : " + rs.getString("chatTime").substring(14,16) + "" );
				chatList.add(chat);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return chatList;
	}
	
	public ArrayList<Chat> getChatListByRecent(String fromID, String toID, int number) {
		ArrayList<Chat> chatList = new ArrayList<Chat>();
		String SQL = "SELECT * FROM CHAT WHERE (fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?) AND chatID > (select MAX(chatID) - ? from chat) ORDER BY chatTime"; 
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, number);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Chat chat = new Chat();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID"));
				chat.setToID(rs.getString("toID"));
				chat.setChatContent(rs.getString("chatContent"));
				chat.setInquiryID(rs.getString("inquiryID"));
				chat.setInquiryType(rs.getInt("inquiryType"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11,13));
				String timeType = "오전";
				if(chatTime >= 13) {
					timeType = "오후";
					chatTime -= 12;
				}					
				chat.setChatTime(rs.getString("chatTime").substring(0,11) + " " + timeType + " " + chatTime + " : " + rs.getString("chatTime").substring(14,16) + "" );
				chatList.add(chat);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return chatList;
	}
	
	public int submit(String fromID, String toID, String chatContent) {
	MessageDAO messageDAO = new MessageDAO();	
	String SQL = "INSERT INTO chat VALUES (NULL, ?, ?, ?, NOW(), null, null)"; 
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, chatContent);
			messageDAO.create(toID, fromID + "님으로부터 메세지가 도착하였습니다. <a href='clientInquiry.jsp?toID=" + fromID +"'>확인</a>");
			return pstmt.executeUpdate();									
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int submitInquiry(String fromID, String toID, String chatContent, String inquiryID, int inquiryType) {
		MessageDAO messageDAO = new MessageDAO();	
		String SQL = "INSERT INTO chat VALUES (NULL, ?, ?, ?, NOW(), ?, ?)"; 
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, fromID);
				pstmt.setString(2, toID);
				pstmt.setString(3, chatContent);
				pstmt.setString(4, inquiryID);
				pstmt.setInt(5, inquiryType);
				if(inquiryType == 0) {
					messageDAO.create(fromID, toID + "님으로부터 상품 문의가 시작되었습니다. <a href='clientInquiry.jsp?toID=" + fromID +"'>확인</a>");
					messageDAO.create(toID, fromID + "상품 문의가 시작되었습니다. <a href='admin/inqurychat.jsp?toID=" + fromID +"'>확인</a>"); //관리자
				} else {
					messageDAO.create(fromID, toID + "님으로부터 주문 문의가 시작되었습니다. <a href='clientInquiry.jsp?toID=" + fromID +"'>확인</a>");
					messageDAO.create(toID, fromID + "주문 문의가 시작되었습니다. <a href='inqurychat.jsp?toID=" + fromID +"'>확인</a>");
				}
				return pstmt.executeUpdate();									
			}catch (Exception e) {
				e.printStackTrace();
			}
			return -1;
		}
}
