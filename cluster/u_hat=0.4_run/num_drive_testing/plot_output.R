
# INPUT
csv_name= "a0_0005.csv"
a = 0.0005

library(tidyverse)
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/num_drive_testing/figures/"

data = read_csv(paste0("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/num_drive_testing/",csv_name))

p = ggplot(data, aes(x=gen, y = num_drive_alleles)) + geom_point(color = "red") + geom_line(color = "red") + labs(title = paste0("a = ",a)) + ylab("drive allele count") + xlab("gens since release") + geom_hline(yintercept = 0) + geom_vline(xintercept = 0)
print(p)

ggsave(plot = p, filename = paste0(dir, "a_",a,".png"))
