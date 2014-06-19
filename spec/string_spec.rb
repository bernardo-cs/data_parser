require 'data_parser'

describe 'String' do
  describe '#remove_stop_words' do
    it 'removes stop words based on the mysql list of stop words' do
      "yes yet you you'd you'll you're you've your yours".remove_stop_words.should eql('')
    end
    it 'does not remove non stop words' do
      "ola como vais you'd you'll you're you've".remove_stop_words.should eq('ola como vais')
    end
  end

  describe '#stem' do
    it "stems words words from string" do
      "Im running while speaking".stem.should eq('Im run while speak')
    end
  end

  describe '#remove_stop_words_trimed' do
    it "removes trimed stop words" do
      IO.read(File.join(DataParser.storage, 'mysql_stop_words_trimed.txt')).remove_stop_words_trimed.should eq('')
    end
  end

  describe '#trim' do
    it "aplies a ton of functions that makes tweets easyer to cluster" do
      "Ruby Life Programming".trim.should eql('rubi life program')
      "Ruuuuuuuuuby Liiiife Programming".trim.should eql('rubi life program')
      "Ruuuuuuuuuby!!!! Liiiife!!! Programming".trim.should eql('rubi life program')
      "Ruuuuuuuuuby!!!! Liiiife!!! Programming".trim.should eql('rubi life program')
      "Trying Ruuuuuuuuuby!!!! took Liiiife!!! together for Programming".trim.should eql('rubi life program')
    end  

    it "keeps removing stop words" do
      File.read("storage/mysql_stop_words_trimed.txt").each_line{ |line| line.trim.should eq('')}
    end

    it 'removes specified uris from strings' do
     'charizard http://www.google.com'.trim.should eq('charizard')
    end

    it 'removes extra spaces and tabs' do
     "\tcharizard    omglop\n\r".trim.should eq('charizard omglop')
    end

    it 'removes words smaller than 3 chars' do
     'remove ol yhey'.trim.should eq('remov yhey')
    end 
  end
end
