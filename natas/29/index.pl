END
#
# morla /10111
# '$_=qw/ljttft3dvu{/,s/./print chr ord($&)-1/eg'
#
# credits for the previous level go to whoever
# created insomnihack2016/fridginator, where i stole the idea from.
# that was a fun challenge, Thanks!
#

print <<END;
H3y K1dZ,<br>
y0 rEm3mB3rz p3Rl rit3?<br>
\\/\\/4Nn4 g0 olD5kewL? R3aD Up!<br><br>

<form action="index.pl" method="GET">
<select name="file" onchange="this.form.submit()">
  <option value="">s3lEcT suMp1n!</option>
  <option value="perl underground">perl underground</option>
  <option value="perl underground 2">perl underground 2</option>
  <option value="perl underground 3">perl underground 3</option>
  <option value="perl underground 4">perl underground 4</option>
  <option value="perl underground 5">perl underground 5</option>
</select>
</form>

END

if(param('file')){
    $f=param('file');
    if($f=~/natas/){
        print "meeeeeep!<br>";
    }
    else{
        open(FD, "$f.txt");
        print "<pre>";
        while (<FD>){
            print CGI::escapeHTML($_);
        }
        print "</pre>";
    }
}

print <<END;