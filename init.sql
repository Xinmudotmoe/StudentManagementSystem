#删除用户
drop user jspservices@'%';
#创建库
CREATE DATABASE jspdatebase;
#设置为UTF-8字符集
alter database jspdatebase character set utf8;
#创建用户
GRANT ALL ON jspdatebase.* TO 'jspservices'@'%' IDENTIFIED BY '70yfRMnlO8CGzv0pOSuCzidtQ1cyE91WjkuHVxBmdyEhSYkuF7O/22lEGl4+X0/t' WITH GRANT OPTION;
#刷新权限
flush privileges;
