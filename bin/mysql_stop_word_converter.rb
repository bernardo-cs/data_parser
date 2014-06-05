require_relative '../lib/data_parser'

require 'set'
File.open('storage/mysql_stop_words_trimed.txt', 'w') do |file|
  file.puts Set.new(IO.read('storage/mysql_stop_words.txt').split("\n").map{ |line| line.remove_url.remove_non_letters.downcase.squeeze.remove_small_words }.select{ |word| word.size > 1 }).to_a
end
