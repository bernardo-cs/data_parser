require_relative "../lib/data_parser/tweets_bin_matrix.rb"
require_relative "../../mini_twitter/lib/tweet.rb"

include DataParser

describe TweetsBinMatrix do

  before :each do
     @tweets = [MiniTwitter::Tweet.new(1,'hello there how are you doing'),
                MiniTwitter::Tweet.new(2,'my name is dora the explorator'),
                MiniTwitter::Tweet.new(3,'welcome to the jungle')]
     @svm_words = ['dora', 'explor']
     @tbm = TweetsBinMatrix.new( @tweets, @svm_words)
  end

  describe '#word_index' do
    it "indexes the words" do
      @tbm.word_index.should eql({'dora'=>0, 'explor'=>1})
    end
  end

  describe '#create_svm' do
   it 'creates vector space from words present in tweets' do
     @tbm.svm.should eq([[0, 0], [1, 1], [0, 0]])
   end
   it 'stores tweets inside the arrays' do
     @tbm.svm[0].tweet.text.should eq 'hello there how are you doing'

   end
  end

end
