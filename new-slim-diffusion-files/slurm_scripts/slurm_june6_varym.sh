#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=short
#SBATCH --job-name=june6_varym
#SBATCH --output=june6_varym.txt
#SBATCH --array=1-50

# Run 50 array jobs, each with 20 replicates

# Create and move to working directory for job:
WORKDIR=/workdir/$USER/$SLURM_JOB_ID-$SLURM_ARRAY_TASK_ID
mkdir -p $WORKDIR
cd $WORKDIR

# Copy files over to working directory:
# Need the python driver, the slim model, the slimutil script, and the text file with command line arguments
BASE_DIR=/home/ikk23
cp $BASE_DIR/underdom/main_scripts/python_driver_vary_m.py .
cp $BASE_DIR/underdom/main_scripts/nonWF-diffusion-model.slim .
cp $BASE_DIR/underdom/main_scripts/slimutil.py .
cp $BASE_DIR/underdom/text_files/june6_varym.txt .

# Include SLiM in the path
PATH=$PATH:/home/ikk23/SLiM/SLiM_build
export PATH

prog=`sed -n "${SLURM_ARRAY_TASK_ID}p" june6_varym.txt`
$prog > ${SLURM_ARRAY_TASK_ID}.part
cp ${SLURM_ARRAY_TASK_ID}.part $BASE_DIR/underdom/out_u20

# Will need to merge later

# Clean up working directory:
rm -r $WORKDIR