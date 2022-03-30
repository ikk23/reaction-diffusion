#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=short
#SBATCH --job-name=merge_u20_a_0.01_to_0.03
#SBATCH --output=merge_u20_a_0.01_to_0.03.txt

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
cat *.part > u20_a_0.01_to_0.03.csv

OUTPUT_DIR=/home/ikk23/underdom/csvs
cp u20_a_0.01_to_0.03.csv $OUTPUT_DIR

# Removing the scratch directory
rm -rf $WORKDIR