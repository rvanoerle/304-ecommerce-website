<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Grant's Glorious Grocer - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";
	//Locale.setDefault(Locale.US);	
	

//Note: Forces loading of SQL Server driver
	try
	{	// Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	}
	catch (java.lang.ClassNotFoundException e)
	{
		out.println("ClassNotFoundException: " +e);
	}
    // TODO: Retrieve and display info for the product
    // String productId = request.getParameter("id");
	String id = request.getParameter("id");
   
    try(Connection con = DriverManager.getConnection(url,uid,pw);){
        PreparedStatement pstmt = null;
		ResultSet rst = null;

		String sql = "SELECT productId, productName, categoryId, productDesc, productImageURL, productPrice FROM product WHERE productId=?";
		
        pstmt = con.prepareStatement(sql);
    
        pstmt.setString(1,id);
        rst = pstmt.executeQuery();
		//Execute query
		//sql = pstmt.toString();
       
		NumberFormat currencyFor = NumberFormat.getCurrencyInstance();

		// Print out the ResultSet
		while(rst.next()){
    
			int productId = rst.getInt(1);
			String productName = rst.getString(2);
			int categoryId = rst.getInt(3);
			String productDesc = rst.getString(4);
            String productImageURL = rst.getString(5);
			Double productPrice = rst.getDouble(6);
            
			String formatPrice = currencyFor.format(productPrice);
			// For each product create a link of the form
			String productNameAdjusted = java.net.URLEncoder.encode(productName,"UTF-8").replace("+","%20");
			String addCart = "addcart.jsp?id="+productId+"&name="+productNameAdjusted+"&price="+productPrice;
            out.println("<table>");
            out.println("<td><tr>"+productImageURL+"</tr></td>");
            //nead to fix the productImageUrl
            if(productImageURL != null)
                out.println("<tr><td><img src ="+productImageURL+" style='float:left'></td></tr>");
            else{
                out.println("<tr><td><img src ='./img/istockphoto.jpg' width='300' height='300' style='float:left'></td></tr>");
                 out.println("<tr><td> Sorry no photo of item available.</td></tr>");
            }
            out.println("<tr><td> ID: "+id+"</td></tr>");
		    out.print("<tr><td><th> Product Name </th><th> Product Price</th></td></tr>");
			out.println("<tr><td><a href="+addCart+">Add to cart</a></td><td>"+productName+"</a></td><td>"+formatPrice+"</td></tr>");
				
		}
        out.print("</table>");
	// Close connection

	// Useful code for formatting currency values:
	// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	// out.println(currFormat.format(5.0);	// Prints $5.00
	con.close();
	}
	catch(SQLException ex){
		out.println(ex);
	}




// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
//String addCart = "addcart.jsp?id="+productId+"&name="+productNameAdjusted+"&price="+productPrice;
//out.println("<tr><td><a href="+addCart+">Add to cart</a></td><td><a href="+productPage+">"+productName+"</a></td><td>"+formatPrice+"</td></tr>");
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html>

