#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=short
#SBATCH --job-name=vary_a_low_u20
#SBATCH --output=vary_a_low_u20.txt
#SBATCH --array=1-30

# Run 100 array jobs, each with 10 replicates

# Create and move to working directory for job:
WORKDIR=/SSD/$USER/$SLURM_JOB_ID-$SLURM_ARRAY_TASK_ID
mkdir -p $WORKDIR
cd $WORKDIR

# Copy files over to working directory:
# Need the python driver, the slim model, the slimutil script, and the text file with command line arguments
BASE_DIR=/home/ikk23
cp $BASE_DIR/underdom/python_driver.py .
cp $BASE_DIR/underdom/nonWF-model.slim .
cp $BASE_DIR/underdom/slimutil.py .
cp $BASE_DIR/underdom/slurm_text_a_low_u_20.txt .

# Include SLiM in the path
PATH=$PATH:/home/ikk23/SLiM/SLiM_build
export PATH

# Only the first .part file has the header
# Output all 100 files to /home/ikk23/underdom/out
prog=`sed -n "${SLURM_ARRAY_TASK_ID}p" slurm_text_a_low_u_20.txt`
$prog > ${SLURM_ARRAY_TASK_ID}.part
cp ${SLURM_ARRAY_TASK_ID}.part $BASE_DIR/underdom/out

# Will need to merge later

# Clean up working directory:
rm -r $WORKDIR