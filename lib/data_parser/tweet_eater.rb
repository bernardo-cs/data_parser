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
      string.tr("!?',.;:\"[]{}#\$^*()\n", ' ') 
    end
  end
end
