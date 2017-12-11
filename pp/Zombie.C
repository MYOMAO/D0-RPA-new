#ifndef __CINT__
#include "TROOT.h"
#include "TH1.h"
#include "TTree.h"
#include "TH2.h"
#include "TF1.h"
#include "TFile.h"
#include "TMath.h"
#include "TSystem.h"
#include "TVector2.h"
#include "TLorentzVector.h"
#include "TVector3.h"
#include "TRandom.h"
#include <iostream>
#include <fstream>
#include "uti.h"
#include "stdio.h"

using namespace std;

using std::cout;
using std::endl;
#endif


void Zombie(){
TFile *fin = 0;


	const int N =4000;

const int NPDini =1;
const int NPD = 20;

	for(int j=NPDini; j < NPD+1; j++)
	{

	TString Location = Form("/mnt/hadoop/cms/store/user/zzshi/Data/Dntuple/MinimumBias%d",j);
	for(int i = 0; i < N; i ++)
	{


	TString Name = Form("ntuple_finder_pp_%d.root",i);
TString File = Form("%s/%s",Location.Data(),Name.Data());

fin = TFile::Open(File.Data());


 if(fin == 0) {

 cout << Name.Data() << " will be deleted" << endl;

remove( File.Data() );

if(remove( File.Data()) != 0)
{
	cout << "Deleted Empty Files No Worries" << endl;
}

if(remove( File.Data()) == 0)
{
	cout << "Deleted Zombine File :   " <<  File.Data() << "  Please check its existence" << endl;
}


 }

 else{
fin->Close();
	}

fin = 0; 
	}

	}

}
