require_relative "data_parser/version"

module DataParser

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

  require_relative 'data_parser/json_data'
  require_relative 'data_parser/twitter_catcher'
  require_relative 'data_parser/string'
end

