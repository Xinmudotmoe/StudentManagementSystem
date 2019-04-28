<%@ page import="moe.xinmu.jsp.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 4/25/2019
  Time: 8:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(!SQLiteHelper.check(request,response))
        return;
    int code=0;
    final String[] message=new String[]{
            "成功","您未登录","您修改增加用户"
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
                    String name=Utils.fixGarbled(map.get("from_"+"name_"+id));
                    String loginname=map.get("from_"+"loginname_"+id);
                    String passwd=map.get("from_"+"passwd_"+id);
                    String admin= String.valueOf(map.get("from_" + "admin_" + id) != null);
                    String teacher=String.valueOf(map.get("from_"+"teacher_"+id) != null);
                    String assistant=String.valueOf(map.get("from_"+"assistant_"+id) != null);
                    String student=String.valueOf(map.get("from_"+"student_"+id) != null);
                    if(passwd.length()>1){
                        array.add(new String[]{id,name,loginname,passwd,admin,teacher,assistant,student});
                    }else{
                        array.add(new String[]{id,name,loginname,admin,teacher,assistant,student});
                    }
                });
        array.stream().filter(ss->ss.length==7).forEach(strings -> sql.modifyUser(Integer.parseInt(strings[0]),strings[1],strings[2],Boolean.parseBoolean(strings[3]),Boolean.parseBoolean(strings[4]),Boolean.parseBoolean(strings[5]),Boolean.parseBoolean(strings[6]),request,response));
        array.stream().filter(ss->ss.length==8).forEach(strings -> sql.modifyUser(Integer.parseInt(strings[0]),strings[1],strings[2],strings[3],Boolean.parseBoolean(strings[4]),Boolean.parseBoolean(strings[5]),Boolean.parseBoolean(strings[6]),Boolean.parseBoolean(strings[7]),request,response));
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
