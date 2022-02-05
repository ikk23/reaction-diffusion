# the spread of an advantageous allele

N = 100 # pop size (haploid for now)
u = 0.3 # starting freq
t = 100 # generations

for (i in 1:t){
  u = u*(1-u)
  print(paste("generation:",i,"u=",round(u,4)))
}
