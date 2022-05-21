from argparse import ArgumentParser
from slimutil import run_slim, configure_slim_command_line

# For a given value of a, run SLiM nreps times and track 
# the number of homozygotes, heterozygotes, drive allele fitness, and number of drive alleles over time

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
          gen = int(spaced_line[1]) - 11 # 11 is the new start gen; should be 0
          num_dd = int(spaced_line[3])
          num_dwt = int(spaced_line[5])
          d_fitness = float(spaced_line[7])
          n_d_alleles = int(spaced_line[9])
          popsize = int(spaced_line[11])
          csv_line = "{},{},{},{},{},{},{},{}".format(a,replicate_number,gen,num_dd, num_dwt,n_d_alleles,d_fitness, popsize)
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
    parser.add_argument('-src', '--source', default="nonWF-model-drive-homozygotes.slim", type=str,help="SLiM file to be run.")
    parser.add_argument('-a', '--a', default=0.25, type=float,help="release width")
    parser.add_argument('-header', '--print_header', action='store_true', default=False,
                        help='If this is set, python prints a header for a csv file.')
    parser.add_argument('-sigma', '--sigma', default=0.01, type=float,help="average dispersal distance")
    parser.add_argument('-nreps', '--num_repeats', type=int, default=20,help="number of replicates")
    parser.add_argument('-k', '--k', default=0.2, type=float,help="selection coefficient")
    parser.add_argument('-u_hat', '--u_hat', default=0.4, type=float,help="threshold frequency")
    
    args_dict = vars(parser.parse_args())
    sim_reps = args_dict.pop("num_repeats")
    
    print(f"a,replicate,gen,num_dd, num_dwt,num_d_alleles,d_fitness, popsize") # 8 columns

    # Assemble the command line arguments to use for SLiM:
    clargs = configure_slim_command_line(args_dict)
    # ex: ['slim', '-d', 'a=0.25', '-d', 'sigma=0.05', '-d', 'num_repeats=10', '-d', 'k=0.2', '-d', 'u_hat=0.2', 'nonWF-model.slim']
    a = args_dict["a"]
    
    # Run the file with the desired arguments.
    for i in range(sim_reps):
        slim_result = run_slim(clargs)
        # This function will print the generation-by-generation results out to a csv
        parse_slim(slim_result,a,i) # i = replicate
        
if __name__ == "__main__":
    main()
