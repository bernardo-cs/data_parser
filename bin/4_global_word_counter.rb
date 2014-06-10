## Searches for all the .wcount files in a given folder
## and returns a file with all the words present ind the dataset
## counted

data_set_path = '/src/thesis/inesc_data_set_sample/decompressed'
file_extensions = '*.wcount'
words_count = {}
# Iterates through all the files and adds the ocurrence of words to a new file
Dir.new(File.join(data_set_path, file_extensions)).each do |file_name|
  File.read(file_name).each_line do |line|
    if words_count.has_key?( line.split(',')[0] )
      words_count[line.split(',').[0]] = words_count[line.split(',').[0]] + line.split(',')[1].to_i
    else
      words_count[line.split(',').[0]] = line.split(',')[1].to_i
    end
  end
end      

def hash_to_file hash, file_name, data_set_path
  File.open(File.join(data_set_path, file_name), 'w') do |file|
    hash.sort_by{ |k,v| v }.each{ |k| file.puts "#{k.first},#{k.last}" }
  end
end

hash_to_file(words_count, 'data_set_words')
