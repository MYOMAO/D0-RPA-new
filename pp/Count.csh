set i=1
set f=9

echo $i
echo $f

while ( $i < $f )

echo $i

#ls /mnt/hadoop/cms/store/user/szhaozho/Data/Dntuple/pPbHighData3/MinimumBias${i}/*root |wc -l

ls  /mnt/hadoop/cms/store/user/zzshi/Data/Dntuple/pPbDataHigh3/MinimumBias${i}/*root |wc -l



@ i = $i + 1

end
