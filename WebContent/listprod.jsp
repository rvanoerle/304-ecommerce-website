<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";
	Locale.setDefault(Locale.US);	
	

//Note: Forces loading of SQL Server driver
	try
	{	// Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	}
	catch (java.lang.ClassNotFoundException e)
	{
		out.println("ClassNotFoundException: " +e);
	}
	String name = request.getParameter("productName");
	// Variable name now contains the search string the user entered
	// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
	try(Connection con = DriverManager.getConnection(url,uid,pw);){
		String sql = "SELECT productId, productName, categoryId, productDesc, productPrice FROM product";
		boolean hasProduct = name != null && !name.equals("");

		
		PreparedStatement pstmt = null;
		ResultSet rst = null;

		if(hasProduct){
			name = "%"+name+"%";
			sql+= " WHERE productName LIKE ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1,name);
			rst = pstmt.executeQuery();
		
		}else{
			pstmt = con.prepareStatement(sql);
			rst = pstmt.executeQuery();
		}
		//Execute query
		sql = pstmt.toString();
		out.println("<h2>Sql query: "+sql+"</h2>");
		NumberFormat currencyFor = NumberFormat.getCurrencyInstance();
		out.print("<table><tr><th> Product Name </th><th> Product Price</th></tr>");
		// Print out the ResultSet
		while(rst.next()){
			int productId = rst.getInt(1);
			String productName = rst.getString(2);
			int categoryId = rst.getInt(3);
			String productDesc = rst.getString(4);
			Double productPrice = rst.getDouble(5);
			String formatPrice = currencyFor.format(productPrice);
			// For each product create a link of the form
			String productNameAdjusted = java.net.URLEncoder.encode(productName,"UTF-8").replace("+","%20");
			// addcart.jsp?id=productId&name=productName&price=productPrice
			String addCart = "addcart.jsp?id="+productId+"&name="+productNameAdjusted+"&price="+productPrice;
			
			out.println("<tr><td><a href="+addCart+">Add to cart</a></td><td>"+productName+"</td><td>"+formatPrice+"</td></tr>");
				
		}
	// Close connection

	// Useful code for formatting currency values:
	// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	// out.println(currFormat.format(5.0);	// Prints $5.00
		}else{
				out.print("The product searched for is currently unavailable");
		}
	}
	catch(SQLException ex){
		out.println(ex);
	}

%>

</body>
</html>
