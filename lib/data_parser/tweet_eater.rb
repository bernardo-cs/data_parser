require 'fileutils'
require 'json'

module DataParser
  class TweetEater
    attr_accessor :input_file, :output_file
    def initialize(input_file, output_file )
      @input_file = input_file 
      @output_file = output_file 
    end
    def to_s
      "input_file: #{@input_file }, output_file: #{@output_file }"
    end
    def trim string
      # string.tr!(url) if url != nil
      string.tr!("!?',.;:\"[]{}#\$^*()\n\t", ' ').downcase! 
      string.strip.split.join(" ")
    end
    def line_to_csv( line, delimiting_char = ' , ' )
      tweet = JSON.parse(line)
      text = if tweet.has_key? "urls"
               trim(tweet["text"], tweet["urls"]["url"])
             else
               trim(tweet["text"])
             end
      begin
        "#{tweet["user"]["screen_name"]}#{delimiting_char}#{trim(tweet["text"])}"
      rescue NoMethodError
      end
    end
    def export_to_csv
      out_file = File.new(@output_file, 'w')
      in_file = File.open(@input_file, 'r')
      while (line = in_file.gets)
        out_file.puts(line_to_csv(line))
      end
      out_file.close
      in_file.close
    end
  end
end
