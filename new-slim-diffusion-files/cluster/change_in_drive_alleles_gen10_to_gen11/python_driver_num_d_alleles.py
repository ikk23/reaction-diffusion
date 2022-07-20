from argparse import ArgumentParser
from slimutil import run_slim, configure_slim_command_line

# For a certain parameter set, run SLiM 20 times and prints out 
# the DRIVE_DROP_SIZE (m) and the change in the number of drive alleles from generation 10 to 11

# Make sure slimutil.py is also transferred to this cluster directory

# Function to parse the SLiM output to obtain the change in number of drive alleles
def parse_slim(slim_string):
    """
    Arguments: 
        1. slim output to parse [string]

    Returns:
        1. (number of drive alleles in generation 11) - (number of drive alleles in generation 10)
    """
    line_split = slim_string.split('\n')
    drive_number = []

    for line in line_split:
        if line.startswith("GEN::"):
          spaced_line = line.split()
          ndrives = float(spaced_line[11])
          drive_number.append(ndrives)
    
    drives_gen10 = drive_number[0]
    drives_gen11 = drive_number[1]
    
    difference = drives_gen11 - drives_gen10

    return (difference)

  
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
    
    # no header
    #print(f"m,change")

    # Assemble the command line arguments to use for SLiM:
    clargs = configure_slim_command_line(args_dict)
    m = args_dict["DRIVE_DROP_SIZE"]

    
    # Run the file with the desired arguments.
    for i in range(sim_reps):
        slim_result = run_slim(clargs)
        change = parse_slim(slim_result)
        csv_line = "{},{}".format(m,change)
        print(csv_line)
        

if __name__ == "__main__":
    main()
