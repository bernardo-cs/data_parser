require 'data_parser'
include DataParser

describe DataParser do 
  it "should be able to print what" do
    DataParser.parse.should eq("Hello there")
  end
end

describe TweetEater do
  before(:each) do
    @tweet_eater = TweetEater.new( 
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
  
  describe "#trim" do
    it "should be able to trim unwanted chars: !?,.;:\"\'[]{}\#$^*()\\n from strings" do
      @tweet_eater.trim("Ola, como te chamas?").should eq("ola como te chamas")
      @tweet_eater.trim("!'?,.;:\"[]{}\#$^*()\n").should eq("")
    end
    it "trims url" do
      string = "ola adeus http://www.google.com"
      url = "http://www.google.com"
      @tweet_eater.trim(string, url).should eq("ola adeus")
    end
  end

  describe "#line_to_csv" do
    it "receives a tweet with an url and should remove it" do
      File.delete(@tweet_eater.output_file) if File.exist?(@tweet_eater.output_file)
      json_string = IO.read(File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', 'one_tweet_sample_with_url.json')))
      @tweet_eater.line_to_csv( json_string ).should eq("saurav_saus,i posted a new photo to facebook")
    end
    it "should be able to receive a tweet in json, and return csv formated output" do
      File.delete(@tweet_eater.output_file) if File.exist?(@tweet_eater.output_file)
      json_file = IO.read(File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', 'one_tweet_sample.json')))
      @tweet_eater.line_to_csv( json_file ).should eq("Missa_Man,i dnt even have an ipad but that just kilt it")
    end
  end
  describe "#export_to_csv" do
    it "shoul be able to write mutiple tweets into a file in csv format" do
      File.delete(@tweet_eater.output_file) if File.exist?(@tweet_eater.output_file)
      @tweet_eater.export_to_csv
      File.read(@tweet_eater.output_file).should eq(File.read(File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', 'one_tweet_sample.csv'))))
    end
    it "shoul be able to write lots (50mb) of  tweets into a file in csv format" do
      @tweet_eater.input_file = File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', '50mb_tweets_sample.json')) 
      File.delete(@tweet_eater.output_file) if File.exist?(@tweet_eater.output_file)
      @tweet_eater.export_to_csv
      File.read(@tweet_eater.output_file).should eq(File.read(File.expand_path(File.join(File.dirname(__FILE__),'dummy_data', '50mb_tweets_sample_english_only.csv'))))
    end
  end
 end
