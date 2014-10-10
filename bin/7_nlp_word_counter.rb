require_relative '../lib/data_parser'
require 'json'
require 'pry'
require 'ark_tweet_nlp'

folder_local = '/src/thesis/inesc_data_set_sample/decompressed'
folder_server = '/home/bersimoes/coding/twitter_data_francisco/decompressed/'

results = File.open( 'results_nlp.tsv', 'w' )
results.puts "type\twords_number"

file = File.join( folder_server, 'tweets01_aaaa' )
tweets = ""

File.open(file,'r').each_line do |l|
  begin
    tweet_text = JSON.parse( l )['text']
    tweets << tweet_text.split.join(' ') << "\n" unless tweet_text.nil?
  rescue JSON::ParserError
  end
end

tagged_result = ArkTweetNlp::Parser.find_tags(tweets)
tagged_result = ArkTweetNlp::Parser.get_words_tagged_as(tagged_result, *ArkTweetNlp::Parser::TAGSET.keys)
tagged_result.each_pair do |k,v|
  results.puts("#{ArkTweetNlp::Parser::TAGSET[k]}\t#{Set.new(v).size}")
end

results.close

