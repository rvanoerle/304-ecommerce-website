<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Grant's Glorious Grocery Order Processing</title>
</head>
<body>
<body style="background-color:#90EE90;"></body>
<% 
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
// Make connection
try(Connection con = DriverManager.getConnection(url,uid,pw);){
// Determine if valid customer id was entered
  
	String sql = "SELECT * FROM customer WHERE customerId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	Integer customerId = Integer.valueOf(custId);
	pstmt.setInt(1,customerId);
	ResultSet rst = pstmt.executeQuery();
  
	
  
// Determine if there are products in the shopping cart
// If either are not true, display an error message
	if(rst.next() & productList != null){
		// Use retrieval of auto-generated keys.
		String insertSql = "INSERT ordersummary (customerId,totalAmount) VALUES (?,?)";
		PreparedStatement insertPstmt = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);			
		insertPstmt.setInt(1,customerId);
		insertPstmt.setDouble(2,0.0);

		
		insertPstmt.executeUpdate();
		ResultSet keys = insertPstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);

		double totalAmount = 0.0;
		NumberFormat currencyFor = NumberFormat.getCurrencyInstance();

		out.print("<h1>Your Order Summary</h1>");

		out.print("<table><tr><th> Product Id </th><th> Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext())
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			int productIdAdj = Integer.parseInt(productId);
			String productName = (String) product.get(1);
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			String formatPrice = currencyFor.format(pr);
			int qty = ( (Integer)product.get(3)).intValue();

			double currentTotal = pr * qty;
			String formatCurrentTotal = currencyFor.format(currentTotal);
			totalAmount += currentTotal;
			
			
			out.print("<tr><td>"+productId+"</td><td>"+productName +"</td><td>"+qty+"</td><td>"+formatPrice+"</td><td>"+formatCurrentTotal+"</td></tr>");

			// Insert each item into OrderProduct table using OrderId from previous INSERT
			String insertOrderProduct = "INSERT orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
			PreparedStatement pstmtInsertOrderProduct = con.prepareStatement(insertOrderProduct);
			pstmtInsertOrderProduct.setInt(1, orderId);
			pstmtInsertOrderProduct.setInt(2, productIdAdj);
			pstmtInsertOrderProduct.setInt(3, qty);
			pstmtInsertOrderProduct.setDouble(4, pr);
			
			pstmtInsertOrderProduct.executeUpdate();

		
		}
		
		String formatTotalAmount = currencyFor.format(totalAmount);
		out.print("<tr><td> Order Total: "+formatTotalAmount+"</td></tr>");
		// Update total amount for order record
		String updateTotal = "UPDATE ordersummary SET totalAmount = ?,orderDate = ? WHERE orderId = ?";
		PreparedStatement pstmtUpdateTotal = con.prepareStatement(updateTotal);
		pstmtUpdateTotal.setDouble(1, totalAmount);
		pstmtUpdateTotal.setDate(2,new java.sql.Date(System.currentTimeMillis()));
		pstmtUpdateTotal.setInt(3, orderId);
		pstmtUpdateTotal.executeUpdate();



		out.print("</table>");
		out.print("<h1>Order completed. Will be shipped soon...</h1>");
		out.print("<h1>Your order reference number is:"+ orderId +"</h1>");
		String customerLastName = rst.getString(3);
		String customerFirstName = rst.getString(2);
		out.print("<h1>Shipping to customer:"+ custId +" Name:"+customerFirstName+ " " +customerLastName+"</h1>");
		session.invalidate(); //clearing the cart
	
	}else{
		out.println("<h1>Invalid id or nothing in the cart</h1>");
		session.invalidate(); //clearing the cart
	}
	con.close(); //close the connection

}
catch(Exception e ){
	out.println("Invalid customer id. Go back to previous page and try again.");
}
%>
</BODY>
</HTML>

