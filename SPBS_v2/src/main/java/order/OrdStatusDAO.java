package order;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class OrdStatusDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public OrdStatusDAO() {
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
	
	public String getStatusInfo(String ordStatus) {
		String SQL = "SELECT orderStatusExplain FROM ordstatus WHERE orderStatus = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, ordStatus);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";
	}
}
