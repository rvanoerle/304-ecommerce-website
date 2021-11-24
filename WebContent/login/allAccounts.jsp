<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%
	session = request.getSession(true);
	try
	{
		getAccounts(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }
	response.sendRedirect("login.jsp");
%>


<%!
	void getAccounts(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
		String uid = "SA";
		String pw = "YourStrong@Passw0rd";
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		boolean retStr = false;
		String pass = "";
		StringBuilder sb = new StringBuilder();
		//if(username == null || password == null)
		//		return false;
		//if((username.length() == 0) || (password.length() == 0))
		//		return false;
		String sql1 = "Select userid,password from customer";
		ArrayList<String[]> users = new ArrayList<String[]>();
		try {
			Connection con = DriverManager.getConnection(url,uid,pw);
        	Statement st = con.createStatement();
			ResultSet rst = st.executeQuery(sql1);
			
			while (rst.next()) {
				sb.append(rst.getString(1)+",\n");
				sb.append(rst.getString(2)+",\n");
            }
			
			con.close();
		} 
		catch (Exception ex) {
			out.println(ex);
			session.setAttribute("loginMessage","Error while fetching accounts ."+ex);
		}
		
		session.setAttribute("loginMessage",sb.toString());
	
	}
%>