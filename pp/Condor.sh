###This is a modification of the default condor submission script for doing submission from the new hidisk2
###Initialize your grid certificate before submitting jobs
###TA-WEI WANG, 06/08/2017 created

###Plain root .C to be run
CONFIGFILE="loop.C"

PROXYFILE=$(ls /tmp/ -lt | grep $USER | grep -m 1 x509 | awk '{print $NF}')

###All the header/related files needed
TRANSFERFILE="loop.C,loop.h,Dntuple.h,format.h"

initial=0
final=1


###Output file location
DESTINATION="/mnt/T2_US_MIT/hadoop/cms/store/user/zzshi/Data/Dntuple/MinimumBias1"

###Maximum number of files to be run
MAXFILES=10

###Log file location and it's name
LOGDIR="/afs/lns.mit.edu/user/zzshi/CMSSW_7_5_8_patch3/Bfinder/Bfinder/Dntuple/log"

while [  $initial -lt $final ]; do 


###Folder location within which files are to be run
DATASET="/mnt/T2_US_MIT/hadoop/cms/store/user/zzshi/Data/MinimumBias1/crab_Dfinder82/170530_225223/000$initial/"

echo $DATASET
echo $initial



########################## Create subfile ###############################
rm mylistfinal.txt
ls $DATASET  | awk '{print "" $0}' | grep .root >> mylistfinal.txt

if [ ! -d $DESTINATION ]
then
	gfal-mkdir -p srm://se01.cmsaf.mit.edu:8443/srm/v2/server?SFN=$DESTINATION
fi

if [ ! -d $LOGDIR ]
then
    mkdir -p $LOGDIR
fi

dateTime=$(date +%Y%m%d%H%M)
INFILE=""
fileCounter=0
for i in `cat mylistfinal.txt`
do
    if [ $fileCounter -ge $MAXFILES ]
    then
	break
    fi
    ifexist=`ls $DESTINATION/ntuple_$i`
    if [ -z $ifexist ]
    then
	infn=`echo $i | awk -F "." '{print $1}'`
	INFILE="$DATASET$i"
# make the condor file
	cat > subfile <<EOF
Universe = vanilla
Initialdir = .
Executable = exec_condor_hid2.sh
+AccountingGroup = "group_cmshi.$(whoami)"
Arguments =  $CONFIGFILE $DESTINATION ntuple_${infn}.root $INFILE $PROXYFILE
GetEnv       = True
Input = /dev/null
# log files
Output       = $LOGDIR/log-${infn}.out
Error        = $LOGDIR/log-${infn}.err
Log          = $LOGDIR/log-${infn}.log
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
requirements = GLIDEIN_Site == "MIT_CampusFactory" && BOSCOGroup == "bosco_cmshi" && HAS_CVMFS_cms_cern_ch && BOSCOCluster == "ce03.cmsaf.mit.edu"
transfer_input_files = $TRANSFERFILE,/tmp/$PROXYFILE
Queue
EOF


 
echo $infn

############################ Submit ###############################
	
#cat subfile
    condor_submit subfile -pool submit.mit.edu:9615 -name submit.mit.edu -spool
	mv subfile $LOGDIR/log-${infn}.subfile
	fileCounter=$((fileCounter+1))
    fi
done
echo "Submitted $fileCounter jobs to Condor."


initial=$((initial+1)) ; 
done
