require_relative "../../../mini_twitter/lib/tweet.rb"
require_relative "array.rb"
require "set"

module DataParser
  class TweetsBinMatrix
    attr_reader :tweets, :svm_words, :type_of_text, :svm, :word_index
    alias_method :bin_matrix , :svm

    # svm_words is a Set with the words desired to be used in the input space
    # tweets is an array of MiniTwitter::Tweet
    # use stem lybrary to reduce dimensional space
    # type of text can be :trimmed_text or :text
    def initialize(tweets, svm_words, type_of_text: :trimmed_text)
      @tweets       = tweets
      @svm_words    = svm_words
      @type_of_text = type_of_text
      @word_index   = svm_words_to_hash()
      @svm          = create_svm()
    end

    def create_svm
      @tweets.each.with_index.inject(init_rows){ |svm, (tweet,i)|
         svm[i] = convert_to_svm( tweet.send(@type_of_text) )
         svm[i].set_tweet tweet
         svm
      }
    end

    def read_tweet vector
      @svm.select{ |m| m == vector }.tweet.text
    end

    private
    def convert_to_svm text
      words = text.split(' ')
      words.each.inject( init_columns ){|v,w|
        v[@word_index[w]] = 1 if @word_index[w] != nil
        v
      }
    end

    def init_rows
      Array.new @tweets.size
    end

    def init_columns
      Array.new( @svm_words.size){ 0 }
    end

    # Returns an Hash where words are keys and numbers are the value
    def svm_words_to_hash
      Hash[svm_words.map.with_index.to_a]
    end

    # Implements read_tweet in order to be compatible with
    # reportable method from SOM library
    def read_tweet vector
      vector.tweet.text
    end
    def method_missing( meth, *args, &block )
      @svm.send( meth, *args, &block )
    end
  end
end
