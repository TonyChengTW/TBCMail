#!/usr/local/bin/perl
#--------------------------------------------------
# Version : 2006011801
# Writer  : Miko Cheng
# Used for: remove duplicate IP or E-Mail from access list (/etc/mail/access)
# Host    : x
#---------------------------------------------------
if ($#ARGV != 0) {
    print "\nUsage: remove_duplicate_accesslist.pl <access file>\n";
    die "\n";
}

$access_file = $ARGV[0];
$tmp_file = "/etc/mail/access.tmp";

open FH ,"$access_file" or die "Can't open $access_file:$!\n";
open TH ,">$tmp_file" or die "Can't open $tmp_file:$!\n";

while (<FH>) {
    chomp;
    if (!($_ =~ /^#/)) {
        $item = (split)[0];
        $line{$item}++;
        print TH "$_\n" if ($line{$item} == 1);
    } else {
        print TH "$_\n";
    }
}

close(FH);close(TH);

system "mv /etc/mail/access /etc/mail/access.duplicate";
system "mv /etc/mail/access.tmp /etc/mail/access";
#system "/usr/sbin/makemap hash /etc/mail/access < /etc/mail/access";
