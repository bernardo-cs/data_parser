require 'uri'

class String
  @stop_words_cache = nil
  @stop_words_trimed_cache = nil

  def trim
     remove_url
     .remove_non_letters
     .downcase
     .squeeze
     .remove_small_words
     .remove_stop_words_trimed
  end

  def remove_small_words
    split.reject{|word| word.size < 3}.join(' ')
  end
  
  def remove_non_letters
    strip.gsub(/[^a-zA-Z]/, ' ')
  end

  def remove_url
    gsub(URI.regexp, '')
  end

  #DUP1: stopwords and stopwords methods can be reduced to only one method
  def remove_stop_words_trimed
    split.select{|word| !stop_words_trimed.include?(word)}.join " "
  end

  #DUP1: stopwords and stopwords methods can be reduced to only one method
  def remove_stop_words
    split.select{|word| !stop_words.include?(word)}.join " "
  end

  #DUP1: stopwords and stopwords methods can be reduced to only one method
  def show_stop_words
    split.select{|word| stop_words.include?(word)}
  end

  #DUP1: stopwords and stopwords methods can be reduced to only one method
  def stop_words_trimed
    @stop_words_trimed_cache ||= IO.read(File.join(DataParser.storage,'mysql_stop_words_trimed.txt')).split   
  end

  #DUP1: stopwords and stopwords methods can be reduced to only one method
  def stop_words
    @stop_words_cache ||= IO.read(File.join(DataParser.storage,'mysql_stop_words.txt')).split   
  end
end
