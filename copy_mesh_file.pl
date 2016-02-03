#!/bin/perl
#-----------------------
# Version : 2004042201
# Writer  : Mico Cheng
# Use for : copy mash files
# Host    : x
#-----------------------

$src_dir = $ARGV[0];
$dst_dir = $ARGV[1];

if ( $#ARGV != 1 ) {
    print "\nUsage: copy_mash_file.pl [source_dir] [dist_dir]\n\n";
    exit;
}

opendir DIR,"$src_dir" or die "can't not find $src_dir:$!\n";

foreach (readdir DIR) {
     next if $_ =~ /^\..*/;
     system "cp $src_dir/$_ $dst_dir";
     $count++;
     print "Count:$count  cp $src_dir/$_ $dst_dir\n";
}

print "Done!\n";
print "Tatal : $count\n";
