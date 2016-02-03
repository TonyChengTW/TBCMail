#!/usr/local/bin/perl

    use DBI;
    use IO::File;
    $today=time();

    my $dbh = DBI->connect('DBI:mysql:ezmail','ezmail','apol888')
            or die "Couldn't connect to database: " . DBI->errstr;
#
# Prepare sendmail.cw for Sendmail
#
    $fh = new IO::File ">/home/ezmail/convDB/sendmail." . $today;
	  print $fh "apol-mp.com.tw\n";
	  print $fh "lsc.net.tw\n";
          print $fh "hiway.net.tw\n";

    undef $fh;       # automatically closes the file
    
#
# Prepare passwd.db and mailquota.db and tbc's webquota.db for Sendmail
#
    $f1 = new IO::File ">/home/ezmail/convDB/passwd." . $today;
    $f2 = new IO::File ">/home/ezmail/convDB/mailquota." . $today;
    $f3 = new IO::File ">/home/ezmail/convDB/virtusertable." . $today;
	$f4 = new IO::File ">/home/ezmail/convDB/webquota." . $today;
	$f5 = new IO::File ">/home/ezmail/convDB/apol-mp.grp." . $today;
	$f6 = new IO::File ">/home/ezmail/convDB/lsc.grp." . $today;

print "Making TBC account.......\n";
	### add tbc mail db 2001/12/28
	if (defined $f1) {
		$passwd = "root2002";
		$salt = chr(rand(0,25)+65) . chr(rand(0,25)+65);
		$passwd = crypt($passwd,$salt);
		print $f1 "root_apol-mp" . " " . $passwd . "\n";
		print $f1 "root_lsc" . " " . $passwd . "\n";
                print $f1 "root_hiway" . " " . $passwd . "\n";
	}
	if (defined $f2) {
		print $f2 "root_apol-mp" . " " . "20\n";
		print $f2 "root_lsc" . " " . "20\n";
		print $f2 "root_hiway" . " " . "20\n";
	}
	if (defined $f3) {
		print $f3 "root\@apol-mp.com.tw" . " " . "root_apol-mp\n";
		print $f3 "root\@lsc.net.tw" . " " . "root_lsc\n";
		print $f3 "root\@hiway.net.tw" . " " . "root_hiway\n";
	}
	if (defined $f4) {
		print $f4 "root_apol-mp" . " " . "20\n";
		print $f4 "root_lsc" . " " . "20\n";
	}

	$sql="select username,domainname,password,mquota,wquota from emailtbc where username != ''";
    $sth = $dbh->prepare($sql)
            or die "Couldn't prepare statement: " . $dbh->errstr;
    $sth->execute()             # Execute the query
            or die "Couldn't execute statement: " . $sth->errstr;
    if ($sth->rows == 0) {
        print "no tbc data\n";
    } else {
		@data;
		while (@data = $sth->fetchrow_array()) {
			my $mquota,$wquota;
			my $tbc;
			($username,$domainname,$passwd,$mquota,$wquota) = @data;
			if ($domainname eq "lsc.net.tw"){
				$tbc="lsc.net.tw";
				$admin="lsc";
			} else {
				$tbc="apol-mp.com.tw";
				$admin="apol-mp";
			}
			if ($username =~ /[\s]/) {
				next;
				#$username =~ s/^\s+//;
				#$username =~ s/\s+$//;
				#$username =~ s/\s+/_/;
			}
			if (defined $f1 && $username ne "root") {
				$salt = chr(rand(0,25)+65) . chr(rand(0,25)+65);
				$passwd = crypt($passwd,$salt);
				print $f1 $username . "_" . $admin . " " . $passwd . "\n";
			}
			if (defined $f2 && $username ne "root") {
				print $f2 $username . "_" . $admin . " " . $mquota . "\n";
			}
			if (defined $f3 && $username ne "root") {
				print $f3 $username . "\@" . $tbc . " " . $username . "_" . $admin . "\n";
			}
			if (defined $f4 && $username ne "root") {
				print $f4 $username . "_" . $admin . " " . $wquota . "\n";
			}
			if (defined $f5 && $username ne "root" && $admin eq "apol-mp") {
				print $f5 $username . "_" . $admin . "\n";
			}
                        if (defined $f6 && $username ne "root" && $admin eq "lsc") {
                                print $f6 $username . "_" . $admin . "\n";
                        }

		}	#while
    }	#if
    $sth->finish;
