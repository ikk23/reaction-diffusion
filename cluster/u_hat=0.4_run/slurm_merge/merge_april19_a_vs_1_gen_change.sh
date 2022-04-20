#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=short
#SBATCH --job-name=merge_april19_vs_1_gen_change
#SBATCH --output=merge_april19_vs_1_gen_change.txt

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
cat *.part > revised_slim_uhat40_a_vs_change_april_19.csv

OUTPUT_DIR=/home/ikk23/underdom/csvs
cp revised_slim_uhat40_a_vs_change_april_19.csv $OUTPUT_DIR

# Removing the scratch directory
rm -rf $WORKDIR