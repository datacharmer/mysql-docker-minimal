use mysql;
set password=password('Y9VQcgr9cPnsb');
delete from user where password='';
delete from db where user='';
flush privileges;
create database if not exists test;

