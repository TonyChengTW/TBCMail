#!/bin/perl
open LIST,"/root/mico/hiway/hiway.list" or die "Can\'t open /root/mico/hiway/hiway.list\n";
open LOGGING,">/root/mico/hiway/logging.sh" or die "can\'t create file\n";
print LOGGING "#!/usr/local/bin/bash\n";
while (<LIST>) {
     chomp;
     print LOGGING "gunzip -c /os_backup/maillog/maillog*.gz|grep $_\_hiway|grep pop|grep -v failure|head -1 > /root/mico/hiway/$_.log\n";
     print LOGGING "cat /os_backup/maillog/maillog /os_backup/maillog/maillog.1|grep $_\_hiway|grep pop|grep -v failure|head -1 >> /root/mico/hiway/$_.log\n";
     print LOGGING "#----------------------------------\n";
}
system "chmod +x /root/mico/hiway/logging.sh";
print "done!\n";
