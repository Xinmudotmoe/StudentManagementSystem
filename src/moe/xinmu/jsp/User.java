package moe.xinmu.jsp;

import javax.servlet.http.HttpServletRequest;

import java.util.Arrays;
import java.util.HashMap;
import javax.crypto.spec.DESKeySpec;
import static moe.xinmu.jsp.Utils.cookiesToMap;

public class User {
    public boolean privilegeLevel(Security.userlevel userlevel){
        return Arrays.stream(userlevels).anyMatch(userlevel1 -> userlevel==userlevel1);
    }
    public boolean islogin(){
        return false;
    }
    public String getname(){
        return loginname;
    }
    int internal_id;
    String loginname;
    Security.userlevel[] userlevels;
    User(int internal_id,String loginname,Security.userlevel[] userlevels){
        this.internal_id= internal_id;
        this.loginname=loginname;
        this.userlevels=userlevels.clone();
        //cookie.

    }

    public Security.userlevel[] getUserlevels() {
        return userlevels.clone();
    }
}
