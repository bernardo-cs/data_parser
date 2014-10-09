require_relative '../lib/data_parser'
require 'json'
require 'pry'
require 'ark_tweet_nlp'

folder_local = '/src/thesis/inesc_data_set_sample/decompressed'
folder_server = '/home/bersimoes/coding/twitter_data_francisco/decompressed/'

results = File.open( 'results_nlp.tsv', 'w' )
results.puts "type\twords_number"

file = File.join( folder_local, 'tweets01_aaaa' )
tweets = ""

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
