# Passing functions in as arguments to another function

### RXN 
reaction1 = function(u,k){
  fu = k*u*(1-u) # Fisher
  return(fu)
}

reaction2 = function(u,k,alpha){
  u_hat = (1-alpha)/2
  fu = 2*u*(1-u)*(u-u_hat) # Barton
  return(fu)
}

reaction3 = function(u){
  fu = (0.5)*(u) # always half the number of gene drive carriers for example
  return(fu)
}

# Will probably need to make the assumption that this function takes u in as an argument and possibly two other parameters
apply_function = function(FUNC,u,other_parameters=NULL){
 # check that FUNC is a real function
  if (!is.function(FUNC)){
    stop("argument FUNC is not a function")
  }
  n = length(other_parameters)
  if (n==0){
    sol = FUNC(u)
  } else if (n==1){
    sol = FUNC(u,other_parameters)
  } else if (n==2){
    sol = FUNC(u, other_parameters[1],other_parameters[2])
  } else {
    stop("FUNC has more than 2 parameters.")
  }
  return(sol)
}

# Ex: Fisher reaction with u = 0.5, k = 0.1
apply_function(FUNC=reaction1,u=0.5,other_parameters = 0.1) == reaction1(u=0.5,k=0.1)

# Ex: Barton reaction with u = 0.5, k = 0.1, alpha = 0.3
apply_function(FUNC=reaction2, u=0.5,other_parameters = c(0.1,0.3)) == reaction2(u=0.5,k=0.1,alpha=0.3)

# Ex:  always halfing the u
apply_function(FUNC=reaction3,u=0.5) == reaction3(u=0.5)

# In the main function, take the "REACTION_FUNCTION" as one variable, u as another, and additional_reaction_arguments as a third. If the reaction equation is a Fisher wave, then additional_reaction_arguments will only have k. If it's a bistable wave, then additional_reaction_arguments will have k and alpha. Or, if it's some random reaction equation that I've defined, it may have zero additional_reaction_arguments, so set this argument to NULL by default.

### u(x,t) function

# first we need to define a function that only takes in x and maybe 1 additional parameter. Assume t = t0.
# I don't think this needs to be passed into the wave. You could just pass in the input (x) and output (y).

# x is assumed to be a vector
u_normal = function(x,mu,sigma){
  values = dnorm(x,mean=mu,sigma=sd)
  return(values)
}

u_exponential = function(x,lambda){
  values = dexp(x=x,rate=lambda)
  return(values)
}

uxt = dunif(x=0:10,min=5,max=15)
plot(0:10,uxt)

# Just pass in (a) x_grid, and (b) initial_uxt. That way, u(x,t) doesn't even need to be a mathematical function.



