class String
  def remove_stop_words
    stop_words ||= IO.read(File.join(DataParser.storage,'mysql_stop_words.txt'))
    stop_words ||= stop_words.split
    self.split.select{|word| !stop_words.include?(word)}.join " "
  end
  def show_stop_words
    stop_words ||= IO.read(File.join(DataParser.storage,'mysql_stop_words.txt'))
    stop_words ||= stop_words.split
    self.split.select{|word| stop_words.include?(word)}
  end
end
