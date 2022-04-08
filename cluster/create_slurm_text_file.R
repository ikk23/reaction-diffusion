n = 101
a_vector = seq(0, 0.03, length.out=n)
a_seq_middle = a_vector[2:n]
a_seq_lower = seq(0.0001,0.00029,length.out=10)
a_seq_upper = seq(0.0303, 0.999, length.out = 40)
a_seq = c(a_seq_lower, a_seq_middle, a_seq_upper) # 150 total jobs
# a_seq_lower and a_seq_upper will have 50 replicates each
# but a_seq_middle will have 100
u_hat = 0.2


# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/slurm_text/second_run.txt')

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
