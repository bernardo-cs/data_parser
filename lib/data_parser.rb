require "data_parser/version"

module DataParser
  def self.parse
    "Hello there"
  end
  def self.root
    File.expand_path('../../', __FILE__)
  end
  def self.spec
    File.join root, 'spec'
  end
  require 'data_parser/tweet_eater'
  require 'data_parser/json_data'
end

