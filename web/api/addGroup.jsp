<%@ page import="java.util.Map" %>
<%@ page import="moe.xinmu.jsp.*" %>
<%@ page import="java.util.Arrays" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/26/2019
  Time: 9:45 PM
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
            "成功","您未登录","您无权增加组","传入值非法"
    };
    User user=sql.login(request,response);
    Map<String,String> map= Utils.dePost(request);
    if(user==null){
        code=1;
    }
    if(code==0){
        if(!user.privilegeLevel(Security.userlevel.admin))
            code=2;
    }
    String[] keys=new String[]{"name","info","management"};
    if(code==0){
        if(Arrays.stream(keys).anyMatch(s -> !map.keySet().contains(s)))
            //如果存在任何一个不包含的Key，则认为异常
            code=3;
    }
    if(code==0){
        map.put("name",Utils.fixGarbled(map.get("name")));
        map.put("info",Utils.fixGarbled(map.get("info")));
        sql.addGroup(map.get("name"),map.get("info"),Integer.parseInt(map.get("management")),request,response);
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
