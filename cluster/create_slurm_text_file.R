a_seq = seq(0.018, 0.025, length.out=30)

# Start writing to a new output file
sink('/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/scripts/slurm_text_a_in_range_u20.txt')

for (i in 1:length(a_seq)){
  a = a_seq[i]
  if (i == 1){
    line = paste0("python python_driver.py -a ",a," -header","\n")
  } else {
    line = paste0("python python_driver.py -a ",a, "\n")
  }
  cat(line)
}

# Stop writing to the file
sink()
