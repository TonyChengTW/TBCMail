#!/bin/perl
#-----------------------
# Version : 2004042201
# Writer  : Mico Cheng
# Use for : copy mash files
# Host    : x
#-----------------------

$src_dir = $ARGV[0];

if ( $#ARGV != 0 ) {
    print "\nUsage: delete_mash_file.pl [dir]\n";
    exit;
}

opendir DIR,"$src_dir" or die "can't not find $src_dir:$!\n";

foreach (readdir DIR) {
     next if $_ =~ /^\..*/;
     system "rm -f $src_dir/$_";
     $count++;
     print "Count:$count  rm $src_dir/$_\n";
}

print "Done!\n";
print "Tatal : $count\n";
