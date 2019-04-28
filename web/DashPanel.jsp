<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="moe.xinmu.jsp.Utils" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/18/2019
  Time: 3:08 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%SQLiteHelper.check(request,response);
if(!SQLiteHelper.INSTANCE.getMasterSQLHelper().islogin(request,response))
    Utils.Status302(request,response,"/login.jsp");
%>
<html>
<head>
    <title>Title</title>
    <%@ include file="/template/link.jsp" %>
<script>
    if(self!==top)
        top.location.href=self.location.href;
    //如果发现页面在iframe内 刷新最外部的网页
    //即 DashPanel拒绝在iframe内运行
</script>
</head>
<body>
<div class="ui full height">
    <jsp:include page="/template/header.jsp" flush="true"/>
    <iframe width="100%" height="88%" src="/template/sidebarAndContainer.jsp" frameborder="no" scrolling="no">
    </iframe>
</div>
<jsp:include page="/template/footer.jsp" flush="true" />
</body>
</html>
