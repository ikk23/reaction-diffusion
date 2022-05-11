#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=short
#SBATCH --job-name=u_runs_merge
#SBATCH --output=u_runs_merge.txt

# make temporary working directory
USER=ikk23
WORKDIR=/workdir/${USER}-${SLURM_JOB_ID}
mkdir $WORKDIR

# go to directory where part files are located
DIR=/home/ikk23/underdom/out_u_runs

# copy all files into the temporary working directory
cd $DIR
cp * $WORKDIR/

# go back to scratch directory
cd $WORKDIR

# merge all .part files into overall csv. Should be 50
cat *.part > u_check_with_a0.02.csv

OUTPUT_DIR=/home/ikk23/underdom/csvs
cp u_check_with_a0.02.csv $OUTPUT_DIR

# Removing the scratch directory
rm -rf $WORKDIR