#------  make hiway.net.tw -------------------------------------------
#   Mico Cheng 2005/04/15
#------  make hiway.net.tw ----------------------------------------------
print "Making Hiway account.......\n";

    $sql = "SELECT username,password,quota FROM hiway_ezmail WHERE domain='hiway\@hiway.net.tw'";

    $sth_hiway = $dbh->prepare($sql)
            or die "Couldn't prepare statement: " . $dbh->errstr;
    $sth_hiway->execute()             # Execute the query
            or die "Couldn't execute statement: " . $sth->errstr;
    if ($sth_hiway->rows == 0) {
        print "no Hiway data\n";
    } else {
		@data;
                $domain_first_part = 'hiway';
                $domain = 'hiway.net.tw';
		while (@data = $sth_hiway->fetchrow_array()) {
			($username,$passwd,$quota) = @data;
			next if ($username =~ /\s/);
                        print $f1 $username."_".$domain_first_part." ".$passwd."\n";
                        print $f2 $username."_".$domain_first_part." ".$quota."\n";
                        print $f3 $username. "\@".$domain." ".$username."_".$domain_first_part."\n";
                }
    }
    $sth_hiway->finish;
#______  Done for write files ________________________________________
    undef $f1;       # automatically closes the file
    undef $f2;       # automatically closes the file
    undef $f3;       # automatically closes the file
    undef $f4;       # automatically closes the file
    undef $f5;       # automatically closes the file
    undef $f6;       # automatically closes the file
    $dbh->disconnect;

system "cp /home/ezmail/convDB/sendmail.$today /etc/mail/sendmail.cw";

####  /etc/mail/passwd.db #####
#system "/usr/sbin/makemap hash /etc/mail/passwd.db < /home/ezmail/convDB/passwd.$today";
system "/usr/sbin/makemap hash /etc/mail/passwd_tmp.db < /home/ezmail/convDB/passwd.$today";
system "/bin/mv /etc/mail/passwd_tmp.db /etc/mail/passwd.db";

#### /etc/mail/mailquota.db ####
#system "/usr/sbin/makemap hash /etc/mail/mailquota.db < /home/ezmail/convDB/mailquota.$today";
system "/usr/sbin/makemap hash /etc/mail/mailquota_tmp.db < /home/ezmail/convDB/mailquota.$today";
system "/bin/mv /etc/mail/mailquota_tmp.db /etc/mail/mailquota.db";

#### /etc/mail/webquota.db ####
#system "/usr/sbin/makemap hash /etc/mail/webquota.db < /home/ezmail/convDB/webquota.$today";
system "/usr/sbin/makemap hash /etc/mail/webquota_tmp.db < /home/ezmail/convDB/webquota.$today";
system "/bin/mv /etc/mail/webquota_tmp.db /etc/mail/webquota.db";

#### /etc/mail/virtualtable.db ####
system "cat /home/ezmail/convDB/virtusertable.$today /home/ezmail/usersetup.txt > /home/ezmail/virtuser";
#system "/usr/sbin/makemap hash /etc/mail/virtusertable.db < /home/ezmail/virtuser";
system "/usr/sbin/makemap hash /etc/mail/virtusertable_tmp.db < /home/ezmail/virtuser";
system "/bin/mv /etc/mail/virtusertable_tmp.db /etc/mail/virtusertable.db";

####  rm all tmp files ####
system "rm -f /home/ezmail/virtuser";
system "rm -f /home/ezmail/convDB/sendmail.$today";
system "mv /home/ezmail/convDB/passwd.$today /etc/mail/passwd";
system "mv /home/ezmail/convDB/mailquota.$today /etc/mail/mailquota";
system "mv /home/ezmail/convDB/webquota.$today /etc/mail/webquota";
system "mv /home/ezmail/convDB/virtusertable.$today /etc/mail/virtusertable";
system "mv /home/ezmail/convDB/apol-mp.grp.$today /etc/mail/grp/apol-mp.grp";
system "mv /home/ezmail/convDB/lsc.grp.$today /etc/mail/grp/lsc.grp";

$todaytime=localtime();
print "Making Account Done!\n";
print "$todaytime =0=";
