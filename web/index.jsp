<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="moe.xinmu.jsp.Utils" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2019/4/15
  Time: 18:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SQLiteHelper.check(request,response);
    Utils.Status302(request,response,"login.jsp");
%>