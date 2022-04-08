get_a_pred_and_a_obs = function(data){
  # data is a summary file with 8 columns (add the correct delta): a, sigma, beta, k, u_hat, delta, p_increase,delta_correct
  
  # get the row number of the lowest value of delta_correct use this to find a_pred and delta_pred
  ind_pred = which.min(abs(data$delta))
  min_row = data[ind_pred,] 
  a_prop = min_row$a
  delta_min = min_row$delta
  
  # find which value of a gives a p(increase) closest to 50%
  diff = abs(data$p_increase - 0.5)
  ind_obs = which.min(diff)
  a_obs = data$a[ind_obs]
  delta_obs = data$delta[ind_obs]
  p_increase_obs = data$p_increase[ind_obs]
  
  results = list(index_of_pred = ind_pred,
                 a_pred = a_prop,
                 delta_pred = delta_min,
                 index_of_obs = ind_obs,
                 a_obs = a_obs,
                 p_increase_obs = p_increase_obs,
                 delta_obs = delta_obs)
  return(results)
  
}