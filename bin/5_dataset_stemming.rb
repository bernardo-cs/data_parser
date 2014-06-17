require 'rubygems'
require 'lingua/stemmer'


stemmer= Lingua::Stemmer.new(:language => 'en')
words_hash = {}
data_set_path = 'storage/'
File.foreach('storage/twitter_dataset_words') do |line|
  if words_hash.has_key?( stemmer.stem( line.split(',').first.to_sym  ) )
    words_hash[stemmer.stem( line.split(',').first.to_sym )] = words_hash[stemmer.stem( line.split(',').first.to_sym )].to_i + line.split(',').last.to_i
  else
    #puts "added #{line.split(',').first.to_sym} as:#{ stemmer.stem( line.split(',').first.to_sym  ) } "
    words_hash[ stemmer.stem( line.split(',').first.to_sym )] = line.split(',').last.to_i
  end
end

def hash_to_file hash, file_name, data_set_path
  puts "pwd #{`pwd`}"
  puts "storage path: #{ File.join(data_set_path, file_name) }"
  File.open(File.join(data_set_path, file_name), 'w') do |file|
    hash.sort_by{ |k,v| v }.each{ |k| file.puts "#{k.first},#{k.last}" }
  end
end

hash_to_file(words_hash, 'data_set_words_stemmed', data_set_path)
