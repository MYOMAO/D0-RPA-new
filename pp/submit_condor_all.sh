###Condor submitting template for plain root jobs. Run on all the files separately in a given folder, the DATASET folder below
###TA-WEI WANG, 02/20/2014 created
###Your plain root file needs to be modified , see example loop.C
###Please compile the .C before submission to make sure your code is working.
###Checking condor jobs status: condor_q <username> 

###Plain root .C to be run
CONFIGFILE="loop.C"

###Complilation

g++ $CONFIGFILE $(root-config --cflags --libs) -Wall -O2 -o "${CONFIGFILE/%.C/}.exe"

###All the header/related files needed
#TRANSFERFILE="loop.C,loop.h,Dntuple.h,format.h,TMVAClassification_BDTG.class.C,TMVAClassification_BDTG2.class.C,TMVAClassification_BDTG3.class.C, uti.h"
TRANSFERFILE="loop.exe"

PROXYFILE=$(ls /tmp/ -lt | grep $USER | grep -m 1 x509 | awk '{print $NF}') 
###Output file location
#DESTINATION=/mnt/hadoop/cms/store/user/jwang/Dmeson/ntD_20151012_HLTemulation_DinderMC_Pyquen_D0tokaonpion_D0pt15p0_Pthat15_TuneZ2_Unquenched_5020GeV_GENSIM_75x_v2_20151010_EvtBase
#DESTINATION="/mnt/T2_US_MIT/hadoop/cms/store/user/zzshi/Data/Dntuple/MinimumBias1"

###Maximum number of files to be run
MAXFILES=999

###Log file location and it's name
LOGDIR="/work/szhaozho/CMSSW_7_5_8_patch3/Bfinder/Bfinder/Dntuple/pp/log"
########################## Create subfile ###############################


inifolder=17
endfolder=18


# setup grid proxy
#export X509_USER_PROXY=\${PWD}/$PROXYFILE
# set hadoop directory path for grid tools
#SRM_#SRM_PATH="/cms/store/user/zzshi/Data/Dntuple/MinimumBias1"

#gfal-mkdir -p gsiftp://se01.cmsaf.mit.edu:2811/${SRM_PATH}


while [  $inifolder -lt $endfolder ]; do 

echo $inifolder

DESTINATION="/mnt/hadoop/cms/store/user/szhaozho/Data/Dntuple/HighData/MinimumBias$inifolder"

DESTINATION2="/cms/store/user/szhaozho/Data/Dntuple/HighData/MinimumBias$inifolder"

crab=$((inifolder+81)) ; 

initial=0
final=4


variable=`ls /mnt/hadoop/cms/store/user/zzshi/Data/MinimumBias$inifolder/crab_Dfinder$crab/`

while [  $initial -lt $final ]; do 

###Folder location within which files are to be run
DATASET="/mnt/hadoop/cms/store/user/zzshi/Data/MinimumBias$inifolder/crab_Dfinder$crab/$variable/000$initial/"


DATASET2="/cms/store/user/zzshi/Data/MinimumBias$inifolder/crab_Dfinder$crab/$variable/000$initial/"
#DATASET2="/mnt/hadoop/cms/store/user/zzshi/Data/MinimumBias1/crab_Dfinder82/170530_225223/000$initial/"
echo $DATASET
echo $DESTINATION
echo $initial



rm mylistfinal.txt
ls $DATASET  | awk '{print "" $0}' | grep .root >> mylistfinal.txt

if [ ! -d $DESTINATION ]
then
    mkdir -p $DESTINATION
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
	INFILE="$DATASET2$i"
	INFILE2="$i"
	#transfer_input_files = $TRANSFERFILE


# make the condor file
	cat > subfile <<EOF

Universe = vanilla
Initialdir = .
Executable = exec_condor.sh
+AccountingGroup = "group_cmshi.$(whoami)"
Arguments =  $CONFIGFILE $DESTINATION2 ntuple_${infn}.root $INFILE $INFILE2
GetEnv       = True
Input = /dev/null

# log files
Output       = $LOGDIR/log-${infn}.out
Error        = $LOGDIR/log-${infn}.err
Log          = $LOGDIR/log-${infn}.log

