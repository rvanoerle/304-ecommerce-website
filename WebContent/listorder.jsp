<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
<title>Grant's Glorious Order List</title>
<style type="text/css" media="screen">

	table{
	border-collapse:collapse;
	border:1px solid #000000;
	}
	
	table td{
	border:1px solid #000000;
	}
	</style>
</head>
<body>
<body style="background-color:#90EE90;"></body>
	
	
	<h1 style="color:blue;"> <u>Grant's Glorious Grocer Order List</u></h1>


<%

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

Connection con = null;
Locale.setDefault(Locale.US);

try {

    con = DriverManager.getConnection(url, uid, pw);

	String sql = "SELECT O.orderId, O.orderDate,C.customerId, CONCAT(C.firstName,' ', C.lastName) AS cname, O.totalAmount FROM ordersummary O JOIN customer C on O.customerId = C.customerId";
	PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rst = pstmt.executeQuery();	
	out.println("<table><tr><th>OrderId</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
    
	while (rst.next())
	{	

		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		out.println("<tr><td>"+rst.getInt(1)+"</td>"+"<td>"+rst.getDate(2)+"<td>"+rst.getInt(3)+"</td>"+"<td>"+rst.getString(4)+"<td>"+currFormat.format(rst.getBigDecimal(5))+"</td></tr>");
	    
	
	
	String sql2 = "SELECT OP.productId, OP.quantity, OP.price FROM orderproduct OP JOIN ordersummary O on OP.orderId = O.orderId WHERE OP.orderId = ? ";
	PreparedStatement pstmt2 = con.prepareStatement(sql2);
	pstmt2.setInt(1, rst.getInt(1));
	ResultSet rst2 = pstmt2.executeQuery();
	while (rst2.next()) 
		{
			out.println("<th>Product Id</th> <th>Quantity</th> <th>Price</th></tr>");
			out.println("<tr><td>"+rst2.getInt(1)+"</td>"+"<td>"+rst2.getInt(2)+"<td>"+rst2.getBigDecimal(3)+"</td></tr>");
        }
	  
    } 
	out.println("</table>");

	con.close();
}catch (SQLException ex) 
{ 	out.println(ex); 
}


%>

</body>
</html>
