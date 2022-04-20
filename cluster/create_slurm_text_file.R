
u_hat = 0.4

a_seq = seq(0.001,0.1,length.out=200)
python_script = "python_driver_num_drives.py"


# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_text/april19_uhat40_a_vs_1_gen_change.txt')

for (i in 1:length(a_seq)){
  a = a_seq[i]
  if (i == 1){
    line = paste0("python ",python_script," -a ",a," -u_hat ",u_hat," -header","\n")
  } else {
    line = paste0("python ",python_script, " -a ",a, " -u_hat ", u_hat, "\n")
  }
  cat(line)
}

# Stop writing to the file
sink()
