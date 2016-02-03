#!/usr/local/bin/perl
#------------------------------
# Version : 20060121
# Writer  : Mico Cheng
# Use for : cut domain
# Host    : x
#-------------------------------
$file = shift;
open FH,"$file" or die "$!\n";
while (<FH>) {
    chomp;
    if ($_ =~ /(\w|\d)*\.^.*$/) {
        print "$_\n";
    }
}
