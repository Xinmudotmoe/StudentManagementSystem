<%@ page import="moe.xinmu.jsp.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="static moe.xinmu.jsp.Utils.fixGarbled" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/24/2019
  Time: 11:20 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int code=0;
    final String[] message=new String[]{
            "成功","您未登录","您无权增加用户","传入值非法"
    };
    if(!SQLiteHelper.check(request,response))
        return;

    MasterSQLHelper sql=SQLiteHelper.INSTANCE.getMasterSQLHelper();
    User user=sql.login(request,response);
    Map<String,String> map= Utils.dePost(request);
    if(user==null){
        code=1;
    }
    if(code==0){
        if(!user.privilegeLevel(Security.userlevel.admin))
            code=2;
    }
    String[] keys=new String[]{"username","loginname","passwd"};
    if(code==0){
        if(Arrays.stream(keys).anyMatch(s -> !map.keySet().contains(s)))
        //如果存在任何一个不包含的Key，则认为异常
            code=3;
    }
    String[] securitys=new String[]{"isadmin","isteacher","isassistant","isstudent"};
    for (String s:securitys)
        map.put(s,((Boolean)map.containsKey(s)).toString());
    if(code==0){
        map.put("username",fixGarbled(map.get("username")));
        sql.addUser(map.get("username"),map.get("loginname"),map.get("passwd"),map.get("isadmin").equals("true"),
                map.get("isteacher").equals("true"),map.get("isassistant").equals("true"),map.get("isstudent").equals("true"),request,response);
    }
%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<script>
alert("信息：<%
    out.print(message[code]);
%>返回值：<%
    out.print(code);
%>。");
window.location.href="<%
    out.print("/sub/UserManagement.jsp");
    %>";
</script>
</body>
</html>
