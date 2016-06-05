use mysql;
set password='Y9VQcgr9cPnsb';
delete from user where user not in ('root', 'mysql.sys', 'mysqlxsys');
flush privileges;

create schema if not exists test;

