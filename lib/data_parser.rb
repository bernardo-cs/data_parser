require "data_parser/version"

module DataParser
  require 'data_parser/tweet_eater'
  require 'data_parser/json_data'
  require 'data_parser/twitter_catcher'
  require 'data_parser/string.rb'
  def self.parse
    "Hello there"
  end
  def self.root
    File.expand_path('../../', __FILE__)
  end
  def self.storage
    File.join root, 'storage'
  end
  def self.log
    File.join root, 'logs'
  end
  def self.spec
    File.join root, 'spec'
  end
end

