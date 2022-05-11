from argparse import ArgumentParser
from slimutil import run_slim, configure_slim_command_line

# For a given value of a, run SLiM nreps times and track u'(x1), u'(x2), u'(x3), u(x1), u(x2), and u(x3)

# Make sure slimutil.py is also transferred to this cluster directory

def parse_slim(slim_string):
    """
    Arguments: 
        1. slim output to parse [string]

    Returns:
        No returns. Just prints out the line-by-line simulation results to a csv file.
    """
    line_split = slim_string.split('\n')
    
    for line in line_split:
        if line.startswith("UPRIME_X1::"):
          spaced_line = line.split()
          uprime_x1 = float(spaced_line[1])
        elif line.startswith("UPRIME_X2::"):
          spaced_line = line.split()
          uprime_x2 = float(spaced_line[1])
        elif line.startswith("UPRIME_X3::"):
          spaced_line = line.split()
          uprime_x3 = float(spaced_line[1])
        elif line.startswith("U_X1::"):
          spaced_line = line.split()
          u_x1 = float(spaced_line[1])
        elif line.startswith("U_X2::"):
          spaced_line = line.split()
          u_x2 = float(spaced_line[1])
        elif line.startswith("U_X3::"):
          spaced_line = line.split()
          u_x3 = float(spaced_line[1])
          
    csv_line = "{},{},{},{},{},{}".format(uprime_x1, uprime_x2, uprime_x3, u_x1, u_x2, u_x3)
    print(csv_line)
          
    return 

  
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
    parser.add_argument('-a', '--a', default=0.02, type=float,help="release width")
    parser.add_argument('-header', '--print_header', action='store_true', default=False,
                        help='If this is set, python prints a header for a csv file.')
    parser.add_argument('-sigma', '--sigma', default=0.01, type=float,help="average dispersal distance")
    parser.add_argument('-nreps', '--num_repeats', type=int, default=20,help="number of replicates")
    parser.add_argument('-k', '--k', default=0.2, type=float,help="selection coefficient")
    parser.add_argument('-u_hat', '--u_hat', default=0.4, type=float,help="threshold frequency")
    
    args_dict = vars(parser.parse_args())
    sim_reps = args_dict.pop("num_repeats")
    
    if args_dict.pop("print_header", None):
      print(f"u'(x=0.47), u'(x=0.5), u'(x=0.54), u(x=0.47), u(x=0.5), u(x=0.54)") # 9 columns

    # Assemble the command line arguments to use for SLiM:
    clargs = configure_slim_command_line(args_dict)
    # ex: ['slim', '-d', 'a=0.25', '-d', 'sigma=0.05', '-d', 'num_repeats=10', '-d', 'k=0.2', '-d', 'u_hat=0.2', 'nonWF-model.slim']
    
    # Run the file with the desired arguments.
    for i in range(sim_reps):
        slim_result = run_slim(clargs)
        # This function will print the parsed result
        parse_slim(slim_result)
        
if __name__ == "__main__":
    main()
        
