set i=1
set f=4000
set k=15

echo $i
echo $f

while ( $i < $f )

echo $i

root -b -l -q /mnt/hadoop/cms/store/user/zzshi/Data/Dntuple/MinimumBias$k/ntuple_finder_pp_$i.root



@ i = $i + 1

end

