#!/usr/bin/perl

use strict;

# Конвертор плейлистов m3u2xml

my $file = $ARGV[0];
$file =~ /(.*)\.m3u/;
my $film_name = $1;
$film_name =~ s/_/ /gs;

my $head = '<?xml version="1.0" encoding="UTF-8" ?>
<items>
<playlist_name>'.$film_name.'</playlist_name>';
my $data = '  <channel>
    <title></title>
    <stream_url><![CDATA[]]></stream_url>
    <logo_30x30></logo_30x30>
    <category_id>1</category_id>
  </channel>';
my $end = '</items>';

open(FILE_IN,'<:raw', $file);

$file =~ s/\.m3u//;
open(FILE_OUT,'>:raw', $file.'.xml');

my $in;
$in .= $_ foreach <FILE_IN>;

print FILE_OUT "$head\n";

while ($in =~ /\#EXTINF\:0,\s*([^\n]+)\s*\n\s*([^\n]+)\s*\n/gsi)
{
  my $chenel_name = $1;
  my $url = $2;
  my $chenal = $data;
  $chenal =~ s/<title>\s*<\/title>/<title>$chenel_name<\/title>/si;
  $chenal =~ s/CDATA\[\]/CDATA\[$url\]/si;
  $chenal =~ s/\x0D//gs;

  print FILE_OUT "$chenal\n";
}

print FILE_OUT $end;

close FILE_IN;
close FILE_OUT;

# Добавление фильма в плейлист

open(PLAYLIST,'<:raw', 'yuriio_playlist.xml');
my $playlist = join '', @{[<PLAYLIST>]};
my $previous = $1 if $playlist =~ /.*?<items>\n(.*?)<\/items>\s*$/gsi;
$previous .= "    <channel>
        <title>$film_name</title>
        <playlist_url><![CDATA[http://simlab.tk/data/widget/$file.xml]]></playlist_url>
        <logo_30x30></logo_30x30>
        <category_id>1</category_id>
    </channel>
</items>";
close PLAYLIST;

open(PLAYLIST,'>:raw', 'yuriio_playlist.xml');
print PLAYLIST "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<items>\n";
print PLAYLIST $previous;
close PLAYLIST;
