#!/bin/ruby
require 'csv'

print ARGV.length

if !ARGV.empty? && ARGV.length == 2
FILE_OLD = ARGV[0]
FILE_NEW = ARGV[1]
else
print "Warning: use default file name\n"
FILE_OLD = "log_0.txt"
FILE_NEW = "log_1.txt"
end

INDEX_PID=0
INDEX_NAME=1
INDEX_UTIME=14
INDEX_STIME=15
INDEX_CUTIME=16
INDEX_CSTIME=17

INDEX_DIFF_UTIME=0
INDEX_DIFF_STIME=1
INDEX_DIFF_CUTIME=2
INDEX_DIFF_CSTIME=3
INDEX_DIFF_SUM=4

# read space seperated file
old = CSV.read(FILE_OLD, {:col_sep => " "})
new = CSV.read(FILE_NEW, {:col_sep => " "})

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

def cal_time_diff (index, array_new, array_old)
	# convet string to interger and caluate diff
	return array_new[index].to_i - array_old[index].to_i
end

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

def print_time_diff (hash_time)
	printf( "%-20s\t%s\t%s\t%s\t%s\t%s\n", 
			"PID:NAME", "SUM", "user", "sys", "cuser", "csys")

	hash_time.each {|key, array|
		printf("%-20s\t%d\t%d\t%d\t%d\t%d\n", 
				key, 
				array[INDEX_DIFF_SUM],
				array[INDEX_DIFF_UTIME],
				array[INDEX_DIFF_STIME],
				array[INDEX_DIFF_CUTIME],
				array[INDEX_DIFF_CSTIME]
				)
	}
end

hash_old = array_2d_to_hash(old)
hash_new = array_2d_to_hash(new)

#print hash_old
#print hash_new
hash_time = get_time_diff(hash_new, hash_old)

#print hash_time
print_time_diff(hash_time)
