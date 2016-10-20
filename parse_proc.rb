#!/bin/ruby
require 'csv'
FILE_OLD="log_0.txt"
FILE_NEW="log_1.txt"
INDEX_KEY=0

# read space seperated file
old = CSV.read(FILE_OLD, {:col_sep => " "})
new = CSV.read(FILE_NEW, {:col_sep => " "})


