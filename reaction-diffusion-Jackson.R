# Jackson's reaction-diffusion equations

# 1. Reaction-diffusion of females
# F(x,t) = the number of females at time t and position x
# Df = the diffusion constant for females
# lambda = the reproduction rate / probability that a random female reproduces
# mu = the constant death rate
# gamma = the density-dependent death rate. Depends on N(x,t)

# dF(x,t)/dt = [Df (d^2/dx^2)(F(x,t))] + [lambda F(x,t) - (mu + gamma*N(x,t))F(x,t)]
# for simplicity, let's get rid of the density-dependent death rate for now

# dF(x,t)/dt = [Df (d^2/dx^2)(F(x,t))] + [F(x,t)*(lambda-mu)]
#               (diffusion of females)  + (births - deaths of females)

# Need to find the function F(x,t) that fulfills this


