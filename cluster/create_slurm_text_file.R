a_seq = seq(0.01, 0.03, length.out = 100)

# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/slurm_text/u20_a_0.01_to_0.03_50_replicates.txt')

for (i in 1:length(a_seq)){
  a = a_seq[i]
  if (i == 1){
    line = paste0("python python_driver.py -a ",a," -u_hat 0.2 -header","\n")
  } else {
    line = paste0("python python_driver.py -a ",a, " -u_hat 0.2", "\n")
  }
  cat(line)
}

# Stop writing to the file
sink()
