<%@ page import="java.util.Map" %>
<%@ page import="moe.xinmu.jsp.*" %>
<%@ page import="java.util.Objects" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Arrays" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/22/2019
  Time: 8:47 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //
    int code =0;
    if(!SQLiteHelper.check(request,response))
        return;
    MasterSQLHelper sql=SQLiteHelper.INSTANCE.getMasterSQLHelper();
    User user=sql.login(request,response);
    Map<String,String> map=Utils.MapperGet(request);
    String mode= Objects.requireNonNullElse(map.get("mode"),"null");

    if(user==null)
        code=-1;
    if(code==0){
        if(!user.privilegeLevel(Security.userlevel.admin))
            code=-2;
    }

%>
<html>
<head>
    <title>Title</title>
    <%@include file="/template/link.jsp"%>
</head>
<body>
<%
    if(code!=0){
        //异常值
        %><a class="center ui text"><%
        switch (code){
            case -1:
            %>您未登录，请重新登陆<%
            break;
            case -2:
            %>您无权限，请联系管理员<%
        }
            %></a><%
    }else{
        //正常值
        %><%
        switch (mode){
            case "group":
        %><a class="title">组管理</a>
<form class="ui form" id="form2" action="/api/Post.jsp" method="post">
        <table class="ui celled structured table xmm_asdf">
            <thead>
            <tr>
                <th class="stealth" rowspan="0">选项修改</th>
                <th class="stealth" rowspan="0">数据库id</th>
                <th rowspan="2">组名</th>
                <th rowspan="2">备注</th>
                <th rowspan="2">管理者</th>
                <th rowspan="2">删除此组</th>
                <th rowspan="2">编辑组内人员</th>
            </tr>
            </thead>
            <%
                String[][]dat=sql.showGroups();
                String[][] userss=sql.showUsers();
                Map<String,String[]> m=new HashMap<>();
                for (String[] s:userss) {
                    m.put(s[0],s);
                }
                final String[] keys=new String[]{"id","groupname","info","assistant"};
            %>
            <tbody><%
                for (String[] user1:dat) {
            %><tr><%
                String id="";
                for (int i = 0; i < keys.length; i++) {
                    String s=user1[i];

                    if(i==0){
                        id=s;
            %><td class="stealth">
                <input id="from_internal_id_<%out.print(s);%>"
                       name="from_internal_id_<%out.print(s);%>" type="checkbox"></td><%
                }

            %><td class="field <%
                if (i==0){
                    %> stealth <%
                }else{
                    %> table_visiblely <%
                }%>">
                <%if(i>0){
                %><div class="inline required field"><%
                }%>
                <%if(i==3){%><div class="ui selection search dropdown"><%}%>
                <input
                        <%if(i==3){%> type="hidden" <%}%>id="from_<%
                    out.print(keys[i]+"_"+id);
                    %>" name="from_<%
                    out.print(keys[i]+"_"+id);
                    %>" tabindex="-1"
                    <%%>
                       <%if(i<3){
                        %>value="<%
                        out.print(s);
                     %>"<%
                    }%> onchange='document.getElementById("from_internal_id_<%
                        out.print(id);
                    %>").checked=true' <%
                    if(i==0){
                        %>readonly<%
                    }%>>
                    <%if(i==3){%>
                    <i class="dropdown icon"></i>
                    <div class="default text"><%out.print(m.get(s)[1]);%></div>
                    <div class="menu" tabindex="-1">
                        <%String[][] a=sql.getUsers(new Security.userlevel[]{Security.userlevel.assistant});%>
                        <%
                            for (String[] aa:a) {
                        %><div class="item" data-value="<%out.print(aa[0]);%>"><%out.print(aa[1]);%></div><%
                        }%>
                    </div><%}%>
                        <%if(i==3){%></div><%}%>
                <%if(i>1){
                %></div><%
                }%><%
            %></td><%
                if(i==keys.length-1){
            %>
                <td><a href="/api/removeGroup.jsp?group=<%out.print(id);%>">
                    <div class="ui left floated small red button" >
                        删除此组
                    </div>
                </a></td>
                <td><a href="feature/GroupHumanManagement.jsp?group=<%out.print(id);%>">
                    <div class="ui left floated small blue button" >
                        编辑
                    </div>
                </a></td>
                <%
                        }
                }

            %></tr><%
                }
            %></tbody>

            <tfoot class="full-width">
            <tr>
                <th colspan="8">
                    <a href="feature/addGroup.jsp">
                    <div class="ui right floated small blue button">
                            增加新组
                    </div>
                    </a>
                    <button style="display: none;" id="modify_action_0" form="form2" type="submit"></button>
                    <div class="ui small button" onclick="document.getElementById('modify_action_0').click()">
                        执行
                    </div>
                </th>
            </tr>
            </tfoot>
        </table>
    <script>
        $.ready(new function () {
            $(".ui.dropdown").dropdown();
        })
    </script>
</form>
<%
            break;

            case "human":
                %>
    <a class="title">人员管理</a>
<form class="ui form" id="form1" action="/api/modify_user.jsp" method="post">
    <table class="ui celled structured table xmm_asdf">
        <thead>
        <tr>
            <th class="stealth" rowspan="2">选项修改</th>
            <th class="stealth" rowspan="2">数据库id</th>
            <th rowspan="2">姓名</th>
            <th rowspan="2">登录名</th>
            <th rowspan="2">密码</th>
            <th colspan="4">权限级别</th>
            <th rowspan="2">删除用户</th>
        </tr>
        <tr>
            <th>管理员</th>
            <th>教师</th>
            <th>导员</th>
            <th>学生</th>
        </tr>
        </thead><tbody><%
        String[][] users=sql.showUsers();
        for (String[] user1:users) {
                %><tr><%
            final String[] keyname={"id","name","loginname","passwd","admin","teacher","assistant","student"};
            String id="";
            for (int i = 0; i < keyname.length; i++) {
                String s=user1[i];

                if(i==0){
                    id=s;
                    %><td class="stealth">
                    <input id="from_internal_id_<%out.print(s);%>"
                           name="from_internal_id_<%out.print(s);%>" type="checkbox"></td><%
                }

                %><td class="field <%
                if (i==0){
                    %> stealth <%
                }else{
                    %> table_visiblely <%
                }%>">
                <%if(i>0&&i<4){
                    %><div class="inline required field"><%
                }%>

                    <input id="from_<%
                    out.print(keyname[i]+"_"+id);
                    %>" name="from_<%
                    out.print(keyname[i]+"_"+id);
                    %>" tabindex="0"
                    <%
                    if(i>3){
                        %> class="ui checkbox" type="checkbox" <%
                        if(s.equals("1")){
                            %>checked="checked"<%
                        }
                    }%>
                    <%if(i<3){
                        %>value="<%
                        out.print(s);
                     %>"<%
                    }%> onchange='document.getElementById("from_internal_id_<%
                        out.print(id);
                    %>").checked=true' <%
                    if(i==0){
                        %>readonly<%
                    }%>>
                    <%if(i>1&&i<4){
                        %></div><%
                    }%><%
                %></td><%
                if(i==keyname.length-1){
                    %>
        <td><a href="/api/removeUser.jsp?userid=<%out.print(id);%>">
            <div class="ui left floated small red button" >
                删除此用户
            </div>
    </a></td><%
                }
            }
        %></tr><%
        }
    %></tbody>

        <tfoot class="full-width">
        <tr>
            <th colspan="9">
                <button style="display: none;" id="modify_action" form="form1" type="submit"></button>
                <a href="feature/addUser.jsp"><div class="ui right floated small blue button" >
                    增加新用户
                </div>
                </a>
                <div class="ui small button" onclick='document.getElementById("modify_action").click()' >
                    执行
                </div>
            </th>
        </tr>
        </tfoot>
    </table></form><%
        break;
            default:
            %>
    <a class="ui" href="?mode=human"><button class="ui green button" type="button" >人员管理</button></a>
    <a class="ui" href="?mode=group"><button class="ui green button" type="button" >组管理</button></a>
    <%
        }
%><%
    }
%>
</body>
</html>
