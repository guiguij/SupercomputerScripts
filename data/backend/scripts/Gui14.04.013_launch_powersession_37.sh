#!/bin/bash
# PLEASE READ ALL COMMENTS BEFORE LAUNCHING A JOB, WATCH SB JOBS FOR LACK OF MEMORY
# Sb: for i in 16 32 64 128 256 512 1024 2048 4096 8192 16384
# Bw: for i in 28 56 112 224 448 896 1792 3584 7168 14336
# set the working directory of this script by saving it in the working directory, then cd WorkingDirectoryPath,
for i in 16 
do
m=$((30 * (i / 16)))


# Sb:          -q normal      m=$((30 * (i / 16)))  # 125GB and 64GB  available per node up to 1024 cores (64nodes)/  32GB above 1024 cores (64nodes)  see page 55 of C:\Users\Administrator\Dropbox\Trampo\IT\computers\Raijin\Using-Raijin1.pdf
  # Bw:          -q normalbw    m=$((125 * (i / 28)))
  # Express Bw:  -q expressbw   m=$((125 * (i / 28))) 
  #when you are asking a whole memory available on the node and the job needs more, the job will be killed by system OEM killer and you will not get any meaningful error message. I
  #If you will ask for a bit less, let say 30GB for normal queue and 125GB for normalbw queue, the job exceeding memory will be killed by PBS and you will get (in most cases  !) an error message

  
	echo $i Cores -  $m GB	
		qsub -N DEM_16cores -q normal -lncpus=$i -e ./$i.err -o ./$i.out -lmem=${m}GB -lwalltime=03:30:00 -v StarCcmRunVersionPath="/short/uo95/gj5914/starccm/mixed/14.04.013/STAR-CCM+14.04.013/star/bin/starccm+",BatchFlagCommand="run",SimulationPath="/g/data3/uo95/backend/data/customer_268353110041/Synchronised_Folder2/sim_1/SupercomputerTest_0-06mmPartDist_1mmChute_Mesh10mm.sim",CorePerNode="16" "/g/data3/uo95/backend/scripts/Gui14.04.013_run_powersession_37.sh"
		done

# to run, 
# edit: core count, -lwalltime, STAR-CCM+ version, PODkey, Simulation Path, 
# then copy script and corresponding run script in run folder, 
# cd to this folder, 
# sed -i -e 's/\r$//' "scriptName", 
# copy script path to terminal and press enter