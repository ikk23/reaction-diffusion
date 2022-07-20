#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=regular
#SBATCH --job-name=merge_diff_m
#SBATCH --output=merge_diff_m.txt

# make temporary working directory
USER=ikk23
WORKDIR=/workdir/${USER}-${SLURM_JOB_ID}
mkdir $WORKDIR

# go to directory where part files are located
DIR=/home/ikk23/underdom/raw_output

# copy all files into the temporary working directory
cd $DIR
cp m_value_*.part $WORKDIR/

# go back to scratch directory
cd $WORKDIR

# merge all .part files into overall csv
cat m_value_*.part > sigma_0.01_k_alpha_0.2_change_m.csv

OUTPUT_DIR=/home/ikk23/underdom/csvs
cp sigma_0.01_k_alpha_0.2_change_m.csv $OUTPUT_DIR

# Removing the scratch directory
rm -rf $WORKDIR