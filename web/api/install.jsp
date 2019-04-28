<%@ page import="java.util.Map" %>
<%@ page import="moe.xinmu.jsp.Utils" %>
<%@ page import="moe.xinmu.jsp.SQLiteHelper" %>
<%@ page import="moe.xinmu.jsp.MasterSQLHelper" %>
<%@ page import="java.util.Arrays" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2019/4/17
  Time: 9:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    final int[] code = {0};

    final String[] message = {"成功"};
    Map<String,String> map=Utils.dePost(request);
    Arrays.stream(new String[]{"db_host","db_user","db_passwd","db_name","admin_name","admin_passwd","admin_confirm_passwd"}).forEach(s -> {
        if(!map.keySet().contains(s))    {
            code[0] =-3;
            message[0] ="传入值异常。";
        }
    });

    if(SQLiteHelper.INSTANCE==null)
        SQLiteHelper.INSTANCE=new SQLiteHelper(request.getServletContext());
    if(code[0]==0)
    if(map.values().stream().filter(String::isEmpty).count()>=1)
    {
        code[0] =-1;
        message[0] ="填写项不能为空。";
    }
    if(code[0] ==0){
        if(!map.get("admin_passwd").equals(map.get("admin_confirm_passwd")))
        {
            code[0] =-3;
            message[0] ="密码不一致。";
        }
    }
    if(code[0] ==0)
        if(!SQLiteHelper.INSTANCE.checkMasterCorrect(map.get("db_host"),map.get("db_user"),map.get("db_passwd"),map.get("db_name")))
        {
            code[0] =-2;
            message[0] ="无法连接到此数据库。";
        }
    if(code[0] ==0) {
        //创建mariadb配置表
        SQLiteHelper.INSTANCE.create(map.get("db_host"), map.get("db_user"), map.get("db_passwd"), map.get("db_name"), map.get("log_root_path"));
        MasterSQLHelper masterSQLHelper=SQLiteHelper.INSTANCE.getMasterSQLHelper();
        //创建mariadb的数据库中的表
        masterSQLHelper.create();
        masterSQLHelper.addUser("管理员",map.get("admin_name"), map.get("admin_passwd"), true, false, false, false, request, response);
    }
%>
<html>
<head>
    <title>Install</title>
</head>
<body>

<script>
    alert("信息：<%
out.print(message[0]);
%>返回值：<%
out.print(code[0]);
%>。");
    window.location.href="${pageContext.request.contextPath}<%
    if(code[0]==0)
        out.print("/");
    else
        out.print("/install.jsp");
    %>";
</script>
</body>
</html>