# Plot the number of drive homozygotes and drive heterozygotes, and the rate of the drive allele over time
library(tidyverse)

info = tibble(gen = 1:8, 
              num_dd = c(410, 9, 15, 8, 4, 4, 3, 1), 
              num_d_wt = c(0,860,633,573,493,369,310,316),
              rate = c(0.0425311,0.0448463, 0.0350682,0.030799,0.0258834,0.0196785,0.0168157,0.0165711))

par(mfrow = c(2,1))
p = ggplot(info, aes(x=gen)) + 
  geom_line(aes(y=num_dd), color = "blue") + 
  geom_line(aes(y = num_d_wt), color = "red")
print(p)

y = ggplot(info, aes(x = gen, y = rate)) + geom_line()
print(y)
