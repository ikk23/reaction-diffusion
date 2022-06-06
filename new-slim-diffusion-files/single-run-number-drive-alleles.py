'''
Pass in the path to the output text file. Pipe the output of this to a csv.

ex: python parse_slim_output.py output_a0.08_replicate1.txt > output_a0.08_replicate1.csv
'''
import sys

def parse_slim(slim_string):
    """
    Arguments: 
        1. slim output to parse [string]

    Returns:
      -The csv line will be 7 columns:
        gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles
 
    """
    line_split = slim_string.split('\n')

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
  '''
  Runs parse_slim() on the string located in the output text file and prints results to the screen.
  '''

  with open(sys.argv[1],"r") as f:
    slim_string = f.read()
  
  # 7 column header
  # gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles

  print(f"gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles")
  
  parse_slim(slim_string)
  
    
if __name__ == "__main__":
    main()
