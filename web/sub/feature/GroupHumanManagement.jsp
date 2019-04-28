<%@ page import="moe.xinmu.jsp.*" %>
<%@ page import="java.util.*" %>
<%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/28/2019
  Time: 4:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(!SQLiteHelper.check(request,response)){
        return;
    }
    MasterSQLHelper sql=SQLiteHelper.INSTANCE.getMasterSQLHelper();
    int code=0;
    final String[] message=new String[]{
            "成功","您未登录","您无权删除组","传入值非法"
    };

    User user=sql.login(request,response);
    Map<String,String> map= Utils.MapperGet(request);
    if(user==null){
        code=1;
    }
    if(code==0){
        if(!user.privilegeLevel(Security.userlevel.admin))
            code=2;
    }
    if(code==0){
        if(!map.containsKey("group"))
            code=3;
    }
    ArrayList<Integer> existing_User=new ArrayList<>();
    String[][] users=new String[0][0];
    if(code!=0){
        Utils.Status302(request,response,"/login.jsp");
    }
    else{
        Integer[] il=sql.getGroupHuman(Integer.parseInt(map.get("group")),request,response);
        existing_User.addAll(Arrays.asList(il));
        users=sql.showUsers();
    }
%>
<html>
<head>
    <title>Title</title>
    <%@include file="/template/link.jsp"%>

</head>
<body>
<%if(code==0){%>
    <div class="ui full height">
        <div class="ui search">
            <div class="ui icon input">
                <input class="prompt" type="text" placeholder="搜索指定用户">
                <i class="search icon"></i>
            </div>
            <div class="results"></div>
        </div>
        <form class="form ui" id="form" action="/api/modifyGroupHuman.jsp" method="post">
            <input class="stealth" name="group" value="<%out.print(map.get("group"));%>">
        <table class="ui celled structured table xmm_asdf">
            <thead>
            <tr>
                <th class="stealth" rowspan="0">选项修改</th>
                <th class="stealth" rowspan="0">用户id</th>
                <th rowspan="2">用户名称</th>
                <th rowspan="2">登录名称</th>
                <th rowspan="2">现有权限</th>
                <th rowspan="2">是否在组内组</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (String[] s:users) {
                    Integer id=Integer.parseInt(s[0]);

                    %><tr><%
                        %><td class="stealth">
                        <input id="from_internal_id_<%out.print(id);%>"
                        name="from_internal_id_<%out.print(id);%>" type="checkbox"></td>
                        <td class="stealth">
                        <a><%out.print(id);%></a>
                        </td>
                <td >
                    <a><%out.print(s[1]);%></a>
                </td>
                <td >
                    <a><%out.print(s[2]);%></a>
                </td>
                <td>
                    <a><%
                        StringJoiner sb=new StringJoiner("，");
                        if(s[4].equals("1"))
                            sb.add(Security.userlevel.admin.getI18n());
                        if(s[5].equals("1"))
                            sb.add(Security.userlevel.teacher.getI18n());
                        if(s[6].equals("1"))
                            sb.add(Security.userlevel.assistant.getI18n());
                        if(s[7].equals("1"))
                            sb.add(Security.userlevel.student.getI18n());
                        out.print(sb.toString());
                    %></a>
                </td>
                <td class="table_visiblely">
                    <input id="from_id_inGroup_<%out.print(id);%>"
                           name="from_id_inGroup_<%out.print(id);%>"
                           class="ui checkbox" type="checkbox"
                    <%if(existing_User.contains(id)){
                            %>checked="checked"<%
                        }%>
                           onchange='document.getElementById("from_internal_id_<%
                        out.print(id);
                    %>").checked=true'>
                </td>
                <%

                    %><%%><%%><%%><%%><%%><%%><%%></tr><%
                }
            %>

            </tbody>
            <tfoot>
            <tr >
                <th colspan="9">
            <button style="display: none;" id="modify_action" form="form" type="submit"></button>

            <div class="ui small button" onclick='document.getElementById("modify_action").click()' >
                执行
            </div>
                </th>
            </tr>
            </tfoot>
        </table>
        </form>
    </div>
<%}%>
</body>
</html>
