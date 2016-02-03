#!/usr/local/bin/perl
open FH,"user.list";
$i=73638;
while (<FH>) {
    chomp;
    print "print $i\tmkdir /disk5/home/$_\n";
    system "mkdir /disk5/home/$_\n";
    $i--;
}
system "chown mail:sys /disk5/home";
system "chown -R mail:mail /disk5/home";
