<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="moe.xinmu.jsp.SidebarData" %>
<%@ page import="moe.xinmu.jsp.sidebar.IRootSidebar" %>
<%@ page import="moe.xinmu.jsp.sidebar.ISidebar" %>
<%@ page import="moe.xinmu.jsp.User" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="moe.xinmu.jsp.Security" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/18/2019
  Time: 4:06 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SQLiteHelper.check(request,response);
%>
<html>
<head>
    <title>Title</title>
    <%@ include file="/template/link.jsp" %>
<script type="application/javascript">
    function setlook(url) {
        if(url==="/api/logout.jsp")
            top.location.href=url;
        else
            document.getElementById("jsp_a").src=url;
    }
</script>
</head>
<body>
<div class="ui full height ">
    <div class="ui left vertical menu  visible pusher sidebar">
        <div class="item">你好，<%
        User user=SQLiteHelper.INSTANCE.getMasterSQLHelper().login(request,response);
        Security.userlevel[] userlevels=user.getUserlevels();
        final StringBuffer stringBuffer=new StringBuffer();
        Arrays.stream(userlevels).forEach(userlevel -> stringBuffer.append(userlevel.getI18n()).append("，"));
        out.print(stringBuffer.toString());
        out.print(user.getname());
        %>。</div>
<%
    for (IRootSidebar ir: SidebarData.rs) {
        if(Arrays.stream(userlevels).noneMatch(ir::privilegeLevel))
            continue;
        %><div class="item"><%
        %><div class="header"><%out.print(ir.getName());%></div><%
        %><div class="menu"><%
        for (ISidebar is:ir.getSidebars()) {
            if(Arrays.stream(userlevels).noneMatch(is::privilegeLevel))
                continue;
            %><a class="item" onclick="setlook('<%out.print(is.getURL());%>');"><%
                out.print(is.getName());
            %></a><%
        }
        %></div><%
        %></div><%
    }
        for (ISidebar is:SidebarData.list) {
            if(Arrays.stream(userlevels).noneMatch(is::privilegeLevel))
                continue;

            %><a class="item"  onclick="setlook('<%out.print(is.getURL());%>');"><%
                out.print(is.getName());
            %></a><%
        }
%>
    </div>
    <div class="ui full height" style="margin-left: 260px" >
        <iframe width="100%" height="100%" id="jsp_a" frameborder="no"></iframe>
    </div>
</div>
</body>
</html>
