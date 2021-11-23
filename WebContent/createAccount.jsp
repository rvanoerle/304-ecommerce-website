<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		boolean created = createLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }
	response.sendRedirect("login.jsp");		// redirect back to login page with a 

	} 
%>

<%!
	boolean createLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
		String uid = "SA";
		String pw = "YourStrong@Passw0rd";
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return false;
		if((username.length() == 0) || (password.length() == 0))
				return false;
		String sql = "Insert into customer (userid,password) values("+username+","+password+")";

		try 
		{
			Connection con = DriverManager.getConnection(url,username,password);{
			Statement stmt = con.createStatement();
			stmt.executeUpdate(sql);			
		} 
		catch (SQLException ex) {
			out.println(ex);
			out.println("Account not created");
			return false;
		}
		finally
		{
			closeConnection();
		}	
		
		out.println("Account created successfully, try logging in again.");
		return true;

		
	}
%>
