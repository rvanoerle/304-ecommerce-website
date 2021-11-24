<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
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
		response.sendRedirect("index.jsp");		// Successful login
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
		boolean retStr = false;

		if(username == null || password == null)
				return false;
		if((username.length() == 0) || (password.length() == 0))
				return false;
		String sql1 = "Select userid,password from customer where userid like '?'";
		ArrayList<String[]> users = new ArrayList<String[]>();
		try 
		{
			Connection con = DriverManager.getConnection(url,username,password);{
        	PreparedStatement pstmt = con.prepareStatement(sql1);
			pstmt.setString(1, username);
			ResultSet rst = pstmt.executeQuery();
			
			// if we found a userName we will return its password.
			String pass = "";
			while (rst.next()) {
                String curr = (rst.getString(i + 1)); // Get the UserName
				pass = (rst.getString(i + 2));
				String[] user = new String[2];
				user[0] = curr;
				user[1] = pass; 		// to return just the password, we can make this method just return the password and then just check the password with the one entered from the user.
                users.add(user);
            }
			if(pass.equals(username))
				retStr = true;
			else 
				retStr = false;	
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

