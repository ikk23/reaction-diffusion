
# NEGATIVE diffusion term
diffusion_side = function(m,D){
  pd = m/sqrt(pi*D)
  sol = -(pd/2) + pd
  return(sol)
}

reaction_side = function(m,D,N,alpha,k){
  pd = m/sqrt(pi*D)
  pw = 2*N
  fdd = 1 + (2*alpha*k)
  fdw = 1 + ((alpha-1)*k)
  rho_sum = pd + pw
  
  term1 = ((pd^2)*(fdd))/rho_sum
  term2 = (pd*pw*fdw)/rho_sum
  sol = term1 + term2 - pd

  return(sol)
}

N = 30000
k = 0.2
alpha = 0.6

library(tidyverse)
D = 0.5*(0.01^2)

fdw = 1 + ((alpha-1)*k)
fdd = 1 + (2*alpha*k)
numerator = 2*N*sqrt(pi*D)*((sqrt(2)*(fdw - 2))+1)
denominator = (sqrt(2)*(2-fdd))-1
numerator/denominator # negative.


# Plot the reaction side and diffusion side for different values of m
m_seq = seq(-300,10000,by=50) 
diffusion_side_seq = rep(-1,length(m_seq))
reaction_side_seq = rep(-1,length(m_seq))
reaction_diffusion_seq = rep(-1,length(m_seq))
for (i in 1:length(m_seq)){
  m = m_seq[i]
  d = diffusion_side(m,D)
  r = reaction_side(m,D,rho,alpha,k)
  reaction_diffusion_solution = (-1*d) + r
  
  
  reaction_diffusion_seq[i] = reaction_diffusion_solution
  diffusion_side_seq[i] = d
  reaction_side_seq[i] = r
}
results = tibble(m = m_seq,
                 diffusion_term = diffusion_side_seq,
                 reaction_term = reaction_side_seq,
                 reaction_diffusion_term = reaction_diffusion_seq)

# Plot the reaction and diffusion side in different colors and see where the 2 lines cross
p_separate = ggplot(results, aes(x = m)) + geom_line(aes(y = diffusion_term), color = "purple") +
  geom_line(aes(y = reaction_term), color = "orange") + theme_minimal() + ggtitle(paste0("Purple: -diffusion term \nOrange: reaction term \nD=",D,", rho = ",rho,", k = ",k,", alpha = ",alpha)) + geom_vline(xintercept = 0) + geom_hline(yintercept = 0) + ylab("value") 

p_separate




# Plot the thing that should be equal to 0
should_be_zero = ggplot(results, aes(x = m, y = reaction_diffusion_term)) + geom_line(color = "dodgerblue") + theme_minimal() + ylab('value') + ggtitle("diffusion term + reaction term --> find 0 \nD=0.00005, rho = 30000, k=0.2, alpha=0.6, uhat = 0.2") + geom_vline(xintercept=0) + geom_hline(yintercept=0)

should_be_zero

ggsave(filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/random_figures/reaction_and_diffusion_term_together.png", plot = should_be_zero)
