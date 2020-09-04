#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];

open (FILEIN,"<$file");
my @lines = <FILEIN>;
close FILEIN;

open (FILEOUT,">nStream.m3u");
print FILEOUT "#EXTM3U\n";

my $n = 1;
print FILEOUT "#EXTINF:0,Серия " . $n++ . "\n$_" foreach @lines;

close FILEOUT;

`cp nStream.m3u $file`;
`rm nStream.m3u`;
`perl playlist_konvertor.pl $file`;
