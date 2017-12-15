drop table if exists codelist;

create table codelist (
code char(6) not null ,
name varchar(16) not null ,
ipodt date not null,
totalvol bigint unsigned not null,
transvol bigint unsigned not null,
uptime TIMESTAMP not null DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
primary key (code)
)
ROW_FORMAT=COMPRESSED  
KEY_BLOCK_SIZE=8;
;
