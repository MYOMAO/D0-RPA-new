CONFIGFILE=$1
DESTINATION=$2
OUTFILE=$3
INFILE=$4
INFILE2=$5

echo "Current directory"
echo ${PWD}
ls -l


export X509_USER_PROXY=${PWD}/x509up_u2300

echo "Copying file"
gfal-copy gsiftp://se01.cmsaf.mit.edu:2811${INFILE} file://${PWD}/$INFILE2

if [[ $? -ne 0 ]]; then
      srmcp -2  gsiftp://se01.cmsaf.mit.edu:2811${INFILE} file://${PWD}/$INFILE2
fi
if [[ $? -ne 0 ]]; then
      lcg-cp -v -D srmv2 -b  gsiftp://se01.cmsaf.mit.edu:2811${INFILE} file://${PWD}/$INFILE2
fi
  
hostname

echo "Done copying file"


source /cvmfs/cms.cern.ch/cmsset_default.sh
#source /osg/app/cmssoft/cms/cmsset_default.sh
#export SCRAM_ARCH=slc5_amd64_gcc462
#cd /cvmfs/cms.cern.ch/slc5_amd64_gcc462/cms/cmssw-patch/CMSSW_5_3_2_patch4/src
#export SCRAM_ARCH=slc6_amd64_gcc472
#cd /cvmfs/cms.cern.ch/slc6_amd64_gcc472/cms/cmssw/CMSSW_5_3_24/src
#export SCRAM_ARCH=slc6_amd64_gcc491
#cd /cvmfs/cms.cern.ch/slc6_amd64_gcc491/cms/cmssw/CMSSW_7_5_0/src
export SCRAM_ARCH=slc6_amd64_gcc491
cd /cvmfs/cms.cern.ch/slc6_amd64_gcc491/cms/cmssw/CMSSW_7_5_8/src

eval `scramv1 runtime -sh` 
cd -

#root -l -b -q  $CONFIGFILE++\(\"${INFILE}\",\"${OUTFILE}\"\)
#root -l -b -q  $CONFIGFILE\(\"${INFILE}\",\"${OUTFILE}\"\)

./loop.exe "${INFILE2}" "${OUTFILE}"



if [[ $? -eq 0 ]]; then

	chmod 777 ${OUTFILE}

	gfal-copy file://${PWD}/${OUTFILE} gsiftp://se01.cmsaf.mit.edu:2811${DESTINATION}/${OUTFILE}

      if [[ $? -ne 0 ]]; then
	  srmcp -2 file://${PWD}/${OUTFILE} gsiftp://se01.cmsaf.mit.edu:2811${DESTINATION}/${OUTFILE}

      fi
      if [[ $? -ne 0 ]]; then
	  lcp-cp -v -D srmv2 -b file://${PWD}/${OUTFILE} gsiftp://se01.cmsaf.mit.edu:2811${DESTINATION}/${OUTFILE}

      fi

fi
