'''
This script will sort through each line of the SLiM output and print out the 
generation and popsize in a csv specified after the pipe.

Be sure to copy and paste the SLiM output into a text file 
and then specify the path to this text file as an argument to the script


ex: python check_N.py path-to-output-txt-file > path-to-output-csv
'''
import numpy as np
import sys


def parse_slim(slim_string):
    """
    Arguments: 
        1. slim output to parse [string]

    Returns:
      No returns, only will print a generation, popsize line for each generation.
    """
      
    line_split = slim_string.split('\n')
    
    print(f"generation, N")
    gens = []
    popsizes = []
    for line in line_split:
        if line.startswith("Generation:"):
            spaced_line = line.split()
            gen = int(spaced_line[1])
            N = int(spaced_line[3])
            csv_line = "{},{}".format(gen,N)
            print(csv_line)
        
    return



def main():
  '''
  Runs parse_slim() on the string located in output.txt
  
  Call this python script with check_N.py > output.csv
  '''
  output_txt = sys.argv[1]
  
  with open(output_txt,"r") as f:
    slim_string = f.read()
  
  parse_slim(slim_string)
  
  
if __name__ == "__main__":
    main()
