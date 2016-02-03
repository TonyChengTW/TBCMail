#!/usr/local/bin/bash
MAILQ=`mailq|head -1|cut -d' ' -f3|sed -e 's/(//'`
echo $MAILQ
echo 0
