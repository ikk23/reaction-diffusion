from argparse import ArgumentParser
from slimutil import run_slim, configure_slim_command_line

# For a given value of a, run SLiM nreps times and tracks the generation, population size, 
# number of homozygotes, number of heterozygotes, number of wild-types, number of 
# drive alleles, and rate of drive alleles for each generation.

# Make sure slimutil.py is also transferred to this cluster directory

# Function to parse the SLiM output and print out generation-by-generation results
def parse_slim(slim_string):
    """
    Arguments: 
        1. slim output to parse [string]

    Returns:
        Nothing; just prints out output
    """
    line_split = slim_string.split('\n')
    drive_rates = []

    for line in line_split:
        if line.startswith("GEN::"):
          spaced_line = line.split()
          gen = int(spaced_line[1])-10
          popsize = int(spaced_line[3])
          num_dd = int(spaced_line[5])
          num_dwt = int(spaced_line[7])
          num_wtwt = int(spaced_line[9])
          num_d_alleles = int(spaced_line[11])
          rate_d_alleles = float(spaced_line[13])
          csv_line = "{},{},{},{},{},{},{}".format(gen,popsize,num_dd,num_dwt,num_wtwt,num_d_alleles,rate_d_alleles)
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
    parser.add_argument('-src', '--source', default="nonWF-diffusion-model.slim", type=str,help="SLiM file to be run.")
    parser.add_argument('-header', '--print_header', action='store_true', default=False,
                        help='If this is set, python prints a header for a csv file.')
    parser.add_argument('-nreps', '--num_repeats', type=int, default=20,help="number of replicates")
    parser.add_argument('-m', '--DRIVE_DROP_SIZE', default=1000, type=int,help="the drive drop size")

    args_dict = vars(parser.parse_args())
    sim_reps = args_dict.pop("num_repeats")
    m = args_dict["DRIVE_DROP_SIZE"]
    
    print(f"gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles")

    # Assemble the command line arguments to use for SLiM:
    clargs = configure_slim_command_line(args_dict)
    
    # Run the file with the desired arguments.
    for i in range(sim_reps):
        slim_result = run_slim(clargs)
        parse_slim(slim_result) # this will print out generation-by-generation output
        

if __name__ == "__main__":
    main()
