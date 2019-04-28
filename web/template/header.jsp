<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="moe.xinmu.jsp.MasterSQLHelper" %>
<%@ page import="moe.xinmu.jsp.User" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2019/4/17
  Time: 17:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%SQLiteHelper.check(request,response);
    MasterSQLHelper sql=SQLiteHelper.INSTANCE.getMasterSQLHelper();
    User user=sql.login(request,response);

%>
<div class="following bar light">
    <div class="ui container">
        <div class="ui grid">
            <div class="column">
                <div class="ui top secondary menu">
                    <a class="item brand" href="/">
                        <img class="ui mini image" src="/assets/fox.png">
                    </a>
                    <a class="item" href="/">首页</a>
                    <a class="item" href="/announcement.jsp">公告</a>
                    <a class="item" href="/help" target="_blank" rel="noopener noreferrer">帮助</a>
                    <div class="right menu"><%
                        if(user==null){
                      %><a class="item" href="/login.jsp">
                            <i class="octicon octicon-sign-in"></i> 登录
                        </a><%
                        }else{
                      %><a class="item">
                            <i class="octicon">你好，<%
                                out.print(user.getname());
                            %> </i>
                            <a class="item" href="/api/logout.jsp">登出</a>
                        </a>
                        <%}%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>