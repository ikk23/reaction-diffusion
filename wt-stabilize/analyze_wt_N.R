library(tidyverse)

path_to_csv = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp1.csv"

path_to_save_fig = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp1_gen_vs_N.png"

csv = read_csv(path_to_csv)
View(csv)

gen_vs_N = ggplot(csv,aes(x=generation, y = N)) + geom_point(color="red") + geom_line()

gen_vs_N

range(csv$N) # min = 29,249 and max = 30,810 (range = 1561)

ggsave(filename = path_to_save_fig, plot = gen_vs_N)
