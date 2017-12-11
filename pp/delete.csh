set i=1757783
set f=1761674

echo $i
echo $f

while ( $i < $f )

echo $i

condor_rm $i

@ i = $i + 1

end
