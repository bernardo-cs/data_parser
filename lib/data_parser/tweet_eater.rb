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
      @json_datas = [JSONData.new( 'spec/fixtures/1_tweets'), 
                     JSONData.new( 'spec/fixtures/50_mb_tweets'), 
                     JSONData.new( 'spec/fixtures/100_tweets')]
      @bin_matrixs =[BinMatrix.new( 'spec/fixtures/1_tweets'),
                     BinMatrix.new( 'spec/fixtures/50_mb_tweets'),
                     BinMatrix.new( 'spec/fixtures/100_tweets')] 
    end

    def to_csv
      @json_datas.each{|j| j.to_csv}
      @bin_matrixs.each{|m| m.to_csv}
    end
  end
end


