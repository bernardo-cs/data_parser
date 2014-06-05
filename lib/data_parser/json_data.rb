require 'uri'
require 'benchmark'
require 'json'
require 'whatlanguage'
require 'logger'

class JSONData
  attr_accessor :folder, :json_input, :csv_output, :filter_language
  attr_reader :logger
  
  def initialize(folder = 'spec/fixtures/100_tweets',
                  json_input = 'tweets.json', 
                  csv_output = 'tweets_english.csv')
    @folder = File.join(DataParser.root, folder)
    @json_input = File.join(@folder, json_input)
    @csv_output = File.join(@folder, csv_output)
    @logger = Logger.new(File.join(DataParser.log, "trim.log"))
    @filter_language = :english
    logger.debug("\n\n\n###-------- #{folder} --------###\n")
  end

  def trim(string, *url)
    begin
      string = string.gsub(URI.regexp, '')
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
      if (text.size != 0 and tweet['text'].language == filter_language)
        logger.debug("[ORIGINAL]" + String(tweet['text']))
        logger.debug("[TRIMED]  " + String(text))
        "#{tweet["user"]["screen_name"]}#{delimiting_char}#{text}"     
      end
    rescue NoMethodError
    end
  end

  def to_csv_compar
    Benchmark.bm(10) do |x|
      x.report "lazy" do
        to_csv_lazy
      end
      x.report "non lazy" do
        to_csv
      end
    end
  end

  def to_csv_lazy(csv_output = @csv_output, json_input = @json_input)
    File.delete(csv_output) if File.exist?(csv_output)
    out_file = File.new(csv_output, 'w')
    File.open(json_input, 'r').lazy.each do |line|
      csv_line = line_to_csv(line)
      out_file.puts(csv_line) unless csv_line.nil?
    end
    out_file.close
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
