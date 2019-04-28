package moe.xinmu.jsp.sidebar;

import moe.xinmu.jsp.Security;

import java.util.ArrayList;
import java.util.List;

public interface ISidebar {

    String getName();
    String getURL();
    boolean privilegeLevel(Security.userlevel userlevel);
}
