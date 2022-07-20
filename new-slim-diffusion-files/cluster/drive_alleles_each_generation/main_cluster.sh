#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=regular
#SBATCH --job-name=drive_alleles_over_time
#SBATCH --output=drive_alleles_over_time.txt
#SBATCH --array=1-4

# Run 4 array jobs, each with 20 replicates

# Create and move to working directory for job:
WORKDIR=/workdir/$USER/$SLURM_JOB_ID-$SLURM_ARRAY_TASK_ID
mkdir -p $WORKDIR
cd $WORKDIR

# Copy files over to working directory:
# Need the python driver, the slim model, the slimutil script, and the text file with command line arguments
BASE_DIR=/home/ikk23
cp $BASE_DIR/underdom/main_scripts/python_drive_num_drive_alleles_100_gens.py .
cp $BASE_DIR/underdom/main_scripts/nonWF-diffusion-model.slim .
cp $BASE_DIR/underdom/main_scripts/slimutil.py .
cp $BASE_DIR/underdom/text_files/text_file_cluster.txt .

# Include SLiM in the path
PATH=$PATH:/home/ikk23/SLiM/SLiM_build
export PATH

# Only the first .part file has the header
# Output all files into an output-specific folder
prog=`sed -n "${SLURM_ARRAY_TASK_ID}p" text_file_cluster.txt`
$prog > m_${SLURM_ARRAY_TASK_ID}.part
cp m_${SLURM_ARRAY_TASK_ID}.part $BASE_DIR/underdom/raw_output

# Will need to merge later

# Clean up working directory:
rm -r $WORKDIR