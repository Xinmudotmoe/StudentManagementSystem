<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="moe.xinmu.jsp.Utils" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/24/2019
  Time: 11:39 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SQLiteHelper.check(request,response);
    if(!SQLiteHelper.INSTANCE.getMasterSQLHelper().islogin(request,response))
        Utils.Status302(request,response,"/");
%>
<html>
<head>
    <title>Title</title>
    <%@ include file="/template/link.jsp" %>

</head>
<body>
<div class="install">
    <div class="full height">
        <div class="ui middle very relaxed page grid">
            <div class="sixteen wide center aligned centered column">
                <h3 class="ui top attached header">增加用户</h3>
                <div class="ui attached segment">
                    <h4 class="ui dividing header" style="margin-top: 20px">用户信息设置</h4>

                    <form class="ui form" action="${pageContext.request.contextPath}/api/addUser.jsp" method="post">
                        <div id="sql_settings" class="">
                            <div class="inline required field ">
                                <label for="username">用户姓名</label>
                                <input id="username" name="username" value="" required="">
                            </div>
                            <div class="inline required field ">
                                <label for="loginname">登录名</label>
                                <input id="loginname" name="loginname" value="" required="">
                            </div>
                            <div class="inline required field ">
                                <label for="passwd">用户密码</label>
                                <input id="passwd" name="passwd" type="password" value="" required="">
                            </div>
                        </div>
                        <h4 class="ui dividing header">权限设置</h4>
                        <div class="ui  optional field">
                            <div class="content">
                                <div class="field">
                                    <div class="ui checkbox">
                                        <input id="isadmin" name="isadmin" type="checkbox" tabindex="0">
                                        <label>管理员权限</label>
                                    </div>
                                </div>
                                <div class="field">
                                    <div class="ui checkbox">
                                        <input id="isteacher" name="isteacher" type="checkbox" tabindex="0">
                                        <label>教师权限</label>
                                    </div>
                                </div>
                                <div class="field">
                                    <div class="ui checkbox">
                                        <input id="isassistant" name="isassistant" type="checkbox" tabindex="0" >
                                        <label>导员权限</label>
                                    </div>
                                </div>
                                <div class="field">
                                    <div class="ui checkbox">
                                        <input id="isstudent" name="isstudent" type="checkbox" tabindex="0" >
                                        <label>学生权限</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ui divider"></div>
                        <div class="inline field">
                            <label></label>
                            <button class="ui primary button" type="submit">增加用户</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
