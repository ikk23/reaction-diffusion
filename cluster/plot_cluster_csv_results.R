library(tidyverse)
source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/scripts/functions-main-model.R")

# PATH TO THE CLUSTER OUTPUT
file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/scripts/vary_a_in_range_u20.csv"

nreps = 50


dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/csv_raw/"
data1 = read_csv(paste0(dir,"vary_a_low_u20.csv"))
data2 = read_csv(paste0(dir, "vary_a_in_range_u20.csv"))
data3 = read_csv(paste0(dir, "vary_a_u20.csv"))
data = rbind(data1,data2,data3) %>% arrange(a)


# For each row, get the beta and delta value
n = nrow(data)
beta_vector = rep(-1,n)
delta_vector = rep(-1,n)
for (i in 1:n){
  a = data$a[i]
  sigma = data$sigma[i]
  u_hat = data$u_hat[i]
  k = data$k[i]
  beta = a/sigma
  beta_vector[i] = beta
  delta = check_for_delta_0_when_b_is_1(u_hat, beta, sigma, k)
  delta_vector[i] = delta
}
data = data %>% add_column(beta = beta_vector, .after = 2) %>% add_column(delta = delta_vector)
# write out the raw data
output_path = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/csvs/uhat_0.2_full.csv"
write_csv(x = data, file = output_path)

# Group by common values of a
starts = seq(1, n, by = nreps)
nparams = length(starts)
a_vector = rep(-1,nparams)
beta_vector = rep(-1,nparams)
sigma_vector = rep(-1,nparams)
k_vector = rep(-1,nparams)
u_hat_vector = rep(-1,nparams)
delta_vector = rep(-1,nparams)
p_increase_vector = rep(-1,nparams)

for (i in 1:nparams){
  j = starts[i]
  rows = data[j:(j+nreps-1),]
  
  # these will be the same for all replicates
  a_vector[i] = rows$a[1]
  sigma_vector[i] = rows$sigma[1]
  beta_vector[i] = rows$beta[1]
  k_vector[i] = rows$k[1]
  u_hat_vector[i] = rows$u_hat[1]
  delta_vector[i] = rows$delta[1]
  
  # calculate the proportion of times that the drive increased
  p_increase_vector[i] = mean(rows$outcome == "increase")
  
}

# Compile summary tibble
summarize_data = tibble(a = a_vector, sigma = sigma_vector, beta = beta_vector,
                        k = k_vector, u_hat = u_hat_vector, delta = delta_vector,
                        p_increase = p_increase_vector)

# Write out
output_path = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/csvs/uhat_0.2_summary.csv"
write_csv(x = summarize_data, file = output_path)

# Get the parameter set that had the closest AUC1-AUC0 to 0
# this would be the predicted value of a that'd lead to the critical propagule -- expect to see p(increase) = 0.5
ind = which.min(summarize_data$delta)
min_row = summarize_data[ind,] 
a_prop = min_row$a
delta_min = min_row$delta

# Get the observed a that had p(increase) closest to 50%
diff = abs(summarize_data$p_increase - 0.5)
ind = which.min(diff)
a_obs = summarize_data$a[ind]
delta_obs = summarize_data$delta[ind]
p_increase_obs = summarize_data$p_increase[ind]

# Plot p(increase) as a function of a
plot_freqs_and_a = ggplot(summarize_data, aes(x = a, y = p_increase)) + 
  geom_point(color = "red") + 
  geom_line(color = "grey") +
  geom_vline(xintercept = a_prop) + 
  ylab("P(increase)") + 
  labs(title = paste0("sigma =",summarize_data$sigma[1], 
                      "  k=",summarize_data$k[1],"  u_hat=", summarize_data$u_hat[1],
                      "  nreps = ", nreps), 
       subtitle = paste0("a* = ", round(a_prop,4), " (delta* = ", round(delta_min,4),") but a_obs =",round(a_obs,4)," (delta_obs =", round(delta_obs,4),")")) 

# Output final graph
plot_path = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/figures/final_uhat_20_sigma0.01_uhat_0.2_k_0.2.png"

ggsave(filename = plot_path, plot = plot_freqs_and_a)
