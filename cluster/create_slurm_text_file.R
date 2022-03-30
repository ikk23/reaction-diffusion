a_seq = seq(0.001, 0.0049, length.out = 20)
u_hat = 0.05

# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.05_run/slurm_text/u5_lower_a.txt')

for (i in 1:length(a_seq)){
  a = a_seq[i]
  if (i == 1){
    line = paste0("python python_driver.py -a ",a," -u_hat ",u_hat," -header","\n")
  } else {
    line = paste0("python python_driver.py -a ",a, " -u_hat ", u_hat, "\n")
  }
  cat(line)
}

# Stop writing to the file
sink()
