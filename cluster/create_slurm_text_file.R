a_seq = seq(0.005, 0.02, length.out = 100)

# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.05_run/slurm_text/u005_a_0.005_to_0.02.txt')

for (i in 1:length(a_seq)){
  a = a_seq[i]
  if (i == 1){
    line = paste0("python python_driver.py -a ",a," -u_hat 0.05 -header","\n")
  } else {
    line = paste0("python python_driver.py -a ",a, " -u_hat 0.05", "\n")
  }
  cat(line)
}

# Stop writing to the file
sink()