should_transfer_files = YES
when_to_transfer_output = ON_EXIT
transfer_input_files = $TRANSFERFILE,/tmp/$PROXYFILE
transfer_output_files = ""
requirements = ( \ 
                  (OSGVO_OS_STRING == "RHEL 6" && HAS_CVMFS_cms_cern_ch) || \
                  GLIDEIN_REQUIRED_OS == "rhel6" || \
                  (GLIDEIN_Site == "MIT_CampusFactory" && (BOSCOGroup == "bosco_cmshi") && HAS_CVMFS_cms_cern_ch) \
                ) && \
                ( isUndefined(GLIDEIN_Entry_Name) || \
                  !stringListMember(GLIDEIN_Entry_Name,"CMS_T2_US_Nebraska_Red_op,CMS_T2_US_Nebraska_Red_gw1_op,CMS_T2_US_Nebraska_Red_gw2_op,CMS_T3_MX_Cinvestav_proton_work,CMS_T3_US_Omaha_tusker,CMSHTPC_T3_US_Omaha_tusker,Glow_US_Syracuse_condor,Glow_US_Syracuse_condor-ce01,Gluex_US_NUMEP_grid1,HCC_US_BNL_gk01,HCC_US_BNL_gk02,HCC_US_BU_atlas-net2,OSG_US_FIU_HPCOSGCE,OSG_US_Hyak_osg,OSG_US_UConn_gluskap,OSG_US_SMU_mfosgce",",") \ 
                ) && \ 
                ( isUndefined(GLIDEIN_Site) || !stringListMember(GLIDEIN_Site,"SU-OG,HOSTED_BOSCO_CE",",") )
rank = Mips
+AccountingGroup = "analysis.szhaozho"
+AcctGroup = "analysis"



+DESIRED_Sites = "T3_US_SDSC,T2_FR_GRIF_LLR,T3_US_Omaha,T2_CH_CERN_AI,T2_IT_Bari,T2_CH_CERN,T2_UA_KIPT,T2_IN_TIFR,T2_FR_IPHC,T2_IT_Rome,T2_US_Wisconsin,T2_DE_RWTH,T2_BR_UERJ,T2_ES_IFCA,T2_US_Caltech,T2_TW_Taiwan,T0_CH_CERN,T1_RU_JINR_Disk,T2_UK_London_IC,T2_US_Nebraska,T2_ES_CIEMAT,T3_US_Princeton,T2_PK_NCP,T2_CH_CERN_T0,T3_US_FSU,T3_KR_UOS,T3_IT_Perugia,T3_US_Minnesota,T2_TR_METU,T2_AT_Vienna,T2_US_Purdue,T3_US_Rice,T3_HR_IRB,T3_US_FIT,T2_PT_NCG_Lisbon,T1_ES_PIC,T3_US_JHU,T2_IT_Legnaro,T2_RU_INR,T3_US_FIU,T3_EU_Parrot,T2_RU_JINR,T3_UK_ScotGrid_GLA,T2_CH_CERN_HLT,T2_MY_UPM_BIRUNI,T2_PL_Warsaw,T3_AS_Parrot,T2_US_MIT,T2_BE_IIHE,T2_RU_ITEP,T1_CH_CERN,T3_CH_PSI,T3_IT_Bologna"


use_x509userproxy = True
x509userproxy = /tmp/x509up_u2300


Queue

EOF

#+DESIRED_Sites = "T3_US_SDSC,T2_FR_GRIF_LLR,T3_US_Omaha,T2_CH_CERN_AI,T2_IT_Bari,T2_CH_CERN,T2_UA_KIPT,T2_IN_TIFR,T2_FR_IPHC,T2_IT_Rome,T2_EE_Estonia,T2_US_Wisconsin,T2_HU_Budapest,T2_DE_RWTH,T2_BR_UERJ,T2_ES_IFCA,T2_US_Caltech,T2_TW_Taiwan,T0_CH_CERN,T1_RU_JINR_Disk,T2_UK_London_IC,T2_US_Nebraska,T2_ES_CIEMAT,T3_US_Princeton,T2_PK_NCP,T2_CH_CERN_T0,T3_US_FSU,T3_KR_UOS,T3_IT_Perugia,T3_US_Minnesota,T2_TR_METU,T2_AT_Vienna,T2_US_Purdue,T3_US_Rice,T3_HR_IRB,T3_US_FIT,T2_UK_SGrid_Bristol,T2_PT_NCG_Lisbon,T1_ES_PIC,T3_US_JHU,T2_IT_Legnaro,T2_RU_INR,T3_US_FIU,T3_EU_Parrot,T2_RU_JINR,T2_IT_Pisa,T3_UK_ScotGrid_GLA,T2_CH_CERN_HLT,T2_MY_UPM_BIRUNI,T1_FR_CCIN2P3,T2_FR_GRIF_IRFU,T2_FR_CCIN2P3,T2_PL_Warsaw,T3_AS_Parrot,T2_US_MIT,T2_BE_IIHE,T2_RU_ITEP,T1_CH_CERN,T3_CH_PSI,T3_IT_Bologna"

#srmcp -2 ntuple_${infn}.root gsiftp://se01.cmsaf.mit.edu:2811/\${SRM_PATH}/ntuple_${infn}.root

############################ Submit ###############################
	
#cat subfile
	condor_submit subfile
	mv subfile $LOGDIR/log-${infn}.subfile
	fileCounter=$((fileCounter+1))
    fi
done
echo "Submitted $fileCounter jobs to Condor."


initial=$((initial+1)) ; 
done

inifolder=$((inifolder+1)) ; 

done
