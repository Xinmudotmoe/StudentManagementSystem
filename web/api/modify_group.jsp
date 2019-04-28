<%@ page import="java.util.Map" %>
<%@ page import="moe.xinmu.jsp.*" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/27/2019
  Time: 3:30 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(!SQLiteHelper.check(request,response))
        return;
    int code=0;
    final String[] message=new String[]{
            "成功","您未登录","您无权修改组"
    };

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
    if(code==0){
        ArrayList<String[]> array=new ArrayList<>();
        map.keySet().stream()
                .filter(s->s.startsWith("from_internal_id_"))
                .forEach(s->{
                    String id=s.substring("from_internal_id_".length());
                    String name=Utils.fixGarbled(map.get("from_"+"groupname_"+id));
                    String info=Utils.fixGarbled(map.get("from_"+"info_"+id));
                    String assistant=map.get("from_"+"info_"+id);
                    if(assistant.length()>=1){
                        array.add(new String[]{id,name,info,assistant});
                    }else{
                        array.add(new String[]{id,name,info});
                    }
                });
        array.stream().filter(ss->ss.length==3).forEach(strings -> sql.modifyGroup(Integer.parseInt(strings[0]),strings[1],strings[2],request,response));
        array.stream().filter(ss->ss.length==4).forEach(strings -> sql.modifyGroup(Integer.parseInt(strings[0]),strings[1],strings[2],Integer.parseInt(strings[3]),request,response));
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
