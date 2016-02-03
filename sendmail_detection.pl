#!/usr/local/bin/perl
#----------------------------
#Version : 20060217
#Writer  : Miko Cheng
#Use for : Detect sendmail daemon
#Host    : any
#----------------------------
use IO::Socket;
use Net::SMTP;

use constant HOST => '203.79.224.59';
use constant PORT => '25';
use constant TIMEOUT => '30';

$smtp_server = '210.200.211.36';
$sender = 'mikocheng@aptg.com.tw';
#@recipients = qw(tony@strongniche.com.tw idc-apol@aptg.com.tw idc24-apol@aptg.com.tw);
@recipients = qw(mikocheng@aptg.com.tw);
foreach (@recipients) { $recipients=$recipients."  ".$_ };
chomp($time = `date`);
print "$time  Checking......\n";

$| = 1;

my $socket = IO::Socket::INET->new(Proto=>"tcp", 
                                PeerAddr=>HOST, 
                                PeerPort=>PORT,
                                Timeoutw=>TIMEOUT,
                                Reuse=>1);
          #or  "Can't connect HOST:$! , $@\n";
if (defined($socket)) {
    $socket->autoflush(1);
    my $buf=<$socket>;chomp($buf); $buf=~s/\r//g;
    if ($buf =~ /220 tbc.ht.net.tw ESMTP Sendmail/) {
        print "Sendmail is normal\n";
        exit 0;
    } else {
        &restart_sendmail_daemon;
        &restart_sendmail_notify;
        exit 0;
    }
} else {
    &restart_sendmail_daemon;
    &restart_sendmail_notify;
    exit 0;
}

sub restart_sendmail_daemon {
    print "sendmail fail !! Restart Daemon now.....\n";
    print "killall sendmail\n";
    system ("/sbin/killall sendmail");
    sleep 2;
    print "killall sendmail\n";
    system ("/sbin/killall sendmail");
    sleep 2;
    print "killall sendmail\n";
    system ("/sbin/killall sendmail");
    sleep 2;
    print "killall sendmail\n";
    system ("/sbin/killall sendmail");
    sleep 2;
    print "Restart Daemon:sendmail -bd -q1h\n";
    system ("/usr/lib/sendmail -bd -q1h");
}

sub restart_sendmail_notify {
    print "E-Mail to $recipients\n";
    $smtp = Net::SMTP->new($smtp_server,Timeout=>60);
    $smtp->mail($sender);
    $smtp->recipient(@recipients);
    $smtp->data;
    $smtp->datasend("Subject:TBC sendmail daemon 自動重啟通知\nDate: $time\n\n$time  ==>偵測 TBC(203.79.224.59) sendmail daemon 異常,系統已自動重啟sendmail daemon\n煩請協助再觀查,謝謝!!\n");
    $smtp->dataend;
    $smtp->quit;
}
