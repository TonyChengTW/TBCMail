#!/bin/perl 
# ====================================================== 
# Writer   : Mico Cheng 
# Version  : 2004080601 
# Use for  : lookup http access log to delete big size file
# Host     : x
# ====================================================== 
if ($#ARGV != 1)
{
     print "\n".'usage:    pwp-bigsize-kill.pl'." '\x1b[4mpwp-dir\x1b[m'"." '\x1b[4msize(MB)\x1b[m'"."\n";
     print "\nexample:  pwp-bigsize-kill.pl /emc2_85_s1/home 30\n";
     exit;
}

#-- Begin--

$http_log = "/etc/httpd/logs/access_log";
$pwp_dir = $ARGV[0];
$size *= 1000;

open LOG,"$http_log" or die "can't open $http_log:$!\n";

while (<LOG>) {
    next if ($_ !~ /HTTP\/1.1. 200/);
    chomp;
    ($user) = ($_ =~ /GET \/~(.*?)\//);
    next if !(defined($user));
    push @users, $user;
}
@users=uniq(@users);

foreach $user (@users) {
    $check_dir = $pwp_dir."/".$user;
    print "checking $check_dir\n";
    system "/bin/find $check_dir -size +$size","kb -type f -exec rm -f {} \;";
}

#----Function---------

sub uniq {
    my %hash = map { ($_,0 ) } @_;
    return keys %hash;
}
