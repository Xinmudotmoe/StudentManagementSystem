package moe.xinmu.jsp;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

public class Utils {
    /**处理所有的GET请求的GET段
     *类似这个
     * http://localhost/sign.jsp?username=asdf&passwd=qwer
     * 输出
     * {"username":"asdf","passwd":"qwer"}
     */

    public static HashMap<String,String> MapperGet(HttpServletRequest request){
        HashMap<String,String> map=new HashMap<>();
        Arrays.stream(requireNonNullElse(request.getQueryString(),"").split("&")).forEach(s->{
            int fg=s.indexOf("=");
            if(fg==-1)
                map.put(s,"");
            else
                map.put(s.substring(0,fg),s.substring(fg+1));
        });
        return map;
    }
    /**处理所有的POST请求的POST段
     *类似这个
     *  username=asdf&passwd=qwer
     * 输出
     * {"username":"asdf","passwd":"qwer"}
     */

    public static HashMap<String,String> dePost(HttpServletRequest request){
        HashMap<String,String> map=new HashMap<>();
        request.getParameterMap().forEach((key,value)-> map.put(key,value.length>=1?value[0]:""));
        return map;
    }
    /**
     *数据库执行辅助函数 用以简化代码
    * */
    public static void execute(String sql, Connection connection) {
        try {
            Statement statement= connection.createStatement();
            statement.execute(sql);
            statement.close();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    /**
     *状态码302 跳转用
     * */
    public static void Status302(HttpServletRequest request,HttpServletResponse response, String url)  {
        if(response.getStatus()==302)
            return;
        response.setStatus(302);
        try {
        response.setHeader("Location",url);
        response.setHeader("Connection","close");

            /*OutputStream os=response.getOutputStream();
            os.flush();
            os.close();*/
        } catch (Exception e) {
            throw new SQLError(e);
        }

    }
    /**
    * Cookies扁平化*/
    public static HashMap<String,String> cookiesToMap(Cookie[] cookies){
        HashMap<String,String> map=new HashMap<>();
        Arrays.stream(cookies).forEach(cookie -> map.put(cookie.getName(),cookie.getValue()));
        return map;
    }

    /**
     * 修复Post乱码
     * @param s
     * @return
     */
    public static String fixGarbled(String s){
        return new String(s.getBytes(StandardCharsets.ISO_8859_1),StandardCharsets.UTF_8);
    }
    public static <T> T requireNonNullElse(T source,T  target){
        return source==null?target:source;
    }
}
