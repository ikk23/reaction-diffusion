
# INPUT
a = 0.1
nreplicates = 5
output_csv = TRUE # if true, output the compiled replicate csv

library(tidyverse)
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/num_drive_testing/"

# compile replicate csvs
for (i in 1:nreplicates){
  # INPUT a HERE SO IT DOESN'T GET TO SCIENTIFIC NOTATION
  file = paste0(dir, "a_0.1_replicate",i,".csv")
  data = read_csv(file)
  
  # add a replicate column
  replicate = rep(as.character(i),nrow(data))
  data = data %>% add_column(replicate)
  
  if (i==1){
    compiled = data
  } else {
    compiled = rbind(compiled, data)
  }
}

if (output_csv){
  path = paste0(dir, "a_",a,"_compiled.csv")
  write_csv(file = path, x = compiled)
}

p = ggplot(compiled, aes(x=gen, y = num_drive_alleles, color = replicate)) + 
  geom_line() +
  labs(title = paste0("a = ",a)) + ylab("drive allele count") + xlab("gens since release") + 
  geom_hline(yintercept = 0) + geom_vline(xintercept = 0)

print(p)

ggsave(plot = p, filename = paste0(dir, "/figures/a_",a,".png"))
