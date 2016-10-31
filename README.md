# profile_cpu_time

Introduction:
  This program samples the cpu time and system within 60 seconds. It parse 
  the /proc/PID/stat information to csv file and excel file.

Sample Output:

PID:NAME                 SUM	user	sys	cuser	csys  
2133:(firefox)           707	707	    0	0	0  
2228:(update-notifier)	 572	1	    498	73	0  
976:(Xorg)               295	295	    0	0	0  
1621:(compiz)	           228	227	    0	1	0  
1500:(pulseaudio)	        87	87	0	0	0  
19:(ksoftirqd/1)	        81	81	0	0	0  
2239:(sh)	                32	0	11	21	0  
7:(rcu_sched)	            25	25	0	0	0  
1254:(VBoxClient)	        19	19	0	0	0  
1337:(hud-service)	      15	15	0	0	0  
1351:(unity-panel-ser)	  13	13	0	0	0  


=========================================================================
Required Ruby packages
  1. $ gem install spreadsheet

=========================================================================
Usage:
  1. $ ./sample_cpu_time.sh
  2. $ ruby parse_proc.rb

=========================================================================
Default Output file: 
  1. CSV file: output.csv
  2. Excel file: output.xls
