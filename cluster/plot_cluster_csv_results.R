library(tidyverse)
source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/scripts/functions-main-model.R")

# PATH TO THE RAW CLUSTER OUTPUT
file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/csv_raw/bug_fixed_second_run_full_range_uhat20.csv"
data = read_csv(file) %>% arrange(a)
nparams = length(unique(data$a)) # 146; 4 missing


# Group by common values of a
nreps = 50
starts = seq(1, nrow(data), by = nreps)
nparams = length(starts)
a_vector = rep(-1,nparams)
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
  k_vector[i] = rows$k[1]
  u_hat_vector[i] = rows$u_hat[1]
  delta_vector[i] = rows$delta[1]
  
  # calculate the proportion of times that the drive increased
  p_increase_vector[i] = mean(rows$outcome == "increase")
  
}

# Compile summary tibble
summarize_data = tibble(a = a_vector, sigma = sigma_vector, 
                        k = k_vector, u_hat = u_hat_vector, delta = delta_vector,
                        p_increase = p_increase_vector)

# Write out 
write_csv(x = summarize_data, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/csvs/bug_fixed_second_run_full_range_uhat20_WEIRD_SUMMARY.csv")


source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/plotting_functions.R")
data = summarize_data
obs_vs_pred = get_a_pred_and_a_obs(data)
a_prop = obs_vs_pred$a_pred
delta_min = obs_vs_pred$delta_pred
a_obs = obs_vs_pred$a_obs
delta_obs = obs_vs_pred$delta_obs
p_increase_obs = obs_vs_pred$p_increase_obs

summarize_data = data
# Plot p(increase) as a function of a
plot_freqs_and_a = ggplot(summarize_data, aes(x = a, y = p_increase)) + 
  geom_point(color = "red") + 
  geom_line(color = "grey") +
  geom_vline(xintercept = a_prop) + 
  ylab("P(increase)") + 
  labs(title = paste0("sigma =",summarize_data$sigma[1], 
                      "  k=",summarize_data$k[1],"  u_hat=", summarize_data$u_hat[1],
                      "  nreps = ", nreps), 
       subtitle = paste0("a* = ", round(a_prop,4), " (delta* = ", round(delta_min,4),") but a_obs =",round(a_obs,4)," (delta_obs =", round(delta_obs,4),")")) +
  ylim(0,1)

# Add line at a of pincrease of 0.5
p = plot_freqs_and_a + geom_vline(xintercept = a_obs, color = "cornsilk3")

dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/figures/"

plot_path = paste0(dir,"second_run_WEIRD_OFF.png")
ggsave(filename = plot_path, plot = p)

# Zoom in
plot_zoom = plot_freqs_and_a + xlim(0.005, a_prop)
plot_path = paste0(dir, "zoomed_in_uhat_5_sigma0.01_k_0.2.png")
ggsave(filename = plot_path, plot = plot_zoom)

# Add to the range by assuming all a > max(a here) produces p(increase) of 1
more_a = seq(0.025, 1.0, by = 0.025)
n = length(more_a)
sigma_vec = rep(0.01,n)
k_vec = rep(0.2, n)
u_hat_vec = rep(0.05, n)
p_increase = rep(1,n)
delta_vec = rep(-1,n)
beta_vec = rep(-1,n)
k = 0.2
sigma = 0.01
u_hat = 0.05
for (i in 1:n){
  a = more_a[i]
  beta = a/0.01
  delta = check_for_delta_0_when_b_is_1(u_hat, beta, sigma, k)
  beta_vec[i] = beta
  delta_vec[i] = delta
}
more_tibble = tibble(a = more_a, sigma = sigma_vec, beta = beta_vec, k = k_vec, u_hat = u_hat_vec, delta = delta_vec, p_increase = p_increase)
expanded_tibble = rbind(summarize_data, more_tibble)

exp_plot = ggplot(expanded_tibble, aes(x = a, y = p_increase)) + 
  geom_point(color = "red") + 
  geom_line(color = "grey") +
  geom_vline(xintercept = a_prop) + 
  ylab("P(increase)") + 
  labs(title = paste0("sigma =",summarize_data$sigma[1], 
                      "  k=",summarize_data$k[1],"  u_hat=", summarize_data$u_hat[1],
                      "  nreps = ", nreps), 
       subtitle = paste0("a* = ", round(a_prop,4), " (delta* = ", round(delta_min,4),") but a_obs =",round(a_obs,4)," (delta_obs =", round(delta_obs,4),")")) +
  xlim(0, 0.1)
plot_path = paste0(dir, "zoomed_out_uhat_5_sigma0.01_k_0.2.png")
ggsave(filename = plot_path, plot = exp_plot)
