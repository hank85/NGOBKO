create table mktvalue_day (
Scode char(8) not null,
Volume int UNSIGNED not null,
Clsprice DECIMAL(6,2) not null,
T_date date not null,
Uptime TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)





