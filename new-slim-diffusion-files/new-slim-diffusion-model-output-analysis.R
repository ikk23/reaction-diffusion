diffusion_nAA_expectation = function(x, sigma, m){
  D = 0.5*(sigma^2)
  t = 1
  term1 = m/sqrt(4*pi*D*t)
  x_adjust = x - 0.5 # the equation assumes that the drop occurred at x=0
  term2 = exp(-0.25*((x_adjust^2)/(D*t)))
  sol = term1*term2
  return(sol)
}

x_left = seq(0.0,0.98,by=0.02)
x_right = seq(0.02,1.0,by=0.02)
x_midpoints = (x_left+x_right)/2
m = 10000
sigma = 0.1


predicted_nAA = rep(-1,50)
for (i in 1:50){
  predicted_nAA[i] = diffusion_nAA_expectation(x_midpoints[i], sigma, m)
}

actual_nAA = rep(0,50)
actual_nAA[8:43] = c(100,150,350,550,900,1600,2700,3600,6150,9600,13150,16900,22500,28150,30650,34450,38200,37800,38500,40150,35600,31650,25800,21200,17600,13550,10100,6250,4900,2300,1900,1450,500,750,150,100)

library(tidyverse)
info = tibble(x = x_midpoints, predicted_nAA = predicted_nAA, actual_nAA = actual_nAA)
p = ggplot(info, aes(x = x )) + theme_minimal() + geom_line(aes(y = actual_nAA),color = "black") + xlab("x") + ylab("n'AA(x,t=1)") + ggtitle(paste0("drop size of ",m,", sigma = ",sigma," (D=",0.5*(sigma^2),") \nprediction in red, results in black")) + geom_line(aes(y = predicted_nAA), color = "red")
p

ggsave(filename = "/Users/isabelkim/Desktop/nAA_prime_predictions_vs_results_m10000_sigma0.1.png") 
