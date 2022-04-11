library(tidyverse)

path_to_csv = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/capacity50k.csv" 

path_to_save_fig = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/capacity50k.png"

csv = read_csv(path_to_csv)
View(csv)

replicate = rep("1",100)
csv = csv %>% add_column(replicate)
write_csv(csv,path_to_csv)

gen_vs_N = ggplot(csv,aes(x=generation, y = N)) + geom_point(color="red") + geom_line()

gen_vs_N

range(csv$N) # min = 49,297 and max=50,748 (range of 1451)

ggsave(filename = path_to_save_fig, plot = gen_vs_N)

# Combined replicate fig
for (i in 1:5){
  path_to_csv = paste0("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate",i,".csv")
  csv = read_csv(path_to_csv)
  if (i == 1){
    combined_csv = csv
  } else {
    combined_csv = rbind(combined_csv, csv)
  }
}

lower = min(combined_csv$N)
upper = max(combined_csv$N)
combined_csv$replicate = as.character(combined_csv$replicate)
gen_vs_N = ggplot(combined_csv,aes(x=generation, y = N, color = replicate)) + geom_point() + geom_line() + ylim(c(lower,upper)) + geom_hline(yintercept = 30000)
ggsave(plot = gen_vs_N, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_combined_replicates_plot.png")

three_replicates = combined_csv %>% filter(replicate %in% c("1","2","3"))
gen_vs_N3 = ggplot(three_replicates,aes(x=generation, y = N, color = replicate)) + geom_point() + geom_line() + ylim(c(min(three_replicates$N),max(three_replicates$N))) + geom_hline(yintercept = 30000)
ggsave(plot = gen_vs_N3, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_combined_replicates_first_3.png")

comp_multiplier = function(beta, exponent, density = "normal"){
  if (density == "normal"){
    competition_factor = 1
  } else if (density == "empty"){
    competition_factor = 0
  } else if (density == "crowded"){
    competition_factor = 2
  }
  
  actual_competition_factor = beta/(((beta-1)*competition_factor) + 1)
  actual_competition_factor_exponentiated = actual_competition_factor^exponent
  return(actual_competition_factor_exponentiated)
}


