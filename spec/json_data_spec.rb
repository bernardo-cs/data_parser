require 'data_parser'

describe 'JSONData' do
 before :each do
   @js = JSONData.new
 end

 it 'instatiates a json_data object' do
     @js.should be_kind_of(JSONData) 
 end 

 describe '#trim' do
  it 'removes specified uris from strings' do
    @js.trim('should www.google.com','www.google.com').should eq('should')
  end
  it 'removes extra spaces and tabs' do
    @js.trim("\tshould    omglop\n\r").should eq('should omglop')
  end
  it 'remove letter that occur twice' do
    @js.trim('hello').should eq('helo')
  end
  it 'downcase words' do
    @js.trim('SHOULD').should eq('should')
  end
  it 'removes words smaller than 3 chars' do
    @js.trim('should remove e but not aei').should eq('should remove but not aei')
  end
 end

 describe '#line_to_csv' do
  it 'receives a line in json and returns a string in the format username,tweet text' do
   @json_line = IO.read(File.join DataParser.spec, 'fixtures/1_tweets/tweets.json')  
   @csv_line  = IO.read(File.join DataParser.spec, 'fixtures/1_tweets/tweets.csv').strip
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
   @js.line_to_csv(json_line_portuguese).should eq('Missa_Man,ola meu nome bernardo como que chamas')
 end

 describe '#to_csv' do
   it 'parses a json object correctly to csv' do
    csv_file = IO.read(File.join DataParser.spec, 'fixtures/100_tweets/tweets_english_frozen.csv')  
    @js.to_csv
    csv_file.should eq(IO.read @js.csv_output)
   end
 end
end
