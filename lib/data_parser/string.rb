class String
  STOP_WORDS_CACHE = IO.read(File.join(DataParser.storage,'mysql_stop_words.txt')).split   

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
