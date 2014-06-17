## Counts the number of word ocurrences in the csv file
#  stores it in a file with the same name, with extension .wcount
#  counts only the third [2] columns of the csv file

def file_reader file_name
  @words_count = {}
  File.read(file_name).each_line{ |line| count_words( line.split(',')[2] ) }
  hash_to_file(@words_count,  file_name)
end

def count_words line
  line.split(' ').each{ |word| count( word ) }
end

def count word
  @words_count.has_key?(word) ? @words_count[word] = @words_count[word] + 1 : @words_count[word] = 1
end

def hash_to_file hash, file_name
  File.open(file_name.sub('.csv', '.wcount' ), 'w') do |file|
    hash.sort_by{ |k,v| v }.each{ |k| file.puts "#{k.first},#{k.last}" }
  end
end

folder_local = '/src/thesis/inesc_data_set_sample/decompressed'
folder_server = '/home/bersimoes/coding/twitter_data_francisco/decompressed/'
# Get all files in this folder that start with tweets
Dir.foreach( folder_server ) do |file_path|
  next if file_path =='.' || file_path == '..'
  unless file_path.match(/\.wcount/) 
    if file_path.match /_trimed.csv/
      puts "counting words file #{File.basename(file_path)}..."
      file_reader( folder_server + file_path)
    end
  end
end
