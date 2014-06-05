require 'uri'

class String
  STOP_WORDS_CACHE = IO.read(File.join(DataParser.storage,'mysql_stop_words.txt')).split   

  def trim
     remove_url.remove_stop_words.remove_non_letters.downcase.squeeze.remove_small_words
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

  def remove_stop_words
    split.select{|word| !stop_words.include?(word)}.join " "
  end

  def show_stop_words
    split.select{|word| stop_words.include?(word)}
  end

  def stop_words
    STOP_WORDS_CACHE
  end
end
