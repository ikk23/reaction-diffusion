library(tidyverse)
source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/scripts/functions-main-model.R")

# PATH TO THE RAW CLUSTER OUTPUT
file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.15_run/csv_raw/uhat15_april12_full_a_run.csv"
data = read_csv(file) %>% arrange(a)
nparams = length(unique(data$a)) # 150


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
summarize_data$p_increase[150]=1.0

# Write out 
write_csv(x = summarize_data, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.15_run/csvs/summary_april13_full_range_uhat15.csv")


source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/plotting_functions.R")
data = summarize_data
obs_vs_pred = get_a_pred_and_a_obs(data)
a_prop = 0.006154545
delta_min = -0.000017000
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

dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.15_run/figures/"

# Add line at a of pincrease of 0.5
p = plot_freqs_and_a + geom_vline(xintercept = a_obs, color = "cornsilk3") 
ggsave(filename = paste0(dir,"april13_full_a_vs_p_increase_uhat15.png"),plot=p)

p2 = p + xlim(0,0.1)
ggsave(filename = paste0(dir,"april13_zoomed_in_a_vs_p_increase_uhat15.png"), plot = p2)

# Delta plot
plot_a_vs_delta = ggplot(summarize_data, aes(x = a, y = delta)) + 
  geom_point(color = "purple") + 
  geom_line(color = "grey") +
  geom_vline(xintercept = a_prop) + 
  ylab("delta") + 
  labs(title = paste0("sigma =",summarize_data$sigma[1], 
                      "  k=",summarize_data$k[1],"  u_hat=", summarize_data$u_hat[1]), 
       subtitle = paste0("a* = ", round(a_prop,4), " (delta* = ", round(delta_min,4),") but a_obs =",round(a_obs,4)," (delta_obs =", round(delta_obs,4),")")) +
  geom_vline(xintercept = a_obs, color = "cornsilk3") + geom_hline(yintercept = 0)


ggsave(filename = paste0(dir,"april13_full_a_vs_delta_uhat15.png"),plot=plot_a_vs_delta)

# zoom in
p = plot_a_vs_delta + xlim(0,0.1)

# based on this graph, a_prop should be 0.006154545

ggsave(filename = paste0(dir,"april13_zoomed_in_a_vs_delta_uhat15.png"),plot=p)




# Delta vs P(increase)
#summarize_data = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.05_run/csvs/summary_april11_full_range_uhat5.csv")
#summarize_data$p_increase[150] = 1.0

delta_vs_p_increase = ggplot(summarize_data, aes(x = delta, y = p_increase)) + 
  geom_point(color = "blue") + 
  geom_line(color = "grey") +
  geom_vline(xintercept = delta_min) + 
  xlab("delta") + 
  ylab("P(increase)") +
  labs(title = paste0("sigma =",summarize_data$sigma[1], 
                      "  k=",summarize_data$k[1],"  u_hat=", summarize_data$u_hat[1]), 
       subtitle = paste0("a* = ", round(a_prop,4), " (delta* = ", round(delta_min,4),") but a_obs =",round(a_obs,4)," (delta_obs =", round(delta_obs,4),")")) +
  geom_vline(xintercept = delta_obs, color = "cornsilk3")

ggsave(filename=paste0(dir,"april13_delta_vs_p_increase_uhat15.png"),plot = delta_vs_p_increase)

