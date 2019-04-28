<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="java.io.UTFDataFormatException" %>
<%@ page import="moe.xinmu.jsp.Utils" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2019/4/17
  Time: 16:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
    <%@ include file="/template/link.jsp" %>
    <%SQLiteHelper.check(request,response);
    if(SQLiteHelper.INSTANCE.getMasterSQLHelper().islogin(request,response))
        Utils.Status302(request,response,"/DashPanel.jsp");
    %>
</head>
<body>
<div class="full height">
    <jsp:include page="/template/header.jsp" flush="true" />
    <div class="user signin">
        <div class="ui middle very relaxed page grid">
            <div class="column">
                <form class="ui form" action="api/login.jsp" method="post">
                    <input type="hidden" name="key" value="key">
                    <h3 class="ui top attached header">
                        登录
                    </h3>
                    <div class="ui attached segment">
                        <div class="required inline field ">
                            <label for="user_name">用户名</label>
                            <input id="user_name" name="user_name" value="" autofocus="" required="">
                        </div>
                        <div class="required inline field ">
                            <label for="password">密码</label>
                            <input id="password" name="password" type="password" autocomplete="off" value="" required="">
                        </div>
                        <div class="inline field">
                            <label></label>
                            <button class="ui green button" type="submit">登录</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
    <jsp:include page="/template/footer.jsp" flush="true" />
</body>
</html>
