require_relative '../lib/data_parser'
puts `pwd`

IO.read('storage/mysql_stop_words.txt').split("\n").each{ |line| puts line }
