'''
Pass in the value of a, replicate number, and path to the output text file. Pipe the output of this to a csv.

ex: python parse_slim_output.py 0.08 1 output_a0.08_replicate1.txt > output_a0.08_replicate1.csv
'''
import sys

def parse_slim(slim_string, a, replicate_number):
    """
    Arguments: 
        1. slim output to parse [string]
        2. the value of a used in this run
        3. the replicate number for this value of a

    Returns:
      -Prints out a csv line for each generation and each x-value (assumes xs are X1,X2,X3)
      -The csv line will be 12 columns:
        a, replicate_number, x, gen-10, d_freq, exp_d_freq, dd_freq, exp_dd_freq, dwt_freq, exp_dwt_freq, wtwt_freq, exp_wtwt_freq
 
    """
    line_split = slim_string.split('\n')

    for line in line_split:
      # ex: X1:: 0.47 GEN:: 11 obs_drive_freq:: 0.942308 predicted_viability_drive_freq:: 0.0 obs_freq(DD):: 0.884615 viability_exp_freq(DD):: 0.0 obs_freq(DWT):: 0.115385 viability_exp_freq(DWT):: 0.0 obs_freq(WT):: 0.0 viability_exp_freq(WT):: 1.0
      # ex: X2:: 0.5 GEN:: 11 obs_drive_freq:: 0.961538 predicted_viability_drive_freq:: 0.0 obs_freq(DD):: 0.923077 viability_exp_freq(DD):: 0.0 obs_freq(DWT):: 0.0769231 viability_exp_freq(DWT):: 0.0 obs_freq(WT):: 0.0 viability_exp_freq(WT):: 1.0
      # ex: X3:: 0.54 GEN:: 11 obs_drive_freq:: 0.633333 predicted_viability_drive_freq:: 0.0 obs_freq(DD):: 0.153846 viability_exp_freq(DD):: 0.0 obs_freq(DWT):: 0.179487 viability_exp_freq(DWT):: 0.0 obs_freq(WT):: 0.0512821 viability_exp_freq(WT):: 1.0
      if line.startswith("X1::") or line.startswith("X2::") or line.startswith("X3::"):
        spaced_line = line.split()
        x = float(spaced_line[1])
        gen = int(spaced_line[3])-10
        obs_drive_freq = float(spaced_line[5])
        predicted_drive_freq = float(spaced_line[7])
        obs_dd_freq = float(spaced_line[9])
        predicted_dd_freq = float(spaced_line[11])
        obs_dwt_freq = float(spaced_line[13])
        predicted_dwt_freq = float(spaced_line[15])
        obs_wtwt_freq = float(spaced_line[17])
        predicted_wtwt_freq = float(spaced_line[19])
        csv_line = "{},{},{},{},{},{},{},{},{},{},{},{}".format(a,replicate_number,x,gen,obs_drive_freq,predicted_drive_freq,obs_dd_freq,predicted_dd_freq,obs_dwt_freq,predicted_dwt_freq,obs_wtwt_freq,predicted_wtwt_freq)
        print(csv_line)
        
    return


def main():
  '''
  Runs parse_slim() on the string located in output.txt and prints results to the screen.
  '''

  with open(sys.argv[3],"r") as f:
    slim_string = f.read()
  
  a = float(sys.argv[1])
  replicate_number = int(sys.argv[2])
  
  # 12 column header
  # a,replicate_number,x,gen,obs_drive_freq,predicted_drive_freq,obs_dd_freq,predicted_dd_freq,obs_dwt_freq,predicted_dwt_freq,obs_wtwt_freq,predicted_wtwt_freq
  print(f"a,replicate_number,x,gen,d_allele_freq, exp_d_allele_freq, dd_freq, exp_dd_freq, dwt_freq, exp_dwt_freq, wtwt_freq, exp_wtwt_freq")
  
  parse_slim(slim_string, a, replicate_number)
  
    
if __name__ == "__main__":
    main()

