<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="./../jdbc.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	boolean created = false;
	try{
		 created = (boolean) createLogin(out,request,session);
	}catch(IOException e){	
		System.err.println(e); 
	}
	if(created){
		out.println("Account created successfully.");
	}
	response.sendRedirect("login.jsp");		// redirect back to login page with a 
	 
%>

<%!
	boolean createLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
		String uid = "SA";
		String pw = "YourStrong@Passw0rd";
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		boolean retStr = false;
		if(username == null || password == null)
				return false;
		if((username.length() == 0) || (password.length() == 0))
				return false;
		String info = "'"+username+"','"+password+"'";
		//String deletesql = "delete from customer where userid like '%arsh%'";
		String sql = "Insert into customer (userid,password) values("+info+");";
		String sql1 = "Select userid,password from customer where userid like '%"+username+"%'";
		try 
		{
			Connection con = DriverManager.getConnection(url,uid,pw);
			Statement stmt = con.createStatement();
			// check if username already exists
			ResultSet rst = stmt.executeQuery(sql1);
			while(rst.next()){
				session.setAttribute("loginMessage","Account already exists");
				return false;
			} 
			stmt.executeUpdate(sql);
			con.close();
		}			
		catch (SQLException ex) {
			out.println(ex);
			session.setAttribute("loginMessage","Error occured while creating account ."+ex); 
			retStr =  false;
		}
		finally{
		
		out.println("Account created with username %s successfully, try logging in again.");
		retStr =  true;
		return retStr;
		}
		
	}
%>