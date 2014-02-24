require 'data_parser'

describe DataParser do 
  it "should be able to print what" do
    DataParser.parse.should eq("Hello there")
  end
end
describe DataParser::TweetEater do
  before(:each) do
    @tweet_eater = DataParser::TweetEater.new( 
                                File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', 'one_tweet_sample.json')) ,
                                File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', 'output.csv')))
  end
  it "should be able to instantiate TweetEater" do
    @tweet_eater.should be_kind_of(DataParser::TweetEater)
  end
  it "should be able to change input_file and ouput_file" do
    @tweet_eater.input_file = "new_file"
    @tweet_eater.output_file = "new_file"
    @tweet_eater.input_file.should eq("new_file")
    @tweet_eater.output_file.should eq("new_file")
  end
  it "should be able to trim unwanted chars: !?,.;:\"\'[]{}\#$^*()\\n from strings" do
    @tweet_eater.trim("Ola, como te chamas?").should eq("ola como te chamas")
    @tweet_eater.trim("!'?,.;:\"[]{}\#$^*()\n").should eq("")
  end
  it "should be able to receive a tweet in json, and return csv formated output" do
    json_file = IO.read(File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', 'one_tweet_sample.json')))
    @tweet_eater.line_to_csv( json_file ).should eq("BeMyBoyfriendJB , perfeita noss")
  end
  it "shoul be able to write mutiple tweets into a file in csv format" do
   File.delete(@tweet_eater.output_file) if File.exist?(@tweet_eater.output_file)
   @tweet_eater.export_to_csv
   File.read(@tweet_eater.output_file).should eq(File.read(File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', 'one_tweet_sample.csv'))))
  end
  it "shoul be able to write lots (50mb) of  tweets into a file in csv format" do
   @tweet_eater.input_file = File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', '50mb_tweets_sample.json')) 
   File.delete(@tweet_eater.output_file) if File.exist?(@tweet_eater.output_file)
   @tweet_eater.export_to_csv
   File.read(@tweet_eater.output_file).should eq(File.read(File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', 'one_tweet_sample.csv'))))
  end
end
