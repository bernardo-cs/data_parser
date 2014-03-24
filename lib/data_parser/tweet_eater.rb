require 'fileutils'
require 'uri'
require 'csv'
require 'data_parser/json_data'
require 'data_parser/bin_matrix'

module DataParser
  # Public: used for parsing json tweets into csv tweets
  # Class must be instantiated with the source json file, and the desired
  # output folder
  class TweetEater
    attr_accessor :bin_matrix, :json_data
    def initialize 
     @json_data = JSONData.new( 'spec/fixtures/50_mb_tweets')
     @bin_matrix = BinMatrix.new( 'spec/fixtures/50_mb_tweets') 
    end

    def to_csv
      @json_data.to_csv
      @bin_matrix.to_csv
    end
  end
end


