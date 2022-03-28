library(tidyverse)

# Arrange rows by increasing values of a
data = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/a_trials_default_values.csv") %>% 
  select(a, ultimate_outcome) %>% 
  arrange(a)
View(data)

# Group by value of a and get the frequency of "increase"
freq_data = data %>%
  group_by(a) %>%
  summarize(p_increase = mean(ultimate_outcome == "increase"))

# Plot
plot(freq_data$a, freq_data$p_increase, type = "p", col = "red", xlab = "a", ylab = "freq(increase)")
abline(v = 0.073241)

# ggplot
plot_freqs = ggplot(freq_data, aes(x = a, y = p_increase)) + geom_point(color = "red") + geom_vline(xintercept = 0.073241) + ylab("freq(increase)") + labs(title = "sigma = 0.05, k = 0.2, u_hat = 0.2", subtitle = "5 replicates per a value")
plot_freqs
ggsave(plot = plot_freqs, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/a_value_p_increase_defaults.png")


# Get the beta values and the delta (AUC1 - AUC2) values for each of these a's
source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/scripts/functions-main-model.R")
a_vals = freq_data$a
sigma = 0.05
u_hat = 0.2
k  = 0.2
betas = a_vals/sigma
deltas = check_for_delta_0_when_b_is_1(0.2, betas)
freq_data_and_delta = freq_data %>% add_column(beta = betas, delta = deltas)
View(freq_data_and_delta)

delta_plot = ggplot(freq_data_and_delta, aes(x = a, y = delta)) + geom_point(color = "blue") + xlab("a") + ylab("AUC1 - a*b") +  labs(title = "sigma = 0.05, k = 0.2, u_hat = 0.2", subtitle = "5 replicates per a value") + geom_hline(yintercept = 0.001273019)
delta_plot
ggsave(plot = delta_plot, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/a_vs_delta_default_values.png")
