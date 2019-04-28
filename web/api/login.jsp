<%@ page import="moe.xinmu.jsp.Utils" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.Writer" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="moe.xinmu.jsp.SQLiteHelper" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2019/4/18
  Time: 10:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SQLiteHelper.check(request,response);
    Map<String,String> map=Utils.dePost(request);
    final int[] code = {0};
    Arrays.stream(new String[]{"key",
            "user_name",
            "password"}).forEach(s -> {
        if(!map.keySet().contains(s))
            code[0] =-1;
    });
    if(map.get("key").equals("key"))
        code[0]=-2;
%>
<html>
<head>

</head>
<body>
<%
    final Writer w=out;
    Utils.dePost(request).forEach((key,value)->{
    try {
        w.append("<div>");
        w.append(key).append(",").append(value);
        w.append("</div>");
    } catch (IOException e) {
        e.printStackTrace();
    }
});
    if(SQLiteHelper.INSTANCE.getMasterSQLHelper().login(request,response,map.get("user_name"),map.get("password")))
        Utils.Status302(request,response,"/DashPanel.jsp");
    else
        Utils.Status302(request,response,"/login.jsp");

%>
</body>
</html>