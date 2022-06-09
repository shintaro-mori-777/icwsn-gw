#!/usr/bin/perl

$database_path = "data.log.txt";

read(STDIN, $buff, $ENV{'CONTENT_LENGTH'});
$buff =~ s/%([0-9a-fA-F][0-9a-fA-F])/chr(hex($1))/ego;
@tmp = split(/&/, $buff);
foreach(@tmp) {
  ($key, $val) = split(/=/, $_);
  $data{$key} = $val;
}

open ( FILE, ">>$database_path" );
print FILE "A\tccnx:/".$data{'addr'}."\n";
close ( FILE );

@path = split('/', $data{'addr'});

print "Content-type: text/html\n\n";
print "<html>\n<head></head>\n<body>\n";
print "<h1>Result:</h1>\n";
print "<h2>ccnx:/$data{'addr'}.jpg<h2>\n";
print "<img src=\"./$path[1]_$path[2].jpg\">\n";
print "</body>\n</html>";
