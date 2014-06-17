## Counts the number of word ocurrences in the csv file
#  stores it in a file with the same name, with extension .wcount

def file_reader file_name
  @words_count = {}
  File.read(file_name).each_line{ |line| count_words( line.split(',')[2] ) }
  hash_to_file(@words_count,  file_name)
end

def count_words line
  line.split(',')[1].split(' ').each{ |word| count( word ) }
end

def count word
  @words_count.has_key?(word) ? @words_count[word] = @words_count[word] + 1 : @words_count[word] = 1
end

def hash_to_file hash, file_name
  File.open(file_name.sub('.csv', '.wcount' ), 'w') do |file|
    hash.sort_by{ |k,v| v }.each{ |k| file.puts "#{k.first},#{k.last}" }
  end
end

data_set_path = '/src/thesis/inesc_data_set_sample/decompressed/*_english_trimed.csv'
data_set_server_path = '/home/bersimoes/coding/twitter_data_francisco/decompressed'
Dir.new(data_set_path).each do |file_name|
  if file_name.match /csv/
    file_reader("../decompressed/" + file_name)
  end
end
