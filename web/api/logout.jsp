<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="moe.xinmu.jsp.Utils" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/22/2019
  Time: 5:26 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SQLiteHelper.check(request,response);
    ArrayList<String>keys=new ArrayList<>(Arrays.asList("username", "passwd"));
        Arrays.stream(request.getCookies()).filter(cookie -> keys.contains(cookie.getName()))
                .forEach(cookie -> {
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                });
    Utils.Status302(request,response,"/login.jsp");
%>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html>
