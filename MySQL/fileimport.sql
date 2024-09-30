set session local_infile=1;
set session wait_timeout = 28800;
set session net_read_timeout = 28800;
set session net_write_timeout = 28800;
set session interactive_timeout = 28800;

show variables like 'wait_timeout';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\obs.txt' INTO TABLE cuhdb.obs
CHARACTER SET utf8mb4
IGNORE 1 LINES


//utf8mb4
implant
surghx

//latin1
probs
medhx
meds

//utf
everything else 

//Encoding
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\obs.txt' INTO TABLE cuhdb.obs
CHARACTER SET latin1
IGNORE 1 LINES


//connection lost
obs
labs

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\implant.csv' INTO TABLE cuhdb.implant
CHARACTER SET UTF8
FIELDS OPTIONALLY ENCLOSED BY '"' TERMINATED BY ','
IGNORE 1 LINES
