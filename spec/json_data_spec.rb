require_relative '../lib/data_parser'
#require 'pry-rescue/rspec'

describe 'JSONData' do
 before :each do
   @js = JSONData.new
 end

 describe '#trim' do
  it 'removes specified uris from strings' do
    @js.trim('charizard www.google.com','www.google.com').should eq('charizard')
  end
 end

 describe '#line_to_csv' do
  it 'receives a line in json and returns a string in the format username,tweet text' do
   @json_line = IO.read(File.join DataParser.spec, 'fixtures/1_tweets/tweets.json')  
   @csv_line  = IO.read(File.join DataParser.spec, 'fixtures/1_tweets/tweets_english.csv').strip
   @js.line_to_csv(@json_line).should eq(@csv_line) 
  end

  end
  it 'accepts only english tweets by default' do
   json_line_portuguese = IO.read(File.join DataParser.spec, 'fixtures/1_tweets/tweets_portuguese.json')  
   @js.line_to_csv(json_line_portuguese).should be_nil
  end

  it 'accepts other languages' do
   json_line_portuguese = IO.read(File.join DataParser.spec, 'fixtures/1_tweets/tweets_portuguese.json')  
   @js.filter_language = :portuguese
   @js.line_to_csv(json_line_portuguese).should eq('197701824344629248,Missa_Man,ola como vai sua vida este texto esta portugues')
 end

 describe '#to_csv' do
   it 'parses a json object correctly to csv' do
    csv_file = IO.read( File.join( DataParser.spec, 'fixtures/100_tweets/tweets_english_frozen.csv' ) )  
    @js.to_csv
    csv_file.should eq(IO.read @js.csv_output)
   end
 end
end
