package moe.xinmu.jsp.sidebar;

import moe.xinmu.jsp.Security;

import java.util.ArrayList;
import java.util.Arrays;

public class RootSidebar implements IRootSidebar {
    private String name;
    private Security.userlevel[] userlevels;
    private ArrayList<Sidebar> sidebars=new ArrayList<>();

    public RootSidebar(String name,Security.userlevel[] level){
        this.name=name;
        this.userlevels=level.clone();
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public boolean privilegeLevel(Security.userlevel userlevel) {
        return Arrays.stream(userlevels).anyMatch(userlevel1 -> userlevel == userlevel1);
    }

    public void addsidebars(Sidebar sidebar){
        sidebars.add(sidebar);
    }
    @Override
    public Sidebar[] getSidebars() {
        return sidebars.toArray(new Sidebar[0]);
    }
}
