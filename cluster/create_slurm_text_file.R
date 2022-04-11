
u_hat = 0.05

a_seq = c(seq(0.001,0.015,length.out=100), seq(0.02,1.0,length.out=50))


# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.05_run/slurm_text/uhat5_april11_full_a_run.txt')

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
