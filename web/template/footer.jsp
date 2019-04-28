<%@ page import="moe.xinmu.jsp.StaticData" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2019/4/17
  Time: 17:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer>
    <div class="ui container">
        <div class="ui left">
            © <%out.print(new SimpleDateFormat("YYYY").format(new Date()));%> <%out.print(StaticData.AppName);%> 当前版本: 0.01-dev3
        </div>
        <div class="ui right links">
            <a target="_blank" rel="noopener noreferrer" href="<%out.print(StaticData.OfficialWebsite);%>">官网</a>
            <span class="version">0.01</span>
        </div>
    </div>
</footer>
