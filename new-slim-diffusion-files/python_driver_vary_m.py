from argparse import ArgumentParser
from slimutil import run_slim, configure_slim_command_line
import numpy as np

# For a certain parameter set, run SLiM nreps number of times and print out {drop_size, outcome}
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
          gen = int(spaced_line[1])-10
          if (gen == 0):
            initial_drive_rate = float(spaced_line[13])
          elif (gen == 100):
            last_drive_rate = float(spaced_line[13])
    
    # This can also occur when both are 0.0 (when a is very low)
    if initial_drive_rate >= last_drive_rate:
      outcome = "decrease"
    else:
      outcome = "increase"
    
    # Correct for when drives fix upon release (at a=1)
    if last_drive_rate == 1:
      outcome = "increase"

    return (outcome)

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
    parser.add_argument('-src', '--source', default="nonWF-diffusion-model.slim", type=str,help="SLiM file to be run.")
    parser.add_argument('-header', '--print_header', action='store_true', default=False,
                        help='If this is set, python prints a header for a csv file.')
    parser.add_argument('-nreps', '--num_repeats', type=int, default=20,help="number of replicates")
    parser.add_argument('-m', '--DRIVE_DROP_SIZE', default=1000, type=int,help="the drive drop size")

    args_dict = vars(parser.parse_args())
    sim_reps = args_dict.pop("num_repeats")
    m = args_dict["DRIVE_DROP_SIZE"]
    
    if args_dict.pop("print_header", None):
      print(f"drop_size, outcome") # 5 columns: a,sigma,k,u_hat,outcome

    # Assemble the command line arguments to use for SLiM:
    clargs = configure_slim_command_line(args_dict)
    
    # Run the file with the desired arguments.
    for i in range(sim_reps):
        slim_result = run_slim(clargs)
        outcome = parse_slim(slim_result)
        csv_line = "{},{}".format(m,outcome)
        print(csv_line)
        

if __name__ == "__main__":
    main()
        

