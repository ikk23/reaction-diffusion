from argparse import ArgumentParser
from slimutil import run_slim, configure_slim_command_line

# For a certain parameter set, run SLiM 20 times and prints out the value of m, replicate number, initial change, and outcome

# Make sure slimutil.py is also transferred to this cluster directory

# Function to parse the SLiM output to obtain the change in number of drive alleles
def parse_slim(slim_string, m, replicate):
    """
    Arguments: 
        1. slim output to parse [string]
        2. m = the drive drop size
        3. replicate = the replicate number

    Returns:
        Prints out m, replicate number, and outcome
    """
    line_split = slim_string.split('\n')
    ndrive_alleles_vector = []

    for line in line_split:
        if line.startswith("GEN::"):
          spaced_line = line.split()
          ndrives = int(spaced_line[11])
          ndrive_alleles_vector.append(ndrives)
    
    start = ndrive_alleles_vector[0]
    end = ndrive_alleles_vector[-1]
    if (start > end):
      outcome = "decrease"
    elif (start < end):
      outcome = "increase"
    else:
      outcome = "constant"
    
    initial_change = ndrive_alleles_vector[1]-ndrive_alleles_vector[0]
          
    csv_line = "{},{},{},{}".format(m,replicate,initial_change,outcome)
    print(csv_line)

  
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
    parser.add_argument('-nreps', '--num_repeats', type=int, default=20,help="number of replicates")
    parser.add_argument('-DRIVE_DROP_SIZE', '--DRIVE_DROP_SIZE', default=1000, type=int,help="drive drop size")
    
    args_dict = vars(parser.parse_args())
    sim_reps = args_dict.pop("num_repeats")

    # Assemble the command line arguments to use for SLiM:
    clargs = configure_slim_command_line(args_dict)
    m = args_dict["DRIVE_DROP_SIZE"]


    print(f"m, replicate_number,gen10_to_gen11_change,outcome_after_100_gens") # 4 columns
    for i in range(sim_reps):
        slim_result = run_slim(clargs)
        parse_slim(slim_result,m,i)
        
        
if __name__ == "__main__":
    main()
