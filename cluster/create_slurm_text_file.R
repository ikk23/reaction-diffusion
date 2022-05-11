
u_hat = 0.4

nreps = 20
narray = 50
python_script = "python_u_driver.py"

# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/may10_u_runs.txt')

for (i in 1:narray){
  if (i == 1){
    line = paste0("python ",python_script," -nreps ",nreps," -header","\n")
  } else {
    line = paste0("python ",python_script," -nreps ",nreps,"\n")
  }
  cat(line)
}

# Stop writing to the file
sink()





# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_text/april20_windowed_drive_analysis_uhat40.txt')

for (i in 1:length(a_seq)){
  a = a_seq[i]
  if (i == 1){
    line = paste0("python ",python_script," -a ",a," -u_hat ",u_hat," -nreps ",nreps," -header","\n")
  } else {
    line = paste0("python ",python_script, " -a ",a, " -u_hat ", u_hat," -nreps ",nreps, "\n")
  }
  cat(line)
}

# Stop writing to the file
sink()
