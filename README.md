# profile_cpu_time

Introduction:
  This program samples the cpu time and system within 60 seconds. It parse 
  the /proc/PID/stat information to csv file and excel file.

Required Ruby packages:
  $ gem install spreadsheet

Usage:
  Step 1: $ ./sample_cpu_time.sh
  Step 2: $ ruby parse_proc.rb

Default Output file: 
  1. CSV file: output.csv
  2. Excel file: output.xls
