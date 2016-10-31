#!/bin/ruby
require 'csv'
require 'spreadsheet'

output_csv="output.csv"
output_excel="output.xls"

# set up default file names
# usage: 
#	ARG[0]: the file name of previous sample  
#	ARG[1]: the file name of latest sample  
if !ARGV.empty? && ARGV.length == 2
	FILE_OLD = ARGV[0]
	FILE_NEW = ARGV[1]
else
	print "Warning: use default file name\n"
	printf("number of input parameters: %d\n", ARGV.length)
	FILE_OLD = "log_0.txt"
	FILE_NEW = "log_1.txt"
end

# index of /proc/pid/stat
# please use "man proc" to check the definition
INDEX_PID=0
INDEX_NAME=1
INDEX_UTIME=14
INDEX_STIME=15
INDEX_CUTIME=16
INDEX_CSTIME=17

# index of output format of csv file
INDEX_DIFF_UTIME=0
INDEX_DIFF_STIME=1
INDEX_DIFF_CUTIME=2
INDEX_DIFF_CSTIME=3
INDEX_DIFF_SUM=4

# read space seperated file
old = CSV.read(FILE_OLD, {:col_sep => " "})
new = CSV.read(FILE_NEW, {:col_sep => " "})

# convert 2d array to hash of 1d array
# input:
#	array_2d: 2d array
# output:
#	hash of 1d array
def array_2d_to_hash (array_2d)

	hash_array = Hash.new

	array_2d.each_index { |index|
		array_1d = array_2d[index]
		#print array_1d

		# ignore empty array
		if array_1d.count > 0
			# use "PID:NAME" as key
			key = array_1d[INDEX_PID] + ":" + array_1d[INDEX_NAME]
			#print key

			# convert array to hash
			hash_array[key] = array_1d
		end
	}

	return hash_array
end

# calculate the time difference
# input:
#	index
#	array_new: the latest sample
#	array_old: the previous sample
#	input type: 1d array
# output:
#	time difference
#	type: integer
def cal_time_diff (index, array_new, array_old)
	# convet string to interger and caluate diff
	return array_new[index].to_i - array_old[index].to_i
end

# calculate time difference between 2 samples
# input: 
#	hash_new: the latest sample
#	hash_old: the previous sample
#	type: hash of 1d array
# output:
#	time difference.
#	type: hash of 1d array.
def get_time_diff (hash_new, hash_old)
	hash_time = Hash.new

	hash_new.each do |key, array|
		if hash_old.key?(key)
			old = hash_old[key]
			new = hash_new[key]

			time_diff = Array.new

			time_diff[INDEX_DIFF_UTIME] = cal_time_diff(INDEX_UTIME, new, old)
			time_diff[INDEX_DIFF_STIME] = cal_time_diff(INDEX_STIME, new, old)
			time_diff[INDEX_DIFF_CUTIME] = cal_time_diff(INDEX_CUTIME, new, old)
			time_diff[INDEX_DIFF_CSTIME] = cal_time_diff(INDEX_CSTIME, new, old)
			time_diff[INDEX_DIFF_SUM] = time_diff[INDEX_DIFF_UTIME] +  
										time_diff[INDEX_DIFF_STIME] +  
										time_diff[INDEX_DIFF_CUTIME] +  
										time_diff[INDEX_DIFF_CSTIME]  

			hash_time[key] = time_diff
		end
	end

	return hash_time
end

# convert hash of array to 2d array, and add commemt on 1st row.
# input: hash of 1d array
# output: hsh of array
def hash_time_to_array (hash_time)
	a = Array.new
	a.push(["PID:NAME", "SUM", "user", "sys", "cuser", "csys"])

	hash_time.each {|key, array|
			a.push([ key, 
				array[INDEX_DIFF_SUM],
				array[INDEX_DIFF_UTIME],
				array[INDEX_DIFF_STIME],
				array[INDEX_DIFF_CUTIME],
				array[INDEX_DIFF_CSTIME] 
				])
	}
	return a
end

# convert 2d array to csv file
# input:
#	array_2d: 2d array of time difference
#	output_file: the name of csv file
def array_to_csv (array_2d, output_file)
	CSV.open(output_file, "w") do |csv|
		array_2d.each { |array|
			csv << array
		}
	end
end

def array_to_excel(array_2d, output_excel)
	# open the workbook
	workbook = Spreadsheet::Workbook.new

	# create a workbook
	workbook.create_worksheet :name => 'time difference'

	# specify a worksheet by index
	sheet0 = workbook.worksheet(0)

	# insert array to row of excel
	array_2d.each_index { |index|
		sheet0.insert_row(index, array_2d[index])
	}

	# write workbook to excel
	workbook.write(output_excel)
end

# convert array to hash
hash_old = array_2d_to_hash(old)
hash_new = array_2d_to_hash(new)

# calculate time diff
hash_time = get_time_diff(hash_new, hash_old)

# convert hash to array
array_time = hash_time_to_array(hash_time)

# convert array to csv file
array_to_csv(array_time, output_csv)

# convert array to excel file
array_to_excel(array_time, output_excel)
