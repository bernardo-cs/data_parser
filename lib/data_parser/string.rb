class String
  @stop_words_cache = nil 

  def remove_stop_words
    split.select{|word| !stop_words.include?(word)}.join " "
  end

  def show_stop_words
    split.select{|word| stop_words.include?(word)}
  end

  def stop_words
    @stop_words_cache ||= IO.read(File.join(DataParser.storage,'mysql_stop_words.txt')).split
  end
end
