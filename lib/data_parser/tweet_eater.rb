require 'fileutils'
require 'json'
require 'uri'
require 'whatlanguage'
require 'csv'

module DataParser
  # Public: used for parsing json tweets into csv tweets
  # Class must be instantiated with the source json file, and the desired
  # output folder
  class TweetEater
    attr_accessor :input_file, :output_file , :documents_hash,:filter_language, :bin_matrix, :csv_file
    def initialize(input_file, output_file, csv_file = 'out.csv',filter_language = :english)
      @input_file = input_file
      @output_file = output_file
      @csv_file = csv_file
      @filter_language = filter_language
      @documents_hash = Hash.new
      @bin_matrix = []
    end

    def trim(string, *url)
      begin
        string.slice!(url.first) if (url.size != 0) & (string != '')
        string.slice!(URI.regexp)
        string.gsub!(/[^a-zA-Z]/, ' ').downcase! 
        return string.strip.split.join(' ')
      rescue NoMethodError
      end
    end
 
    def line_to_csv(line, delimiting_char = ',')
      tweet = JSON.parse(line)
      begin
        url = tweet['entities']['urls'].first['url']
      rescue NoMethodError
      end
      text = url != nil ? trim(tweet['text'], url) : trim(tweet['text'])
      begin
        "#{tweet["user"]["screen_name"]}#{delimiting_char}#{text}" if (text.size != 0 and text.language == @filter_language)
      rescue NoMethodError
      end
    end

    # Converts a csv file line by line into an hash of documents.
    # ** Order is lost **
    # Words that apear more than once on a string are referenced twice.
    # Example:
    # "tweeter_user,ola ola adeus" -> {ola: [ 1, 1 ], adeus: [1]}
    def build_documents_hash csv_file = @csv_file
      f = File.open(@csv_file) 
      f.each do |line|
        #csv_line = line_to_csv(line)
        tweet_words = line.split(',')[1].split    
        tweet_words.each do |word|
          if @documents_hash.has_key? word.to_sym
            @documents_hash[ word.to_sym ].push f.lineno 
          else
            @documents_hash[ word.to_sym ] = [f.lineno]
          end
        end
      end
    end

    def convert_hash_to_bin_matrix( hash = @documents_hash, bin_matrix = @bin_matrix )
      hash.each do |word_ocurrences|
        bin_vec = Array.new(hash.keys.size)
        word_ocurrences.last.map{|p| bin_vec[p-1] = 1}
        bin_matrix.push( bin_vec.map{|p| p.nil? ? 0 : 1} )
      end
      @bin_matrix = bin_matrix
    end

    def read_tweet_from_bin_mat tweet_number, bin_matrix = @bin_matrix, documents_hash = @documents_hash
      tweet_text = ""
      bin_matrix.each.with_index{|vec,i| tweet_text = ( tweet_text + " " + documents_hash.keys[i].to_s ) if vec[tweet_number] == 1}
      tweet_text[0] = ''
      tweet_text
    end

    def export_bmatrix_csv bin_mat_csv_file, columns = nil, bin_matrix = @bin_matrix
       CSV.open(bin_mat_csv_file, 'ab') do |csv|
         csv << columns if columns != nil
         bin_matrix.transpose.each do |vec|
           csv << vec
         end
       end
    end

    def export_to_csv
      out_file = File.new(@output_file, 'w')
      File.open(@input_file, 'r').each_line do |line|
        csv_line = line_to_csv(line)
        out_file.puts(csv_line) unless csv_line.nil?
      end
      out_file.close
    end
  end
end

