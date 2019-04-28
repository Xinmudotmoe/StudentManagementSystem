package moe.xinmu.jsp.sidebar;

import moe.xinmu.jsp.Security;

import java.util.Arrays;

public class Sidebar implements ISidebar {
    private String name;
    private String url;
    private Security.userlevel[] userlevels;
    public Sidebar(String name,String url,Security.userlevel[] userlevels){
        this.name=name;
        this.url=url;
        this.userlevels=userlevels.clone();
    }
    @Override
    public String getName() {
        return name;
    }

    @Override
    public String getURL() {
        return url;
    }

    @Override
    public boolean privilegeLevel(Security.userlevel userlevel) {
        return Arrays.stream(userlevels).anyMatch(userlevel1 -> userlevel == userlevel1);
    }
}
