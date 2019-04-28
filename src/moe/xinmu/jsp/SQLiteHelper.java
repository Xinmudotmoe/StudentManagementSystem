package moe.xinmu.jsp;

import javax.servlet.ServletContext;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOError;
import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Objects;

import static moe.xinmu.jsp.Utils.Status302;

public class SQLiteHelper {
    static {
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            throw new Error("SQLite Lib Can`t Find.",e);
        }
    }
    private Connection connection;
    public static SQLiteHelper INSTANCE;
    private HashMap<String,String> access=null;
    public SQLiteHelper(ServletContext context){
        String sqlitefile=Objects.requireNonNull(context).getRealPath("")+"\\sql.sqlite3";
        try {
            File f=new File(sqlitefile);
            //if(!f.isFile())
            //    f.createNewFile();
            connection=DriverManager.getConnection("jdbc:sqlite:"+f.getCanonicalPath());
        } catch (SQLException | IOException e) {
            throw new SQLError("Can`t Connect SQLite.",e);
        }
    }
    public  int iscreate=0;
    public boolean isCreate(){
        if(iscreate==0)
        try {
            Statement s=connection.createStatement();
            ResultSet rs=s.executeQuery("select * from log_info;");
            int count=0;
            while (rs.next())
                count++;
            if(count>=1)
                iscreate=1;
            else
                iscreate=-1;
        } catch (SQLException e) {
            iscreate=-1;
        }
        return iscreate != -1;
    }
    private static final String[] createtables=new String[]{
            "CREATE TABLE sql_info ( id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, host VARCHAR, username VARCHAR, passwd VARCHAR, database_name VARCHAR);",
            "CREATE TABLE log_info ( id INTEGER PRIMARY KEY AUTOINCREMENT, path VARCHAR);",
    };
    private void execute(String sql){
        Utils.execute(sql, connection);
    }
    public boolean create(String host,String username,String passwd,String database_name,String log)  {
        try{
            try{
            Arrays.stream(createtables).forEach(this::execute);
            }catch (SQLError ignored){}
            PreparedStatement ps=connection.prepareStatement("INSERT INTO log_info(path) VALUES(?);");
            ps.setString(1,log);
            ps.execute();
            ps.close();
            ps=connection.prepareStatement("INSERT INTO sql_info(host,username,passwd,database_name) VALUES(?,?,?,?);");
            ps.setString(1,host);
            ps.setString(2,username);
            ps.setString(3,passwd);
            ps.setString(4,database_name);
            return ps.execute();
        }catch (SQLException e){
            throw new SQLError(e);
        }
    }


    public static boolean check(HttpServletRequest request, HttpServletResponse response){
        if(INSTANCE==null)
            INSTANCE=new SQLiteHelper(request.getServletContext());
        if(!INSTANCE.isCreate()){
            Status302(request,response,"/install.jsp");
            return false;
        }else{
            try {
                Log.init(INSTANCE.getLogpath());
            } catch (IOException e) {
                throw new SQLError(e);
            }
            SidebarData.init();
        }
        return true;
    }
    private void setMasterSQLHelper(){
        try {
            Statement s=connection.createStatement();
            ResultSet rs=s.executeQuery("select host,username,passwd,database_name from sql_info order by id desc limit 1;");
            access=new HashMap<>();
            access.put("host",rs.getString(1));
            access.put("user",rs.getString(2));
            access.put("pass",rs.getString(3));
            access.put("dbname",rs.getString(4));
            rs.close();
            s.close();
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
    public MasterSQLHelper getMasterSQLHelper(){
        if(access==null)
            setMasterSQLHelper();
        return getMasterSQLHelper(access.get("host"),access.get("user"),access.get("pass"),access.get("dbname"));
    }
    private MasterSQLHelper getMasterSQLHelper(String host,String user,String pass,String dbname){
        return new MasterSQLHelper(host, user, pass, dbname);
    }
    public boolean checkMasterCorrect(String host,String user,String pass,String dbname){
        try {
            getMasterSQLHelper(host, user, pass, dbname);
            return true;
        }catch (SQLError s){
            s.printStackTrace();
            return false;
        }
    }
    private String getLogpath(){
        try {
            Statement ps = connection.createStatement();
            ResultSet rs=ps.executeQuery("select path from log_info order by id desc limit 1;");
            String path=rs.getString(1);
            rs.close();
            ps.close();
            return path;
        } catch (SQLException e) {
            throw new SQLError(e);
        }
    }
}
