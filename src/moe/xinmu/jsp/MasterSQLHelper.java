package moe.xinmu.jsp;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;

public class MasterSQLHelper {
    private static String dbtype;
    static {
        Throwable err=new Throwable();
        boolean get=false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            dbtype="mysql";
            get=true;
        } catch (ClassNotFoundException e) { err=e;}
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            dbtype="mariadb";
            get=true;
        } catch (ClassNotFoundException e) { err=e;}
        if(!get)
            throw new SQLError("无法寻找到任何一个可使用的数据库驱动。",err);
    }
    private  Connection connection;
    public MasterSQLHelper(String host,String user,String pass,String dbname){
        Error error=new IllegalAccessError("非法访问");
        if(!error.getStackTrace()[1].getClassName().equals(SQLiteHelper.class.getName()))
            throw error;
        try {
            connection=DriverManager.getConnection("jdbc:" + dbtype + "://" + host + "/" + dbname + "?user=" + user + "&password=" + pass);
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public void create(){
        Arrays.stream(createtables).forEach(this::execute);
    }
    public void addUser(String username,
                        String loginname,
                        String pass,
                        boolean isadmin,
                        boolean isteacher,
                        boolean isassistant,
                        boolean isstudent,
                        HttpServletRequest request,
                        HttpServletResponse response){
        Objects.requireNonNull(request);
        Objects.requireNonNull(response);
        String uri=request.getRequestURI();
        Log.i("SQL_AddUser","url is:"+uri);
        try {
            PreparedStatement ps=connection.prepareStatement("insert into human(name,loginname,passwd,isadmin,isteacher,isassistant,isstudent)values(?,?,sha1(?),?,?,?,?);");
            ps.setString(1,username);
            ps.setString(2,loginname);
            ps.setString(3,pass);
            ps.setBoolean(4,isadmin);
            ps.setBoolean(5,isteacher);
            ps.setBoolean(6,isassistant);
            ps.setBoolean(7,isstudent);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public boolean login(HttpServletRequest request, HttpServletResponse response,String name,String passwd){
        Objects.requireNonNull(request);
        Objects.requireNonNull(response);
        String uri=request.getRequestURI();
        Log.i("SQL_login","url is:"+uri);
        boolean out=false;
        try {
            PreparedStatement ps=connection.prepareStatement("select count(*) from human where loginname=? and passwd=sha(?);");
            ps.setString(1,name);
            ps.setString(2,passwd);
            ResultSet rs=ps.executeQuery();
            rs.first();
            out = rs.getInt(1) == 1;
        }catch (SQLException s){
            throw new SQLError(s);
        }
        if(out)
        {
            Cookie cookie=new Cookie("username",name);
            cookie.setMaxAge(12000);
            cookie.setPath("/");
            response.addCookie(cookie);
            cookie=new Cookie("passwd",passwd);
            cookie.setMaxAge(12000);
            cookie.setPath("/");
            response.addCookie(cookie);
        }
        return out;
    }
    public boolean islogin(HttpServletRequest request, HttpServletResponse response){
        return login(request,response)!=null;
    }
    public User login(HttpServletRequest request, HttpServletResponse response){
        Objects.requireNonNull(request);
        Objects.requireNonNull(response);
        ArrayList<String> keys=new ArrayList<>(Arrays.asList("username", "passwd"));
        HashMap<String,String> hashMap=new HashMap<>();
        Cookie[] cookies=request.getCookies();
        Arrays.stream(cookies).filter(cookie -> keys.contains(cookie.getName())).forEach(cookie -> hashMap.put(cookie.getName(),cookie.getValue()));
        if(hashMap.keySet().size()==2){
            try {
                PreparedStatement ps=connection.prepareStatement("select internal_id,name,isadmin,isteacher,isassistant,isstudent from human where loginname=? and passwd=sha(?);");
                ps.setString(1,hashMap.get("username"));
                ps.setString(2,hashMap.get("passwd"));
                ResultSet rs=ps.executeQuery();
                rs.first();
                ArrayList<Security.userlevel>al=new ArrayList<>();
                if(rs.getBoolean("isadmin"))
                    al.add(Security.userlevel.admin);
                if(rs.getBoolean("isteacher"))
                    al.add(Security.userlevel.teacher);
                if(rs.getBoolean("isassistant"))
                    al.add(Security.userlevel.assistant);
                if(rs.getBoolean("isstudent"))
                    al.add(Security.userlevel.student);
                return new User(rs.getInt(1),rs.getString("name"),al.toArray(new Security.userlevel[0]));
            } catch (SQLException e) {
                throw new SQLError(e);
            }
        }
        else
            return null;
    }
    public static final String[] createtables=new String[]{
            //人员相关的库
            "CREATE TABLE human (\n" +
                    "    internal_id INTEGER PRIMARY KEY AUTO_INCREMENT,\n" +
                    "    name VARCHAR(16) NOT NULL,\n" +
                    "    loginname VARCHAR(16) UNIQUE NOT NULL,\n" +
                    "    passwd VARCHAR(40) NOT NULL,\n" +
                    "    isadmin BOOLEAN NOT NULL,\n" +
                    "    isteacher BOOLEAN NOT NULL,\n" +
                    "    isassistant BOOLEAN NOT NULL,\n" +
                    "    isstudent BOOLEAN NOT NULL\n" +
                    ");",
            //组管理表
            "create table group_table (\n" +
                    "    id INTEGER AUTO_INCREMENT unique,\n" +
                    "    groupname VARCHAR (16) unique,\n" +
                    "    info varchar(256),\n" +
                    "    assistant integer,\n" +
                    "    CONSTRAINT gh_assistant_foreign\n" +
                    "        FOREIGN  KEY(assistant) references human(internal_id),\n" +
                    "    PRIMARY KEY(id)\n" +
                    ");",
            //人员/组对应表
            "CREATE TABLE group_human (\n" +
                    "    id INTEGER ,\n" +
                    "    user_id INTEGER ,\n" +
                    "    CONSTRAINT gh_groud_foreign\n" +
                    "        FOREIGN  KEY(id) references group_table(id),\n" +
                    "    CONSTRAINT gh_user_foreign\n" +
                    "        FOREIGN  KEY(user_id) references human(internal_id),\n" +
                    "    PRIMARY KEY(id,user_id)\n" +
                    ");",
            //公告表
            "create table announcement(\n" +
                    "    id integer PRIMARY KEY AUTO_INCREMENT,\n" +
                    "    author INTEGER not null,\n" +
                    "    title text not null,\n" +
                    "    content text not null,\n" +
                    "    permission_group text,\n" +
                    "    permission_group_limit boolean not null,\n" +
                    "    permission_teacher boolean not null,\n" +
                    "    permission_assistant boolean not null,\n" +
                    "    permission_student boolean not null,\n" +
                    "    permission_public boolean not null,\n" +
                    "    permission_visible boolean not null,\n" +
                    "    CONSTRAINT am_author_foreign\n" +
                    "        FOREIGN KEY(author) references human(internal_id),\n" +
                    "    check(!permission_public||(permission_teacher&&permission_assistant&&permission_student&&permission_public))\n" +
                    ");",
            //课表表
            "create table timetable(\n" +
                    "    id integer PRIMARY KEY AUTO_INCREMENT,\n" +
                    "    tb_name text,\n" +
                    "    target_groud integer,\n" +
                    "    start_date date,\n" +
                    "    week_day integer,\n" +
                    "    end_date date,\n" +
                    "    order_time integer,\n" +
                    "    teacher integer,\n" +
                    "    CONSTRAINT tt_groud_foreign\n" +
                    "        FOREIGN  KEY(target_groud) references group_table(id),\n" +
                    "    CONSTRAINT tt_teacher_foreign\n" +
                    "        FOREIGN  KEY(teacher) references human(internal_id),\n" +
                    "    check(week_day>=0&&week_day <=6),\n" +
                    "    check(order_time>=1&&order_time<=5)\n" +
                    ");\n",
            //考勤表
            "create table attendance(\n" +
                    "    count_id integer,\n" +
                    "    timetable_id integer,\n" +
                    "    student_id integer,\n" +
                    "    work_status integer,\n" +
                    "    CONSTRAINT ad_timetable_id_foreign\n" +
                    "        FOREIGN  KEY(timetable_id) references timetable(id),\n" +
                    "    CONSTRAINT ad_student_id_foreign\n" +
                    "        FOREIGN  KEY(student_id) references human(internal_id),\n" +
                    "    PRIMARY KEY (count_id,timetable_id,student_id)\t\n" +
                    ");"
    };
    @Deprecated
    private static final String[] droptable=new String[]{
            "DROP TABLE attendance;" ,
            "DROP TABLE timetable;" ,
            "DROP TABLE announcement;" ,
            "DROP TABLE group_human;" ,
            "DROP TABLE group_table;" ,
            "DROP TABLE human;"
    };
    //
    private void execute(String sql){
        Utils.execute(sql, connection);
    }
    public String[][] showGroups(){
        ArrayList<String[]> a= new ArrayList<>();
        try {
            Statement s=connection.createStatement();
            ResultSet rs=s.executeQuery("select * from group_table");
            while (rs.next()){
                String[] dat=new String[4];
                dat[0]=rs.getString(1);
                dat[1]=rs.getString(2);
                dat[2]=rs.getString(3);
                dat[3]=rs.getString(4);
                a.add(dat);
            }
        } catch (SQLException e) {
            throw new SQLError(e);
        }
        return a.toArray(new String[0][0]);
    }
    public String[][] showUsers(){
        ArrayList<String[]> a= new ArrayList<>();
        try {
            Statement s=connection.createStatement();
            ResultSet rs=s.executeQuery("select * from human");
            while (rs.next()){
                String[] dat=new String[8];
                dat[0]=rs.getString(1);
                dat[1]=rs.getString(2);
                dat[2]=rs.getString(3);
                dat[3]=rs.getString(4);
                dat[4]=rs.getString(5);
                dat[5]=rs.getString(6);
                dat[6]=rs.getString(7);
                dat[7]=rs.getString(8);
                a.add(dat);
            }
        } catch (SQLException e) {
            throw new SQLError(e);
        }
        return a.toArray(new String[0][0]);
    }
    public void modifyUser(int id,
                        String username,
                        String loginname,
                        String pass,
                        boolean isadmin,
                        boolean isteacher,
                        boolean isassistant,
                        boolean isstudent,
                        HttpServletRequest request,
                        HttpServletResponse response){
        try {
            PreparedStatement ps=connection.prepareStatement("update human set name=?,loginname=?,passwd=sha1(?),isadmin=?,isteacher=?,isassistant=?,isstudent=? where internal_id=?;");
            ps.setString(1,username);
            ps.setString(2,loginname);
            ps.setString(3,pass);
            ps.setBoolean(4,isadmin);
            ps.setBoolean(5,isteacher);
            ps.setBoolean(6,isassistant);
            ps.setBoolean(7,isstudent);
            ps.setInt(8,id);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public void modifyUser(int id,
                           String username,
                           String loginname,
                           boolean isadmin,
                           boolean isteacher,
                           boolean isassistant,
                           boolean isstudent,
                           HttpServletRequest request,
                           HttpServletResponse response){
        try {
            PreparedStatement ps=connection.prepareStatement("update human set name=?,loginname=?,isadmin=?,isteacher=?,isassistant=?,isstudent=? where internal_id=?;");
            ps.setString(1,username);
            ps.setString(2,loginname);
            ps.setBoolean(3,isadmin);
            ps.setBoolean(4,isteacher);
            ps.setBoolean(5,isassistant);
            ps.setBoolean(6,isstudent);
            ps.setInt(7,id);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public String[][] getUsers(Security.userlevel[] userlevels){
        try {
        StringJoiner stringJoiner=new StringJoiner(" && ");
        for (Security.userlevel u:userlevels) {
            stringJoiner.add("is"+u.getName()+"=true");
        }
        Statement statement=connection.createStatement();
        ResultSet rs=statement.executeQuery("select internal_id,name from human where " + stringJoiner);
        ArrayList<String[]>strings=new ArrayList<>();
        while (rs.next()){
            strings.add(new String[]{String.valueOf(rs.getInt(1)),rs.getString(2)});
        }
        return strings.toArray(new String[0][0]);
    } catch (SQLException e) {
        throw new Error();
    }
    }
    public void addGroup(String name,
                         String info,
                         int assid,
                         HttpServletRequest request,
                         HttpServletResponse response){
        try {
            PreparedStatement ps = connection.prepareStatement("insert into group_table (groupname, info, assistant) VALUES (?,?,?)");
            ps.setString(1,name);
            ps.setString(2,info);
            ps.setInt(3,assid);
            ps.execute();
        }catch (SQLException e){
            throw new SQLError(e);
        }
    }
    public void modifyGroup(int id,
                           String name,
                           String info,
                           int assistant,
                           HttpServletRequest request,
                           HttpServletResponse response){
        try {
            PreparedStatement ps=connection.prepareStatement("update group_table set groupname=?,info=?,assistant=? where id=?;");
            ps.setString(1,name);
            ps.setString(2,info);
            ps.setInt(3,assistant);
            ps.setInt(4,id);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public void modifyGroup(int id,
                            String name,
                            String info,
                            HttpServletRequest request,
                            HttpServletResponse response){
        try {
            PreparedStatement ps=connection.prepareStatement("update group_table set groupname=?,info=? where id=?;");
            ps.setString(1,name);
            ps.setString(2,info);
            ps.setInt(3,id);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public void removeUserInGroup(String group_name,
                                  int userid,
                                  HttpServletRequest request,
                                  HttpServletResponse response){
        try {
            PreparedStatement ps=connection.prepareStatement("DELETE from group_human where groupname=?&&user_id=?");
            ps.setString(1,group_name);
            ps.setInt(2,userid);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public void removeUserInAllGroup(int userid,
                                     HttpServletRequest request,
                                     HttpServletResponse response){
        try {
            PreparedStatement ps=connection.prepareStatement("DELETE from group_human where user_id=?");
            ps.setInt(1,userid);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public void removeUser(int userid,
                           HttpServletRequest request,
                           HttpServletResponse response){
        removeUserInAllGroup(userid,request,response);
        try {
            PreparedStatement ps=connection.prepareStatement("DELETE from human where internal_id=?");
            ps.setInt(1,userid);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public void removeGroup(int group,
                            HttpServletRequest request,
                            HttpServletResponse response){
        try {
            PreparedStatement ps=connection.prepareStatement("DELETE from group_human where user_id=?");
            ps.setInt(1,group);
            ps.execute();
            ps=connection.prepareStatement("DELETE from group_table where id=?");
            ps.setInt(1,group);
            ps.execute();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public Integer[] getGroupHuman(int groupid,
                                 HttpServletRequest request,
                                 HttpServletResponse response){
        ArrayList<Integer> s=new ArrayList<>();
        try{
            PreparedStatement ps=connection.prepareStatement("select user_id from group_human where id=?");
            ps.setInt(1,groupid);
            ResultSet rs=ps.executeQuery();
            while (rs.next()){
                s.add(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new SQLError(e);
        }
        return s.toArray(new Integer[0]);
    }
    private boolean hasGroupHuman(int group,int userid){
        try{
            PreparedStatement ps=connection.prepareStatement("select count(*) from group_human where id=?&&user_id=?");
            ps.setInt(1,group);
            ps.setInt(2,userid);
            ResultSet rs=ps.executeQuery();
            rs.next();
            if(rs.getInt(1)==0){
                return false;
            }return true;
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public void modifyGroupHuman(int group,int userid,
                                 boolean isadd,
                                 HttpServletRequest request,
                                 HttpServletResponse response){
        if(hasGroupHuman(group,userid)!=isadd){
            if(isadd){
                try{
                    PreparedStatement ps=connection.prepareStatement("insert into group_human(id,user_id) values (?,?);");
                    ps.setInt(1,group);
                    ps.setInt(2,userid);
                    ps.execute();
                } catch (SQLException e) {
                    throw new SQLError(e);
                }
            }else{
                try{
                    PreparedStatement ps=connection.prepareStatement("delete from group_human where id=?&&user_id=?;");
                    ps.setInt(1,group);
                    ps.setInt(2,userid);
                    ps.execute();
                } catch (SQLException e) {
                    throw new SQLError(e);
                }
            }
        }
    }
}
