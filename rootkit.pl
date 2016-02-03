#!/usr/bin/perl

$targetdir = "/proc";
`/bin/ps -ef > /tmp/proc`;

for ($i=1;$i<65536;$i++)
{
  $dir = "$targetdir/$i";
  if (-d $dir)
  {
    $flag = 0;
    open (IN,"/tmp/proc");
    while (<IN>)
    {
      @proc = split;
      if ($proc[1] == $i)
      {
        $flag = 1;
      }
    }
#    print "$dir\n" if (!$flag);
    if (!$flag)
    {
      print "$dir\t";
      system("ls -al $dir/exe")
    }
  }
}
