package moe.xinmu.jsp;
import moe.xinmu.jsp.sidebar.*;

import java.util.ArrayList;
import java.util.List;

public class SidebarData {
    public static List<IRootSidebar> rs=new ArrayList<>();
    public static List<ISidebar> list=new ArrayList<>();
    private static volatile boolean i=false;
    private final static String[] rootnames=new String[]{"学子在线","教学管理","学生管理","高级设置"};
    private final static Security.userlevel[][] rootuserlevels=new Security.userlevel[][]{
            {Security.userlevel.student},
            {Security.userlevel.teacher},
            {Security.userlevel.assistant, Security.userlevel.admin},
            {Security.userlevel.admin}
    };
    private final static String[][] root_sidebar_names=new String[][]{
            {"出勤清单"},
            {"课堂点名"},
            {"学生出勤情况"},
            {"公告管理","用户管理","服务器设置"}
    };
    private final static String[][] root_sidebar_urls=new String[][]{
            {"/sub/StudentAttendance.jsp"},
            {"/sub/StudentRollCallAttendance.jsp"},
            {"/sub/StudentAttendanceManagement.jsp"},
            {"/sub/AnnouncementManagement.jsp","/sub/UserManagement.jsp","/sub/ServerSetting.jsp"}
    };
    private final static Security.userlevel[][][] root_sidebar_levels=new Security.userlevel[][][]{
            {{Security.userlevel.student}},
            {{Security.userlevel.teacher, Security.userlevel.admin}},
            {{Security.userlevel.assistant, Security.userlevel.admin}},
            {{Security.userlevel.admin,Security.userlevel.assistant,Security.userlevel.teacher}, {Security.userlevel.admin}, {Security.userlevel.admin}}
    };
    private final static String[] sidebar_name=new String[]{"退出系统"};
    private final static String[] sidebar_url=new String[]{"/api/logout.jsp"};
    private final static Security.userlevel[][] sidebar_level=new Security.userlevel[][]{
            {Security.userlevel.admin, Security.userlevel.assistant, Security.userlevel.teacher, Security.userlevel.student}
    };
    public static void init(){
        if(!i){
            i=true;
            for (int j = 0; j < sidebar_name.length; j++)
                list.add(new Sidebar(sidebar_name[j],sidebar_url[j],sidebar_level[j]));
            for (int j = 0; j < rootnames.length; j++) {
                RootSidebar rsb=new RootSidebar(rootnames[j],rootuserlevels[j]);
                for (int k = 0; k < root_sidebar_names[j].length; k++)
                    rsb.addsidebars(new Sidebar(root_sidebar_names[j][k],root_sidebar_urls[j][k],root_sidebar_levels[j][k]));
                rs.add(rsb);
            }
        }
    }
}
