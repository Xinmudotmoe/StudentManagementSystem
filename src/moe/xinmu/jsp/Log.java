package moe.xinmu.jsp;

import java.io.IOException;
import java.util.Arrays;
import java.util.logging.FileHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public final class Log {
    private static Logger log;
    static {
        log=Logger.getLogger("jspservices");
        log.setLevel(Level.ALL);
    }
    private static volatile String filename="";
    private static FileHandler fileHandler;
    private static void flush(){
        if(fileHandler!=null)
            fileHandler.flush();
    }
    public static void init(String file) throws IOException {
        if(!file.equals(filename)){
            filename=file;
            if(fileHandler!=null)
                log.removeHandler(fileHandler);
            fileHandler=new FileHandler(filename);
            fileHandler.setLevel(Level.ALL);
            log.addHandler(fileHandler);
        }
    }
    /**获取运行时堆栈信息，用以获取类文件与行数
     *获取最接近调用Log的类的信息
     */
    public static String get(){
        return Arrays.stream(new Throwable().getStackTrace())
                .filter(stackTraceElement -> !stackTraceElement.getClassName().equals(Log.class.getName()))
                .findFirst().get().toString();
    }
    public static void i(String tag, String msg) {
        log.log(Level.INFO,"file: "+get()+"\t"+tag+": "+msg);
        flush();

    }
    public static void i(String tag, String msg,Throwable throwable) {
        log.log(Level.INFO,"file: "+get()+"\t"+tag+": "+msg,throwable);
        flush();
    }
    public static void w(String tag, String msg) {
        log.log(Level.WARNING,"file: "+get()+"\t"+tag+": "+msg);
        flush();
    }
    public static void w(String tag, String msg,Throwable throwable) {
        log.log(Level.WARNING,"file: "+get()+"\t"+tag+": "+msg,throwable);
        flush();
    }
    public static void e(String tag, String msg) {
        log.log(Level.SEVERE,"file: "+get()+"\t"+tag+": "+msg);
        flush();
    }
    public static void e(String tag, String msg,Throwable throwable) {
        log.log(Level.SEVERE,"file: "+get()+"\t"+tag+": "+msg,throwable);
        flush();
    }
    public static void v(String tag, String msg) {
        log.log(Level.FINEST,"file: "+get()+"\t"+tag+": "+msg);
        flush();
    }
    public static void v(String tag, String msg,Throwable throwable) {
        log.log(Level.FINEST,"file: "+get()+"\t"+tag+": "+msg,throwable);
        flush();
    }
    public static void d(String tag, String msg) {
        log.log(Level.FINE,"file: "+get()+"\t"+tag+": "+msg);
        flush();
    }
    public static void d(String tag, String msg,Throwable throwable) {
        log.log(Level.FINE,"file: "+get()+"\t"+tag+": "+msg,throwable);
        flush();
    }
}
