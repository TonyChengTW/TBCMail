#!/usr/local/bin/perl
#----------------------------------------------------
#Version : 20051221
#Writer  : Miko Cheng
#Host    : TBC Mail
#IP      : 203.79.224.59
#Use for : build access file
#----------------------------------------------------

$access_file = '/etc/mail/access.mico';

$command1 = 'cat /etc/mail/access|grep OK > /tmp/a;/bin/dns_lookup.pl /tmp/a > /etc/mail/access.mico';
$command2 = 'echo "#------------ Deny Domain and E-Mail ----------------" >> /etc/mail/access.mico';
$command3 = 'cat /etc/mail/access|grep -v OK|grep \'^[a-zA-Z]\'>> /etc/mail/access.mico';
$command4 = 'echo "#------------ Deny IP ----------------" >> /etc/mail/access.mico';

system ($command1);
system ($command2);
system ($command3);
