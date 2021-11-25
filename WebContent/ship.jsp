<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Grant's Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";
	// Get customer id !! still need to do this
	String ordId = request.getParameter("orderId"); //get order id
	int orderId = Integer.valueOf(ordId);
	
	//out.println("orderId "+ ordId);
 
	try(Connection con = DriverManager.getConnection(url,uid,pw);){         
		// TODO: Check if valid order id //haven't checked if valid
		//retrieves all items with given id
		Statement stmt = con.createStatement();
		con.setAutoCommit(false); //turn off auto commit
		String sql = "SELECT OP.productId, OP.quantity AS orderQty, PI.quantity as Inventory FROM orderproduct OP JOIN productinventory PI ON OP.productid = PI.productid WHERE OP.orderId = ? ";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1,orderId);
		ResultSet rst = pstmt.executeQuery();
		con.commit();
		//if there are products with that orderid, meaning orderid would be valid
		if(rst.next()){
			//out.println(" orderId "+orderId);

			out.print("<table><tr><th></th><th> </th><th></th><th></th><th></th></tr>");
			boolean sufficient = true;
			while(rst.next()){
				int productId = rst.getInt(1);
				int quantity = rst.getInt(2);
				int inventory = rst.getInt(3);
				int newInventory = inventory - quantity;
				
				if(newInventory > 0){
					String sqlUpdate = "UPDATE productinventory SET quantity= ? WHERE productId = ?";
					PreparedStatement pstmtUpdate = con.prepareStatement(sqlUpdate);
					pstmtUpdate.setInt(1,newInventory);
					pstmtUpdate.setInt(2,productId);
					pstmtUpdate.executeUpdate();
					out.println("<tr><td><h2>Ordered Product: "+ productId + "</h2></td><td><h2>Quantity: "+ quantity+"</h2></td><td><h2>Previous Inventory: "+inventory +"</h2></td><td><h2>New Inventory: "+newInventory +"</h2></td></tr>");
					//stmt.execute("UPDATE productinventory SET quantity= "+newInventory+" WHERE productId = "+productId);
				}else{
					sufficient = false;
					out.println("<tr><h2> Shipment not done. Insufficient inventory for product id: "+productId+" </h2></tr>");
					//con.rollback();
				}
			}
			if(sufficient == true){
				con.commit();
				out.println("<h2>Order executed Successfully.</h2>");

			}else{
				con.rollback();
			}

			out.print("</table>");
		}else{
			out.println("not a valid order");
		}

		
		con.setAutoCommit(true); //turn back on auto commit
	}catch(SQLException ex){
		out.println("Invalid orderid or doesn't exist.");

	}
	// TODO: Retrieve all items in order with given id
	// TODO: Create a new shipment record.
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	//con.rollback();
	// TODO: Auto-commit should be turned back on
	
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
