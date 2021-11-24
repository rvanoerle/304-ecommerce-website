<%@ page language="java" import="java.io.*,java.sql.*"%>

<%@ page import="java.util.ArrayList" %>
<%@ include file="./../jdbc.jsp" %>
<%@ page import="java.sql.*" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	boolean created = false;
	try{
		query(out,request,session);
	}catch(IOException e){	
		System.err.println(e); 
	}
	if(created){
		out.println("Account created successfully.");
	}
	//response.sendRedirect("executeQuery.jsp");		// redirect back to login page with a 
	 
%>

<%!
	void query(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
		String uid = "SA";
		String pw = "YourStrong@Passw0rd";
		String query = request.getParameter("query");
		StringBuilder sb = new StringBuilder();
		boolean retStr = false;
		try {
			Connection con = DriverManager.getConnection(url,uid,pw);
			Statement stmt = con.createStatement();
			ResultSet rst = stmt.executeQuery(query);
			int cols = rst.getMetaData().getColumnCount();
			sb.append("[");
			for (int i = 0; i < cols; i++)
                sb.append(rst.getMetaData().getColumnName(i + 1) + "\t");
			sb.append("]\n");
			while(rst.next()){
				for(int i=0;i<cols;i++){
					sb.append(rst.getString(i+1)+"\t");
				}
				sb.append("");
			} 
			out.println(sb.toString());
			con.close();
		}			
		catch (SQLException ex) {
			out.println(ex);
			session.setAttribute("loginMessage","Error occured while executing query."); 
			retStr =  false;
		}
		//session.setAttribute("loginMessage",sb.toString()); 		
	}
%>