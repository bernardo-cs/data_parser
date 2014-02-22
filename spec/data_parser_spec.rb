require 'data_parser'
describe DataParser do 
  it "should be able to print what" do
    DataParser.parse.should eq("Hello there")
  end
end

describe DataParser::TweetEater do
  before(:each) do
    @tweet_eater = DataParser::TweetEater.new("input_file", "output_file")
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
    @tweet_eater.trim("!'?,.;:\"[]{}\#$^*()\n").should eq("                   ")
  end
end
