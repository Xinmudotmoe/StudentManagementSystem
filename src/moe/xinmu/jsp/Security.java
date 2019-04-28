package moe.xinmu.jsp;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.ArrayList;
import java.util.Arrays;
import javax.crypto.*;
import javax.crypto.spec.DESKeySpec;

public class Security {
    //fixme
    @Deprecated
    private static Cipher getDESCipher(String key,int mod)
            throws InvalidKeyException,
            NoSuchAlgorithmException,
            NoSuchPaddingException{
        KeyGenerator _generator = KeyGenerator.getInstance("DES");
        _generator.init(new SecureRandom(genKey(key,DESKeySpec.DES_KEY_LEN)));
        Cipher cipher=Cipher.getInstance("DES");
        cipher.init(mod,_generator.generateKey());
        //new javax.script.ScriptEngineManager().getEngineByName()

        return cipher;
    }
    @Deprecated
    public static byte[] DESencode(String key,String dat)
            {
                Cipher cipher = null;
                try {
                    cipher = getDESCipher(key, Cipher.ENCRYPT_MODE);
                    return cipher.doFinal(dat.getBytes());
                } catch (InvalidKeyException  | NoSuchPaddingException | NoSuchAlgorithmException | IllegalBlockSizeException | BadPaddingException e) {
                    e.printStackTrace();
                }
                return dat.getBytes();
    }
    @Deprecated
    public static String DESdecode(String key,byte[] dat){
        try {
            return new String(getDESCipher(key, Cipher.DECRYPT_MODE).doFinal(dat));
        } catch (IllegalBlockSizeException | BadPaddingException  | InvalidKeyException | NoSuchAlgorithmException | NoSuchPaddingException e) {
            e.printStackTrace();
        }
        return new String(dat);

    }
    private static byte[] genKey(String key,int bit){
        if(key.length()<bit)
            key+="kkQZww8+x/ONvTHYsCgYAINqvg";
        byte[] dat=key.getBytes();
        if(dat.length==bit)
            return dat;
        byte[] odat=new byte[bit];
        if(dat.length>bit){
            for (int i = 0; i < dat.length; i++)
                odat[i%bit]+=dat[i];
        }
        System.out.println(Arrays.toString(odat));
        return odat.clone();
    }
    public enum userlevel{
        admin("管理员","admin"),
        teacher("教师","teacher"),
        assistant("导员","assistant"),
        student("学生","student");
        private String i18n;
        private String name;
        userlevel(String i18n,String name){
            this.i18n=i18n;
            this.name=name;
        }

        public String getName() {
            return name;
        }

        public String getI18n() {
            return i18n;
        }
        public static String[] getAlli18n(userlevel[] userlevel){
            ArrayList<String> s=new ArrayList<>();
            Arrays.stream(userlevel).forEach(userlevel1 -> s.add(userlevel1.getI18n()));
            return s.toArray(new String[0]);
        }
    }
}
