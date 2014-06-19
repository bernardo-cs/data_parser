require 'twitter'
class TwitterCatcher
  attr_accessor :client

  def initialize( folder = 'spec/fixtures/100_tweets', 
                 csv_input = 'tweets_english.csv',
                 output_folder = 'users' )
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['THESIS_TWITTER_KEY']
      config.consumer_secret     = ENV['THESIS_TWITTER_SECRET']
      config.access_token        = ENV['THESIS_TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['THESIS_TWITTER_ACCESS_TOKEN_SECRET']
    end
    @users_dir = File.join(folder, output_folder)
    @unaccessible_users = []
    @fetched_users = []
    @csv_input = File.join(folder, csv_input)
  end

  def each_username csv_file = @csv_input
   IO.readlines(@csv_input).each do |line|
    yield line.split(',')[0]
   end
  end

  def build_directory username, client = @client, users_dir = @users_dir 
    Dir.mkdir(File.join(users_dir, username)) unless @fetched_users.include? username
  end

  def get_user_tweets username, client = @client, users_dir = @users_dir 
    begin
      out_file = File.new(File.join(users_dir, username, 'tweets.csv'),'w') 
      @client.user_timeline(username,count: 200, exclude_replies: true, include_rts: false).each do |tweet|
        tweet_text = String.new(tweet.full_text) 
        tweet.uris.each{|uri| tweet_text.gsub!(uri.url.to_s, '')} if tweet.uris?
        out_file.puts tweet_text.gsub(/[^a-zA-Z]/, ' ').downcase 
      end
      out_file.close
      @fetched_users << username
    rescue Twitter::Error
      puts "unreachable: #{username}"
      @unaccessible_users << username
    end 
  end

  def write_vector_to_file path, file_name, vector
    file = File.new(File.join(path,file_name + ".csv"), 'w')
    vector.each{|username| file.puts username}
    file.close
  end

  def get_users_tweets client = @client
    each_username do |username| 
      puts "setting up stuff for #{username}"
      build_directory(username)
      get_user_tweets(username) unless @unaccessible_users.include? username
    end
    write_vector_to_file @users_dir, 'unaccessible', @unaccessible_users
    write_vector_to_file @users_dir, 'fetched', @fetched_users
  end
end
