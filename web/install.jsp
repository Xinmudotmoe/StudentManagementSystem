<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="static moe.xinmu.jsp.Utils.MapperGet" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.io.File" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2019/4/16
  Time: 16:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HashMap<String,String> get=MapperGet(request);
%>
<html>
<head>
    <title>Install Page</title>
    <%@ include file="/template/link.jsp" %>
</head>
<body>
<%
    SQLiteHelper.INSTANCE=new SQLiteHelper(request.getServletContext());

    if(get.get("force")==null&&SQLiteHelper.INSTANCE.isCreate())
    {
%>
<div class="full height">
    <div class="install">
        <div class="ui middle very relaxed page grid">
            <div class="sixteen wide center aligned centered column">
                <h3 class="ui top attached header">此服务可能已创建，是否要强制配置</h3>
                <div class="ui attached segment">
                    <div class="ui divider"></div>
                    <div class="inline field">
                        <a  href="${pageContext.request.contextPath}/install.jsp?force=1">
                            <button class="ui primary button">确认，强制配置</button>
                        </a>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>
<%}else{%>
<!--UI主体-->
<div class="install">
<div class="full height">
        <div class="ui middle very relaxed page grid">
            <div class="sixteen wide center aligned centered column">
                <h3 class="ui top attached header">安装程序</h3>
                <div class="ui attached segment">
                    <form class="ui form" action="${pageContext.request.contextPath}/api/install.jsp" method="post">
                        <div id="sql_settings" class="">
                            <div class="inline required field ">
                                <label for="db_host">数据库主机</label>
                                <input id="db_host" name="db_host" value="127.0.0.1:3306" placeholder="localhost:3306" required="">
                            </div>
                            <div class="inline required field ">
                                <label for="db_user">数据库用户</label>
                                <input id="db_user" name="db_user" value="root" required="">
                            </div>
                            <div class="inline required field ">
                                <label for="db_passwd">数据库用户密码</label>
                                <input id="db_passwd" name="db_passwd" type="password" value="" required="">
                            </div>
                            <div class="inline required field ">
                                <label for="db_name">数据库名称</label>
                                <input id="db_name" name="db_name" value="jspservices" required="">
                            </div>
                        </div>
                        <h4 class="ui dividing header">应用基本设置</h4>
                        <div class="inline required field">
                            <label for="log_root_path">日志路径</label>
                            <input id="log_root_path" name="log_root_path" value="<%
                                out.print(new File(new URL(new File(request.getServletContext().getRealPath("")).toURI().toURL(),"log").getPath()).getAbsolutePath());
                            %>" placeholder="log" required="">
                            <span class="help">存放日志文件的目录</span>
                        </div>
                        <h4 class="ui dividing header">
                            管理员帐号设置
                        </h4>
                        <div class="ui  optional field">
                            <div class="content">
                                <div class="inline required field ">
                                    <label for="admin_name">管理员用户名</label>
                                    <input id="admin_name" name="admin_name" value="" required="">
                                </div>
                                <div class="inline required field ">
                                    <label for="admin_passwd">管理员密码</label>
                                    <input id="admin_passwd" name="admin_passwd" type="password" value="" required="">
                                </div>
                                <div class="inline required field ">
                                    <label for="admin_confirm_passwd">确认密码</label>
                                    <input id="admin_confirm_passwd" name="admin_confirm_passwd" type="password" value="" required="">
                                </div>
                            </div>
                        </div>
                        <div class="ui divider"></div>
                        <div class="inline field">
                            <label></label>
                            <button class="ui primary button" type="submit">立即安装</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<% }%>
</body>
</html>
