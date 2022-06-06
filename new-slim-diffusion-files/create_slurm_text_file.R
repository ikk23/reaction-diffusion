nreps = 20
python_script = "python_driver_vary_m.py"

dropsizes = seq(100, 1000, length.out = 50)
drop_size_vector = round(dropsizes)

# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_text/june6_varym.txt')

for (i in 1:length(drop_size_vector)){
  m = drop_size_vector[i]
  if (i == 1){
    line = paste0("python ",python_script," -m ",m," -header","\n")
  } else {
    line = paste0("python ",python_script," -m ",m,"\n")
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
