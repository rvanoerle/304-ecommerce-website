<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="./../jdbc.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%
	boolean authenticatedUser = false;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser)
		response.sendRedirect("./../shop.html");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	boolean validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
		String uid = "SA";
		String pw = "YourStrong@Passw0rd";

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		password = password.toLowerCase().trim();
		boolean retStr = false;
		String pass = "";
		String user = "";

		//if(username == null || password == null)
		//		return false;
		//if((username.length() == 0) || (password.length() == 0))
		//		return false;
		String query = "Select userid,password from customer where userid like '%"+username+"%'";
		try {
			Connection con = DriverManager.getConnection(url,uid,pw);
        	//PreparedStatement pstmt = con.prepareStatement(query);
			//pstmt.setString(1, username);
			Statement stmt = con.createStatement();
			ResultSet rst = stmt.executeQuery(query);

			//ResultSet rst = pstmt.executeQuery();
			int cols = rst.getMetaData().getColumnCount();
			out.println(cols);
			while(rst.next()) {
                user = rst.getString(1); 
				pass = rst.getString(2).toLowerCase().trim();
            }
			if(pass.equals(password))
				retStr = true;
			else{
				session.setAttribute("loginMessage","Invalid password, try again."); 
				return false;
			}	
			con.close();
		} 
		catch (Exception ex) {
			out.println(ex);
			session.setAttribute("loginMessage","Error occured while validating account ."+ex);
		}
		
		
		if(retStr){	
			session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage",("Incorrect username/password.\n Your pass is "+username+":"+pass));

		return retStr;
	
	}
%>



