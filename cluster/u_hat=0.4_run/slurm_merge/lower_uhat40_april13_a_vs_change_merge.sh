#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=short
#SBATCH --job-name=lower_merge_uhat40_april13_a_vs_change
#SBATCH --output=lower_merge_uhat40_april13_a_vs_change.txt

# make temporary working directory
USER=ikk23
WORKDIR=/workdir/${USER}-${SLURM_JOB_ID}
mkdir $WORKDIR

# go to directory where part files are located
DIR=/home/ikk23/underdom/out_u40

# copy all files into the temporary working directory
cd $DIR
cp * $WORKDIR/

# go back to scratch directory
cd $WORKDIR

# merge all .part files into overall csv
cat *.part > lower_uhat40_april13_a_vs_change.csv

OUTPUT_DIR=/home/ikk23/underdom/csvs
cp lower_uhat40_april13_a_vs_change.csv $OUTPUT_DIR

# Removing the scratch directory
rm -rf $WORKDIR