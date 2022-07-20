

mathematica_solution = function(rho,D,alpha,k){
  multiplier = 2*sqrt(pi)
  term1_numerator = sqrt(2*(rho^2)*D*k*(1 + (2*alpha*k)))
  term2_numerator = rho*sqrt(D)*(1 + (2*alpha*k))
  numerator = multiplier*(term1_numerator+term2_numerator)
  denominator = 1 + (2*alpha*k)
  
  msol1 = numerator/denominator
  msol2 = -(numerator/denominator)
  msol3 = 0
  
  solutions = c(msol3, msol1, msol2)
  return(solutions)
}

D = 0.5*(0.01^2)
rho = 30000
alpha = 0.2
k = 0.2
mathematica_solution(rho,D,alpha,k)
