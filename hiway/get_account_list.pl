#!/bin/perl
#==============================================
# Writer:  Mico Cheng
# Version: 20040714
# Use for: dump account from Database
# Host: 203.79.224.59
#==============================================
use DBI;

chomp($today = `date +%Y%m%d`);
$dumpfile = "/root/mico/hiway/hiway.list.$today";
$dbh = DBI->connect("DBI:mysql:ezmail;host=localhost", "root",'Au06.wj$') or die "$!\n";
$sqlstmt = sprintf("select name,username,quota from hiway_ezmail where domain='hiway\@hiway.net.tw'");
print $sqlstmt;
$sth = $dbh->prepare($sqlstmt);
$sth->execute() or die "can not select:$!\n";

#--------------Something strange here -----------------
#if($sth->rows != 1) {
#     print "your SQL statement is wrong!\n";
#     exit;
#}
#------------------------------------------------------

open (DUMPFILE, ">$dumpfile");
while(@row_array=$sth->fetchrow_array) {
    ($name,$username,$quota)= (@row_array);
    #($domain) = (@row_array);
    #print DUMPFILE "$quota\t$domain\t\t$memo\n";
    #print DUMPFILE "$name\t$username\t$quota\n";
    print DUMPFILE "$username\n";
}
$dbh->disconnect();
close DUMPFILE;
