require 'twitter'
class TwitterCatcher
  attr_accessor :client
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['THESIS_TWITTER_KEY']
      config.consumer_secret     = ENV['THESIS_TWITTER_SECRET']
      config.access_token        = ENV['THESIS_TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['THESIS_TWITTER_ACCESS_TOKEN_SECRET']
    end
  end
  
end
