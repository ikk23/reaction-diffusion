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
      -The csv line will be 10 columns:
        x1, x2, x_midpoint,time_point,n_dd, n_dwt, n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wt
        
      -time_point is either "after_dispersal", "after_reproduction", or "after_viability"
 
    """
    line_split = slim_string.split('\n')
    
    # x1, x2, x_midpoint,time_point,n_dd, n_dwt, n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wt
    for line in line_split:
      if line.startswith("GEN10_after_dispersal::"):
        spaced_line = line.split()
        time_point = "after_dispersal"
        x1 = float(spaced_line[2])
        x2 = float(spaced_line[4])
        x_midpoint = float(spaced_line[6])
        n_dd = float(spaced_line[8])
        exp_n_dd = float(spaced_line[10])
        n_dwt = float(spaced_line[12])
        exp_n_dwt = float(spaced_line[14])
        n_wtwt = float(spaced_line[16])
        exp_n_wtwt = float(spaced_line[18])
        
        csv_line = "{},{},{},{},{},{},{},{},{},{}".format(x1,x2,x_midpoint,time_point,n_dd,n_dwt,n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wtwt)
        print(csv_line)
        
      elif line.startswith("GEN11_after_reproduction::"):
        spaced_line = line.split()
        time_point = "after_reproduction"
        x1 = float(spaced_line[2])
        x2 = float(spaced_line[4])
        x_midpoint = float(spaced_line[6])
        n_dd = float(spaced_line[8])
        exp_n_dd = float(spaced_line[10])
        n_dwt = float(spaced_line[12])
        exp_n_dwt = float(spaced_line[14])
        n_wtwt = float(spaced_line[16])
        exp_n_wtwt = float(spaced_line[18])
        
        csv_line = "{},{},{},{},{},{},{},{},{},{}".format(x1,x2,x_midpoint,time_point,n_dd,n_dwt,n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wtwt)
        print(csv_line)
        
      elif line.startswith("GEN11_after_viability::"):
        spaced_line = line.split()
        time_point = "after_viability"
        x1 = float(spaced_line[2])
        x2 = float(spaced_line[4])
        x_midpoint = float(spaced_line[6])
        n_dd = float(spaced_line[8])
        exp_n_dd = float(spaced_line[10])
        n_dwt = float(spaced_line[12])
        exp_n_dwt = float(spaced_line[14])
        n_wtwt = float(spaced_line[16])
        exp_n_wtwt = float(spaced_line[18])
        
        csv_line = "{},{},{},{},{},{},{},{},{},{}".format(x1,x2,x_midpoint,time_point,n_dd,n_dwt,n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wtwt)
        print(csv_line)    
        
    return


def main():
  '''
  Runs parse_slim() on the string located in the output text file and prints results to the screen.
  '''

  with open(sys.argv[1],"r") as f:
    slim_string = f.read()
  
  # 10 column header
  print(f"x1, x2, x_midpoint,time_point,n_dd, n_dwt, n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wt")
  
  parse_slim(slim_string)
  
    
if __name__ == "__main__":
    main()
