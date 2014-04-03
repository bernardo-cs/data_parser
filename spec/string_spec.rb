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
end
