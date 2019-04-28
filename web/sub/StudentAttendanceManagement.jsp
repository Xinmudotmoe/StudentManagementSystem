<%@ page import="moe.xinmu.jsp.SQLiteHelper" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/22/2019
  Time: 7:56 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SQLiteHelper.check(request,response);
    //SQLiteHelper.INSTANCE.getMasterSQLHelper()
%>
<html>
<head>
    <title>Title</title>
    <%@include file="/template/link.jsp"%>

</head>
<body>
<%
    //todo https://semantic-ui.com/collections/table.html
%>
</body>
</html>
