#!/bin/bash
#PBS -S /bin/sh 
#PBS -P uo95
#PBS -l jobfs=10GB
# The job will be executed from current working directory instead of home.
# -e ./error.txt
# -o ./output.txt
# -W umask=777 
#PBS -M gui@trampocfd.com
#PBS -m abe 

#need to set job name with -N
echo
#echo "================== nodes ===================="
#cat $PBS_NODEFILE
echo
echo "================= job info  ================="
echo File list:
ls -ltr
echo "Date:   $(date)"
echo "Job ID: $PBS_JOBID"
echo "Queue:  $PBS_QUEUE"
echo "Cores:  $PBS_NCPU"
echo "Total Memory:  $PBS_VMEM"

#echo "mpirun: $(which mpirun)" which messes up the mpi 
echo
echo "=================== run ====================="

cd $PBS_O_WORKDIR # this line was turned back on 01/03/2018 for manual mode running
#module load intel-mpi/5.0.3.048 try to use the mpi provided with STAR-CCM+
# As long as you set the same environment variables as we do (look at the I_MPI_-prefixed variables in the output of module show intel-mpi, except for I_MPI_ROOT) then Star-CCM+'s included Intel MPI will be identical to ours.
export I_MPI_FABRICS=shm:ofa 
export I_MPI_HYDRA_BOOTSTRAP=rsh
export I_MPI_HYDRA_BOOTSTRAP_EXEC=/opt/pbs/default/bin/pbs_tmrsh
export I_MPI_HYDRA_BRANCH_COUNT=$(sort -u $PBS_NODEFILE | uniq | wc -l)

echo "I_MPI_HYDRA_BRANCH_COUNT:  $I_MPI_HYDRA_BRANCH_COUNT"
#for platform mpi
export MPI_REMSH=/opt/pbs/default/bin/pbs_tmrsh
# bw export MPI_MAX_REMSH=$((PBS_NCPUS / 28))
# sb export MPI_MAX_REMSH=$((PBS_NCPUS / 16))
export MPI_MAX_REMSH=$((PBS_NCPUS / $CorePerNode))
#WORKDIR="${PBS_O_WORKDIR}/${PBS_NCPUS}"
#mkdir "${WORKDIR}" && cd "${WORKDIR}" || exit $?
#for open mpi
module load openmpi/1.8.4
export OPENMPI_DIR=$OPENMPI_ROOT

# https://thesteveportal.plm.automation.siemens.com/articles/en_US/FAQ/Swiss-STAR-CCM-Knife-7-Command-and-Conquer-How-to-pass-command-line-parameters-to-your-macros 
# need to pass ncpu to macro output.
# need to fix the macro that does'nt out the right ierations fr averaging
#2018-02-28 added -mesa
$StarCcmRunVersionPath -rsh /opt/pbs/default/bin/pbs_tmrsh -batch $BatchFlagCommand -machinefile $PBS_NODEFILE -mpi platform  -batch-report -np $PBS_NCPUS -power -licpath 1999@81.134.157.100 -podkey $Podkey -classpath /short/uo95/gj5914/JarFilesPOI3.15ForBasicPPT/ $SimulationPath > ${PBS_O_WORKDIR}/sim.log &
while jobs %%
do
#sleep $(AbortTimeHours)h
sleep 1h
echo "sleeping $(AbortTimeHours)h"

touch $PBS_WORKDIR/ABORT
echo "touch ABORT"
sleep 2m
echo "sleeping 2m for ABORT"
qdel PBS_JOBID
done
echo
echo "================ job done ==================="
echo "Date:   $(date)"
echo "retval: $retval"
echo