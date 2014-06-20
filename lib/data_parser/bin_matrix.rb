class BinMatrix  
  attr_accessor :documents_hash, :bin_matrix, :words, :csv_input

  def initialize(bin_matrix_csv = 'spec/fixtures/100_tweets/bin_matrix.csv', 
                 csv_input = 'spec/fixtures/100_tweets/tweets_english.csv',
                 text_index = 2,
                 id_index = nil)
    @text_index = text_index
    @id_index = id_index
    @bin_matrix_csv = bin_matrix_csv
    @csv_input =  csv_input
    @tweets_number = File.open(csv_input).readlines.size
    @documents_hash = Hash.new
    @bin_matrix = build_bin_matrix
    @words = @documents_hash.keys

    build_documents_hash()
  end

  def build_documents_hash
    File.open(@csv_input).each_line.with_index do |line, i|
      if @id_index.nil?
        words_from(line){ |word|  add_to_documents_hash(i, word)  }
      else
        words_from(line){ |word|  add_to_documents_hash( get_id(line), word)  }
      end
    end
  end

  def build_bin_matrix 
    bin_matrix = []
    @documents_hash.each do |word_ocurrences|
      bin_vec = Array.new(@tweets_number)
      word_ocurrences.last.map{|p| bin_vec[p-1] = 1}
      bin_matrix.push( bin_vec.map{|p| p.nil? ? 0 : 1} )
    end
    bin_matrix
  end

  def read_tweet tweet_number, bin_matrix = @bin_matrix, documents_hash = @documents_hash
    tweet_text = ""
    bin_matrix.each.with_index{|vec,i| tweet_text = ( tweet_text + " " + documents_hash.keys[i].to_s ) if vec[tweet_number] == 1}
    tweet_text[0] = ''
    tweet_text
  end

  def to_csv bin_mat_csv_file = @bin_matrix_csv, columns = @words, bin_matrix = @bin_matrix
    File.delete(bin_mat_csv_file) if File.exist?(bin_mat_csv_file)
    CSV.open(bin_mat_csv_file, 'ab') do |csv|
      csv << columns if columns != nil
      bin_matrix.transpose.each do |vec|
        csv << vec
      end
    end
  end

  private
  def add_to_documents_hash i, word
    word = word.to_sym
    @documents_hash.has_key?( word ) ? @documents_hash[ word ].push( i ) : @documents_hash[ word ] = [i]
  end

  def words_from line, &block
     line.split(',')[@text_index].split.each{ |word| yield word}
  end

  def get_id(line)
    line.split(',')[@id_index]
  end
end
