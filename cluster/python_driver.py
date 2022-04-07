from argparse import ArgumentParser
from slimutil import run_slim, configure_slim_command_line
import numpy as np

# For a certain parameter set, run SLiM nreps number of times and print out a, sigma, k, u_hat, outcome 
# where the outcome is either 'increase' or 'decrease' for each replicate

# Make sure slimutil.py is also transferred to this cluster directory

# Function to parse the SLiM output to see whether the drive increased or decreased
def parse_slim(slim_string):
    """
    Arguments: 
        1. slim output to parse [string]

    Returns:
        1. "increase" if the drive frequency increased from its initial frequency or "decrease" if not
    """
    line_split = slim_string.split('\n')
    drive_rates = []

    for line in line_split:
        if line.startswith("GEN::"):
          spaced_line = line.split()
          drive_freq = float(spaced_line[5])
          drive_rates.append(drive_freq)
    
    initial_drive_rate = drive_rates[0]
    last_drive_rate = drive_rates[-1]
    
    if initial_drive_rate > last_drive_rate:
      outcome = "decrease"
    else:
      outcome = "increase"

    return (outcome)

def auc(a,b,sigma,k,u_hat):
  '''
  Finds the area under the curve after 1 time step
  
  Arguments:
    a = width of the drive release
    b = the local frequency of the drive where it's released (usually 1)
    sigma = the average dispersal distance using an Exponential dispersal kernel
    k = the selection coefficient
    u_hat = the frequency threshold
  
  Returns:
    theta1 = the AUC after 1 time-step
  '''
  orange = (((3*sigma*(b**2)*k)/2)*((3*b) - (2*u_hat) - 2)) - (2*a*b*k*(b-1)*(b-u_hat)) + (a*b)
  pink_inner = (sigma*b*((3*u_hat) - (4*b) + 3)) - (a*((3*b) - u_hat - 1))
  pink = (b*k*pink_inner)*np.exp(-a/sigma)
  blue = (-sigma*(b**3)*k/2)*np.exp(-2*a/sigma)
  
  theta1 = orange + pink + blue
  
  return (theta1)


def delta_function(a,b,sigma,k,u_hat):
  '''
  Finds the difference in AUC after 1 time-step; ie delta = theta1 - (ab)
  
  Arguments:
    a = width of the drive release
    b = the local frequency of the drive where it's released (usually 1)
    sigma = the average dispersal distance using an Exponential dispersal kernel
    k = the selection coefficient
    u_hat = the frequency threshold
  
  Returns:
    delta = the change in AUC after 1 time-step
  '''
  delta = auc(a,b,sigma,k,u_hat) - (a*b)
  
  return (delta)
  
  
def main():
    """
    1. Configure using argparse.
    2. Generate cl string and run SLiM.
    3. Parse the output of SLiM.
    4. Print the results.
    """
    # Get args from arg parser:
    # Command line example:    python python_driver.py -a 0.1
    parser = ArgumentParser()
    parser.add_argument('-src', '--source', default="nonWF-model.slim", type=str,help="SLiM file to be run.")
    parser.add_argument('-a', '--a', default=0.25, type=float,help="release width")
    parser.add_argument('-header', '--print_header', action='store_true', default=False,
                        help='If this is set, python prints a header for a csv file.')
    parser.add_argument('-sigma', '--sigma', default=0.01, type=float,help="average dispersal distance")
    parser.add_argument('-nreps', '--num_repeats', type=int, default=50,help="number of replicates")
    parser.add_argument('-k', '--k', default=0.2, type=float,help="selection coefficient")
    parser.add_argument('-u_hat', '--u_hat', default=0.2, type=float,help="threshold frequency")
    
    args_dict = vars(parser.parse_args())
    sim_reps = args_dict.pop("num_repeats")
    
    if args_dict.pop("print_header", None):
      print(f"a,sigma,k,u_hat,delta,outcome") # 5 columns: a,sigma,k,u_hat,outcome

    # Assemble the command line arguments to use for SLiM:
    clargs = configure_slim_command_line(args_dict)
    # ex: ['slim', '-d', 'a=0.25', '-d', 'sigma=0.05', '-d', 'num_repeats=10', '-d', 'k=0.2', '-d', 'u_hat=0.2', 'nonWF-model.slim']
    a = args_dict["a"]
    sigma = args_dict["sigma"]
    k = args_dict["k"]
    u_hat = args_dict["u_hat"]
    
    beta = a/sigma
    delta = delta_function(a,1,sigma,k,u_hat)
    
    # Run the file with the desired arguments.
    for i in range(sim_reps):
        slim_result = run_slim(clargs)
        outcome = parse_slim(slim_result)
        csv_line = "{},{},{},{},{},{}".format(a,sigma,k,u_hat,delta,outcome)
        print(csv_line)
        

if __name__ == "__main__":
    main()
        
