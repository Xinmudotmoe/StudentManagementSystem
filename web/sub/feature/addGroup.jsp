<%@ page import="moe.xinmu.jsp.Utils" %>
<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="moe.xinmu.jsp.MasterSQLHelper" %>
<%@ page import="moe.xinmu.jsp.Security" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/26/2019
  Time: 9:34 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
if(!SQLiteHelper.check(request,response))
    return;
    if(!SQLiteHelper.INSTANCE.getMasterSQLHelper().islogin(request,response))
        Utils.Status302(request,response,"/");
    MasterSQLHelper sql=SQLiteHelper.INSTANCE.getMasterSQLHelper();
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
                <h3 class="ui top attached header">增加组</h3>
                <div class="ui attached segment">
                    <h4 class="ui dividing header" style="margin-top: 20px">组信息设置</h4>

                    <form class="ui form" action="${pageContext.request.contextPath}/api/addGroup.jsp" method="post">
                        <div id="sql_settings" class="">
                            <div class="inline required field ">
                                <label for="name">组名</label>
                                <input id="name" name="name" value="" required="">
                            </div>

                            <div  class="inline field ">
                                <label for="info">备注</label>
                                <input id="info" name="info" value="">

                             </div>
                        </div>
                        <h4 class="ui dividing header">权限设置</h4>
                        <div class="inline required field"  tabindex="-1">
                            <label for="management">管理者</label>
                            <div class="ui selection search dropdown">
                                <input id="management" type="hidden" name="management" required="" value="">
                                <div class="text">选择管理者</div>
                                <i class="dropdown icon"></i>
                                <div class="menu" tabindex="-1">
                                    <%String[][] a=sql.getUsers(new Security.userlevel[]{Security.userlevel.assistant});%>
                                    <%
                                        for (String[] aa:a) {
                                    %><div class="item" data-value="<%out.print(aa[0]);%>"><%out.print(aa[1]);%></div><%
                                    }%>
                                </div>
                            </div>
                        </div>
                        <script>
                            $.ready(new function () {
                                $(".ui.dropdown").dropdown();
                            })
                        </script>
                        <div class="ui divider"></div>
                        <div class="inline field">
                            <label></label>
                            <button class="ui primary button" type="submit">增加组</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
