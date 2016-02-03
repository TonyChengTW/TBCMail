#!/usr/bin/perl
#------------------------
# Writer:  Mico Cheng
# Version: 2004080301
# Use for: Compare different and output to a list-file: 
#             before 1 month (Compared) to check at this month (Primary)
#             for find out what customers added
# Host:    --
#-----------------------
#use DBI;
#$dbh = DBI->connect("DBI:mysql:ezmail;host=localhost", "root",'Au06.wj$') or die "$!\n";

# this month (newest) file list
$primary_list = "hiway.list.20060505";

# last month file list
$compared_list = "hiway.list.20060410";

$output_list = "/root/mico/hiway/add-customer.list";

open (PRIMARY, "$primary_list") or die "can\'t open $primary_list:$!\n";
open (COMPARED, "$compared_list") or die "can\'t open $compared_list:$!\n";
open (OUTPUT, ">$output_list") or die "can\'t open $oes_unlist:$!\n";

while(<PRIMARY>) {
    chomp;
    $primary_count++;
    push(@primary_arr, $_);
}

while(<COMPARED>) {
    chomp;
    $compared_count++;
    push(@compared_arr, $_);
}

@primary_arr = sort(@primary_arr);
@compared_arr = sort(@compared_arr);

&binary_search;

close PRIMARY;
close COMPARED;
close OUTPUT;

#-------------------------------------------
sub binary_search
{
    my($i,$high,$middle,$low);
    $i = 0;
    while ($i <= $primary_count-1) {
         $match = 0;
         $high = $compared_count-1;
         $low = 0;
         until ($low > $high) {
              $middle = int(($low+$high)/2);
              if ($primary_arr[$i] eq $compared_arr[$middle]) {
                     $match = 1;
                     last;
              } elsif ($primary_arr[$i] lt $compared_arr[$middle]) {
                     $high = $middle-1;
                     next;
              } else {
                     $low = $middle+1;
                     next;
              }
         }

         if ($match == 0) {
              print OUTPUT "$primary_arr[$i]\n";
         }

         $i++;
    }
}
