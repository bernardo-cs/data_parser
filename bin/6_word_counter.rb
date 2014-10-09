require_relative '../lib/data_parser'
require 'json'
require 'pry'

folder_local = '/src/thesis/inesc_data_set_sample/decompressed'
folder_server = '/home/bersimoes/coding/twitter_data_francisco/decompressed/'

results = File.open( 'results.tsv', 'w' )
results.puts "type\twords_number"

class String
  def get_words_as_set
    Set.new self.split
  end
end

file = File.join( folder_local, 'tweets01_aaaa' )
all_words = Set.new

File.open(file,'r').each_line do |l|
  begin
    tweet_text = JSON.parse( l )['text']
    all_words.merge( tweet_text.get_words_as_set ) unless tweet_text.nil?
  rescue JSON::ParserError
  end
end
results.puts("all_words\t#{all_words.size}")

str_methods = [:remove_url, :remove_non_letters, :downcase, :squeeze, :remove_small_words, :remove_stop_words_trimed, :stem, :trim]
str_methods.each do |m|
  s = Set.new( all_words.map(&:dup).map( &m ) )
  results.puts("#{m}\t#{s.size}")
end

results.close
