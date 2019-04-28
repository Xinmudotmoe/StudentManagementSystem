package moe.xinmu.jsp.sidebar;

import moe.xinmu.jsp.Security;

public interface IRootSidebar {
    String getName();
    boolean privilegeLevel(Security.userlevel userlevel);
    Sidebar[] getSidebars();
}
