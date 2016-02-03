#!/usr/local/bin/perl
#--------------------------------
# Writer :  Mico Cheng
# Version:  2005031401
# Use for:  Ranking smtpd status
# Hosts:    sendmail
#-------------------------------

use Socket;

until ($#ARGV == 2) {
   print "\nUsage:  smtpd_statistics.pl  <search type>  <ntop>  <maillog_file>\n";
   print "search type        : ip/...\n";
   print "ntop for rank      :  1~ unlimited\n";
   print "log file : syslog/maillog\n";
   exit 1;
}

$i = 0;
$type = shift;
$ntop = shift;
$maillog_file = shift;
$|=1;

die "./smtpd_statistics.pl <ip|...> <ntop> <maillogfile>\n" until ($type =~ /^ip$/);

die "./smtpd_statistics.pl <ip|...> <ntop> <maillogfile>\n" until ($ntop =~ /^([0-9]+)$/);

print "type = $type\t\t\t";
print "top = $ntop\n";
print "maillog file = $maillog_file\n";

if ($type eq 'ip') {
    if ($maillog_file =~ /gz/) {
       system "gunzip -c $maillog_file|grep 'reject=550' > /disk_f720/tmp.txt";
    } else {
       #system "cat $maillog_file |egrep -v 'gethostbyaddr|localhost|/dev/null|cucipop|127.0.0.1|reject|mailer=local|NOQUEUE'|egrep '\[.*\..*\..*\..*\]'> /disk_f720/tmp.txt";
       system "cat $maillog_file|grep 'reject=550' > /disk_f720/tmp.txt";
    }

    open FH,"/disk_f720/tmp.txt";
    while(<FH>) {
        chomp;
        $line = $_;
        next until ($line =~ /\[(\d+\.\d+\.\d+\.\d+)\]/);
        $ip = $1;
        ++$ip_count{$ip};
    }
    close FH;
    unlink "/disk_f720/tmp.txt";

    foreach $key (sort {$ip_count{$b} <=> $ip_count{$a}} %ip_count) {
        if ($nowtop == $ntop) {last;};
        $packed_address = inet_aton("$key");
        $fqdn = gethostbyaddr($packed_address,AF_INET);
        $fqdn = 'null' until (defined($fqdn));
        $source = $key."  $fqdn";
        print "$source $ip_count{$key}\n";
        $nowtop++;
    }
}
