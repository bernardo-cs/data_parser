require_relative '../lib/data_parser'

puts IO.read('storage/mysql_stop_words.txt').split("\n").map{ |line| line.squeeze }
