<%@ page import="moe.xinmu.jsp.Utils" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="static moe.xinmu.jsp.Utils.fixGarbled" %>
<%@ page import="java.nio.charset.StandardCharsets" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/24/2019
  Time: 9:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    SQLiteHelper.check(request,response);
    Map<String,String> m=Utils.dePost(request);
    for (String key:m.keySet()) {
        %><div><%out.println(key+":"+m.get(key));%></div><%
    }


%>
</body>
</html>
