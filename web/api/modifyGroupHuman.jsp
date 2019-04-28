<%@ page import="java.util.*" %>
<%@ page import="moe.xinmu.jsp.*" %>
<%@ page import="java.util.stream.Collectors" %>
<%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/28/2019
  Time: 5:05 PM
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
            "成功","您未登录","您无权删除组内人员","传入值非法"
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
    if(code==0){
        if(!map.containsKey("group"))
            code=3;
    }
    if(code==0){
        List<String> l=map.keySet().stream()
                .filter(s -> s.startsWith("from_internal_id_"))
                .map(s -> s.substring("from_internal_id_".length()))
                .collect(Collectors.toList());
        for (String id:l) {
            sql.modifyGroupHuman(Integer.parseInt(map.get("group")),Integer.parseInt(id),map.containsKey("from_id_inGroup_"+id),request,response);
        }
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
