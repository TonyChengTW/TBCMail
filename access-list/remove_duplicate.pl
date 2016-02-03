#!/usr/bin/perl
#------------------------
# Writer:  Mico Cheng
# Version: 2004090801
# Use for: Compare different output to a list-file:
#             ezmail-all(Primary) (more) to check nms-valid(compared) (less)
#             for find out noexist in nms-valid (bad customers)
# Host:    --
#-----------------------
$primary_list = "/etc/mail/access";
$compared_list = shift;
$output_list = "access.new";

open (PRIMARY, "$primary_list") or die "can\'t open $primary_list:$!\n";
open (COMPARED, "$compared_list") or die "can\'t open $compared_list:$!\n";
open (OUTPUT, ">$output_list") or die "can\'t open $oes_unlist:$!\n";

print "pushing org_arr\n";
while(<PRIMARY>) {
    chomp;
    $primary_count++;
    push(@primary_arr_unsorted, $_);
}
print "sorting from org\n";
@primary_arr = sort @primary_arr_unsorted;
print "sort org ok!\n";

print "pushing dup_arr\n";
while(<COMPARED>) {
    chomp;
    $compared_count++;
    push(@compared_arr_unsorted, $_);
}
print "sorting from dup\n";
@compared_arr = sort @compared_arr_unsorted;
print "sort dup ok!\n";

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
              if ($primary_arr[$i] =~ /$compared_arr[$middle]/) {
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
