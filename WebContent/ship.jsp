<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Grant's Grocery Shipment Processing</title>
</head>
<body>
<body style="background-color:#90EE90;"></body>
        
<%@ include file="header.jsp" %>

<%
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";

	Locale.setDefault(Locale.US);
	// Get customer id !! still need to do this
	String ordId = request.getParameter("orderId"); //get order id
	int orderId = Integer.valueOf(ordId);

	
	out.println("<h2>Order Id:  "+ ordId+"</h2>");
 
	try(Connection con = DriverManager.getConnection(url,uid,pw);){         
		// TODO: Check if valid order id //haven't checked if valid
		//retrieves all items with given id
		Statement stmt = con.createStatement();
		con.setAutoCommit(false); //turn off auto commit
		String sql = "SELECT OP.productId, OP.quantity AS orderQty, PI.quantity as Inventory FROM orderproduct OP JOIN productinventory PI ON OP.productid = PI.productid WHERE OP.orderId = ? AND PI.wareHouseId =1 ";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1,orderId);
		ResultSet rst = pstmt.executeQuery();
		
		//if there are products with that orderid, meaning orderid would be valid
		if(rst.isBeforeFirst() ) {
			//out.println(" orderId "+orderId);
			out.print("<table><tr><th></th><th> </th><th></th><th></th><th></th></tr>");
			boolean sufficient = true;
			while(rst.next()){
				int productId = rst.getInt(1);
				int quantity = rst.getInt(2);
				int inventory = rst.getInt(3);
				int newInventory = inventory - quantity;
				
				if(newInventory >= 0){
					String sqlUpdate = "UPDATE productinventory SET quantity= ? WHERE productId = ?";
					PreparedStatement pstmtUpdate = con.prepareStatement(sqlUpdate);
					pstmtUpdate.setInt(1,newInventory);
					pstmtUpdate.setInt(2,productId);
					pstmtUpdate.executeUpdate();
					out.println("<tr><td><h2>Ordered Product: "+ productId + "</h2></td><td><h2>Quantity: "+ quantity+"</h2></td><td><h2>Previous Inventory: "+inventory +"</h2></td><td><h2>New Inventory: "+newInventory +"</h2></td></tr>");
					stmt.execute("UPDATE productinventory SET quantity= "+newInventory+" WHERE productId = "+productId);
				}else{
					sufficient = false;
					out.println("<tr><h2> Shipment not done. Insufficient inventory for product id: "+productId+" </h2></tr>");
					//con.rollback();
				}
			}
			out.print("</table>");
			if(sufficient == true){
				
				String insertSql = "INSERT shipment (shipmentDate,shipmentDesc,warehouseId) VALUES (?,?,?)";
				PreparedStatement insertPstmt = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
				String s = "Shipment contains product(s) from order  #" +orderId;
				insertPstmt.setDate(1,new java.sql.Date(System.currentTimeMillis()));
				insertPstmt.setString(2,s);
				insertPstmt.setInt(3,1);
                
				insertPstmt.executeUpdate();
				ResultSet keys = insertPstmt.getGeneratedKeys();
				keys.next();
		        int shipmentId = keys.getInt(1);
				String sql2 = "SELECT * FROM shipment";
	            PreparedStatement pstmt2 = con.prepareStatement(sql2);
                ResultSet rst2 = pstmt2.executeQuery();	
				
					while (rst2.next()){
						out.println("<tr><td><h2>ShipmentId: "+ rst2.getInt(1) + "</h2></td><td><h2>Date: "+rst2.getDate(2)+"</h2></td><td><h2>Description: "+rst2.getString(3) +"</h2></td><td><h2>WarehouseId: "+rst2.getInt(4) +"</h2></td></tr>");
						
					}
	
				con.commit();
				out.println("<h2>Shipment succesfully proccesed.</h2>");
			}else{
				con.rollback();
			}
			
		}else{
			out.println("<h2>Not a valid order</h2>");
		}
		
		con.setAutoCommit(true); //turn back on auto commit
	}catch(SQLException ex){
		out.println(ex);
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