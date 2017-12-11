set i=2971
set f=3000

while ( $i < $f )



echo $i

if (! -e /mnt/hadoop/cms/store/user/zzshi/Data/pPb/PAMinimumBias3/crab_pPbMB3/170810_173230/0002/finder_pPb_${i}.root ) then
    xrdcp  root://eoscms.cern.ch//eos/cms/store/group/phys_heavyions/zshi/pPb/PAMinimumBias3/crab_pPbMB3/170810_173230/0002/finder_pPb_${i}.root .
    gfal-copy finder_pPb_${i}.root gsiftp://se01.cmsaf.mit.edu:2811/cms/store/user/zzshi/Data/pPb/PAMinimumBias3/crab_pPbMB3/170810_173230/0002/finder_pPb_${i}.root
    rm finder_pPb_${i}.root
endif

@ i = $i + 1

end
