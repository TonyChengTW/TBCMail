# MySQL dump 5.13
#
# Host: localhost    Database: ezmail
#--------------------------------------------------------
# Server version	3.22.20a
#
# Table structure for table 'emailtbc'
#
#
# Table structure for table 'ezmail'
#
CREATE TABLE hiway_ezmail (
  domain varchar(60),
  name varchar(20),
  username varchar(20),
  password varchar(20),
  dept varchar(20),
  quota varchar(20),
  forward varchar(255),
  forwardopen varchar(20),
  cc varchar(255),
  ccopen varchar(20),
  ezgroup varchar(20),
  done int(11)
);

#
# Table structure for table 'passwd'
#
CREATE TABLE hiway_passwd (
  cid int(11) DEFAULT '0' NOT NULL auto_increment,
  userid varchar(60),
  passwd varchar(20),
  mailquota int(11),
  name varchar(200),
  email varchar(60),
  memo text,
  PRIMARY KEY (cid)
);

CREATE TABLE hiway_ezgroup (
  gid int(11) DEFAULT '0' NOT NULL auto_increment,
  domain varchar(60),
  groupname varchar(20),
  descr text,
  list datetime,
  PRIMARY KEY (gid)
);

