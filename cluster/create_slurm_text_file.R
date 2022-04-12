
u_hat = 0.4

a_seq = c(seq(0.0001,0.15,length.out=100), seq(0.17,1.0,length.out=50))


# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_text/uhat40_april12_full_a_run.txt')

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
