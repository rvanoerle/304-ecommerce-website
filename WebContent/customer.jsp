<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Locale" %>

<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%		
		String username = (String) session.getAttribute("authenticatedUser");
		if(username != null) {
		String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
		String uid = "SA";
		String pw = "YourStrong@Passw0rd";
		boolean retStr = false;
		//String deletesql = "delete from customer where userid like '%arsh%'";
		//String sql = "Insert into customer (userid,password) values("+info+");";
		String sql = "Select * from customer where userid like '%"+username+"%'";
		try 
		{
			Connection con = DriverManager.getConnection(url,uid,pw);
			Statement stmt = con.createStatement();
			// check if username already exists
			ResultSet rst = stmt.executeQuery(sql);
			int cols = rst.getMetaData().getColumnCount();
			out.println("<h2>"+username+" : Account Info</h2>");
			String col = "";
			String info = "";
			out.println("<table>");
			while(rst.next()){
				for(int i = 0; i < cols; i++){
					if(rst.getMetaData().getColumnName(i + 1).equals("password") )
						continue;
					col = rst.getMetaData().getColumnName(i + 1);
					col = "<tr><td><b>"+col+"\t</b></td>";
					info = "<td>:      "+rst.getString(i+1)+"</td></tr>";
					out.println(col+info+"\n");
				}
				
			}
			out.println("</table>");
			con.close();
		}
		catch (SQLException ex) {
			out.println("SQL error occured : "+ex);
		}
		}else{
			out.println("<h3>No Customer Logged in.</h3>");
		}
		
		
	
%>

</body>
</html>
