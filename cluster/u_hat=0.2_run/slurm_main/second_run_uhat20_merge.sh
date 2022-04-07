#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=short
#SBATCH --job-name=second_run_uhat20_merge
#SBATCH --output=second_run_uhat20_merge.txt

# make temporary working directory
USER=ikk23
WORKDIR=/workdir/${USER}-${SLURM_JOB_ID}
mkdir $WORKDIR

# go to directory where part files are located
DIR=/home/ikk23/underdom/out_u20

# copy all files into the temporary working directory
cd $DIR
cp * $WORKDIR/

# go back to scratch directory
cd $WORKDIR

# merge all .part files into overall csv
cat *.part > second_run_uhat20.csv

# copy csv to my folder
OUTPUT_DIR=/home/ikk23/underdom/csvs
cp second_run_uhat20.csv $OUTPUT_DIR

# Removing the scratch directory
rm -rf $WORKDIR