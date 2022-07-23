#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=regular
#SBATCH --job-name=p_increase_with_m
#SBATCH --output=p_increase_with_m.txt
#SBATCH --array=1-33

# 33 values of m with 20 replicates each -- should yield 33 files with 20 lines each

# Create and move to working directory for job:
WORKDIR=/workdir/$USER/$SLURM_JOB_ID-$SLURM_ARRAY_TASK_ID
mkdir -p $WORKDIR
cd $WORKDIR

# Copy files over to working directory:
# Need the python driver, the slim model, the slimutil script, and the text file with command line arguments
BASE_DIR=/home/ikk23
cp $BASE_DIR/underdom/main_scripts/python_driver_p_increase.py .
cp $BASE_DIR/underdom/main_scripts/nonWF-diffusion-model.slim .
cp $BASE_DIR/underdom/main_scripts/slimutil.py .
cp $BASE_DIR/underdom/text_files/text_file_p_increase.txt .

# Include SLiM in the path
PATH=$PATH:/home/ikk23/SLiM/SLiM_build
export PATH

# Only the first .part file has the header
# Output all files into an output-specific folder
prog=`sed -n "${SLURM_ARRAY_TASK_ID}p" text_file_p_increase.txt`
$prog > m_index_${SLURM_ARRAY_TASK_ID}.csv
cp m_index_${SLURM_ARRAY_TASK_ID}.csv $BASE_DIR/underdom/raw_output

# Will need to merge later

# Clean up working directory:
rm -r $WORKDIR