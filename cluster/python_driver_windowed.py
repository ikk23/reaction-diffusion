from argparse import ArgumentParser
from slimutil import run_slim, configure_slim_command_line

# For a given value of a, run SLiM nreps times and tracks the overall number of drive alleles, overall rate
# of the drive, the windowed number of drive alleles, the windowed number of drive homozygotes, and 
# the windowed number of drive heterozygotes.

# Make sure slimutil.py is also transferred to this cluster directory

def parse_slim(slim_string, a, replicate_number):
    """
    Arguments: 
        1. slim output to parse [string]
        2. The value of a -- this will be printed out as well
        3. Replicate number -- this will be printed out as well

    Returns:
        No returns. Just prints out the line-by-line simulation results to a csv file.
    """
    line_split = slim_string.split('\n')
    
    for line in line_split:
        if line.startswith("GEN::"):
          spaced_line = line.split()
          gen = int(spaced_line[1]) - 10

          overall_drives = int(spaced_line[5])

          overall_dr_rate = float(spaced_line[7])

          drives_in_window = int(spaced_line[9])

          dd_in_window = int(spaced_line[11])

          dwt_in_window = int(spaced_line[13])
          
          csv_line = "{},{},{},{},{},{},{},{}".format(a,replicate_number,gen,overall_drives,overall_dr_rate,drives_in_window,dd_in_window,dwt_in_window)
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
    parser.add_argument('-a', '--a', default=0.25, type=float,help="release width")
    parser.add_argument('-header', '--print_header', action='store_true', default=False,
                        help='If this is set, python prints a header for a csv file.')
    parser.add_argument('-sigma', '--sigma', default=0.01, type=float,help="average dispersal distance")
    parser.add_argument('-nreps', '--num_repeats', type=int, default=50,help="number of replicates")
    parser.add_argument('-k', '--k', default=0.2, type=float,help="selection coefficient")
    parser.add_argument('-u_hat', '--u_hat', default=0.4, type=float,help="threshold frequency")
    
    args_dict = vars(parser.parse_args())
    sim_reps = args_dict.pop("num_repeats")
    
    if args_dict.pop("print_header", None):
      print(f"a,replicate,gen,overall_d_count, overall_d_rate, windowed_d_count, windowed_dd_count, windowed_dwt_count") # 8 columns

    # Assemble the command line arguments to use for SLiM:
    clargs = configure_slim_command_line(args_dict)
    # ex: ['slim', '-d', 'a=0.25', '-d', 'sigma=0.05', '-d', 'num_repeats=10', '-d', 'k=0.2', '-d', 'u_hat=0.2', 'nonWF-model.slim']
    a = args_dict["a"]
    sigma = args_dict["sigma"]
    k = args_dict["k"]
    u_hat = args_dict["u_hat"]
    
    # Run the file with the desired arguments.
    for i in range(sim_reps):
        slim_result = run_slim(clargs)
        # This function will print the generation-by-generation results out to a csv
        parse_slim(slim_result,a,i) # i = replicate
        
if __name__ == "__main__":
    main()
