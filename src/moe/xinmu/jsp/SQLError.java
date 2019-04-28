package moe.xinmu.jsp;
/**
 *将一切Exception全部转换为Error
 * 当所有功能完成后进行针对化Exception拦截 而不是继续使用SQLError
 * */

public class SQLError extends Error {

    /*package*/SQLError(){
        super();
    }
    /*package*/SQLError(String s){
        super(s);
    }
    /*package*/SQLError(String s,Throwable throwable){
        super(s,throwable);
    }
    /*package*/SQLError(Throwable throwable){
        super(throwable);
    }
}
