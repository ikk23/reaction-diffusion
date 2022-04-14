'''
This script will parse the slim output and create a csv of (generation) and (number of drive alleles)

pass the path to the text file with the SLiM output as an argument, and pipe the output to a csv

ex: python num_drives_and_gen.py output.txt > output.csv
'''
import numpy as np
import sys

def parse_slim(slim_string):
    """
    Goes through each line of the SLiM output and retrieves the generation (minus 10) and the number of
    drive alleles. Prints these, in a csv format, to the screen.
    
    Arguments: 
        1. slim output to parse [string]

    Returns:
        No returns, just prints output. 
    """
    
    line_split = slim_string.split('\n')

    for line in line_split:
        if line.startswith("GEN::"):
          spaced_line = line.split()
          gen = int(spaced_line[1])
          gen_adjust = gen - 10
          ndrives = float(spaced_line[7])
          csv_line = "{},{}".format(gen_adjust,ndrives)
          print(csv_line)
    return

def main():
  '''
  Runs parse_slim() on the string located in output.txt and prints results to the screen.
  '''
  
  text_file = sys.argv[1]

  with open(text_file,"r") as f:
    slim_string = f.read()
  
  print(f"gen,num_drive_alleles") 
  parse_slim(slim_string) # this will print each line to the screen
  
    
if __name__ == "__main__":
    main()
