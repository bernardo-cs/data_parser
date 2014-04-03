require 'uri'
require 'json'
require 'whatlanguage'

class JSONData

  attr_accessor :folder, :json_input, :csv_output, :filter_language
  def initialize(folder = 'spec/fixtures/100_tweets',
                  json_input = 'tweets.json', 
                  csv_output = 'tweets_english.csv')
    @folder = File.join(DataParser.root, folder)
    @json_input = File.join(@folder, json_input)
    @csv_output = File.join(@folder, csv_output)
    @filter_language = :english
  end

  def trim(string, *url)
    begin
      string.slice!(url.first) if (url.size != 0) & (string != '')
      string = string.remove_stop_words
      string = string.strip.gsub(/[^a-zA-Z]/, ' ')
      string = string.downcase.squeeze
      string = string.split.reject{|word| word.size < 3}.join(' ')
    rescue NoMethodError
    end
  end
  
  def line_to_csv(line, delimiting_char = ',', filter_language = @filter_language)
    tweet = JSON.parse(line)
    begin
      url = tweet['entities']['urls'].first['url']
    rescue NoMethodError
    end
    text = url != nil ? trim(tweet['text'], url) : trim(tweet['text'])
    begin
      "#{tweet["user"]["screen_name"]}#{delimiting_char}#{text}" if (text.size != 0 and tweet['text'].language == filter_language)
    rescue NoMethodError
    end
  end
  
  def to_csv(csv_output = @csv_output, json_input = @json_input)
    File.delete(csv_output) if File.exist?(csv_output)
    out_file = File.new(csv_output, 'w')
    File.open(json_input, 'r').each_line do |line|
      csv_line = line_to_csv(line)
      out_file.puts(csv_line) unless csv_line.nil?
    end
    out_file.close
  end
end
