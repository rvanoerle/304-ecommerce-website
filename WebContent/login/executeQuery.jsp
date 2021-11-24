<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Login to System or Create an Account.</h3>
<body style="background-color:#0066ff;"></body>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<br>
<form name="MyForm" method=get >
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Query :</font></div></td>
	<td><input type="text" name="query"  size=60 maxlength=80></td>
</tr>
</table>
<br/>

<button type="submit" formaction="query.jsp">Run</button>

</form>

</div>

</body>
</html>
