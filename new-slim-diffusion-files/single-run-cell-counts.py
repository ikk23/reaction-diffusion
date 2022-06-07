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
      -The csv line will be 13 columns:
        gen, N_total,constant_expectation,cell1_count, cell2_count, cell3_count, cell4_count, cell5_count, cell6_count, cell7_count, cell8_count, cell9_count, cell10_count
 
    """
    line_split = slim_string.split('\n')
    
    # output:
    # CELL1:: 2310 CELL2:: 2358 CELL3:: 2323 CELL4:: 2389 CELL5:: 2753 CELL6:: 2679 CELL7:: 2509 CELL8:: 2368 CELL9:: 2340 CELL10:: 2219 GENERATION:: 17
    for line in line_split:
      if line.startswith("CELL1::"):
        spaced_line = line.split()
        cell1 = int(spaced_line[1])
        cell2 = int(spaced_line[3])
        cell3 = int(spaced_line[5])
        cell4 = int(spaced_line[7])
        cell5 = int(spaced_line[9])
        cell6 = int(spaced_line[11])
        cell7 = int(spaced_line[13])
        cell8 = int(spaced_line[15])
        cell9 = int(spaced_line[17])
        cell10 = int(spaced_line[19])
        gen = int(spaced_line[21]) - 10
        N_total = cell1 + cell2 + cell3 + cell4 + cell5 + cell6 + cell7 + cell8 + cell9 + cell10
        constant_expectation = N_total/10 # if density were completely constant
        
        csv_line = "{},{},{},{},{},{},{},{},{},{},{},{},{}".format(gen, N_total, constant_expectation, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10)
        print(csv_line)
        
    return


def main():
  '''
  Runs parse_slim() on the string located in the output text file and prints results to the screen.
  '''

  with open(sys.argv[1],"r") as f:
    slim_string = f.read()
  
  # 13 columns

  print(f"gen, N_total,constant_expectation,cell1_count, cell2_count, cell3_count, cell4_count, cell5_count, cell6_count, cell7_count, cell8_count, cell9_count, cell10_count")
  
  parse_slim(slim_string)
  
    
if __name__ == "__main__":
    main()
