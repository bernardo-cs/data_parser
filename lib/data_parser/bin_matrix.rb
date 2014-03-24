class BinMatrix  
  attr_accessor :documents_hash, :bin_matrix, :words
  def initialize(folder = 'spec/fixtures/100_tweets',
                 bin_matrix_csv = 'bin_matrix.csv', 
                 csv_input = 'tweets_english.csv')
    @folder = File.join(DataParser.root, folder)
    @bin_matrix_csv = File.join(@folder, bin_matrix_csv)
    @csv_input = File.join(@folder, csv_input)
    @tweets_number = 0
    @documents_hash = build_documents_hash
    @bin_matrix = build_bin_matrix
    @words = @documents_hash.keys
  end
    # Converts a csv file line by line into an hash of documents.
    # ** Order is lost **
    # Words that apear more than once on a string are referenced twice.
    # Example:
    # "tweeter_user,ola ola adeus" -> {ola: [ 1, 1 ], adeus: [1]}
    def build_documents_hash csv_file = @csv_input
      documents_hash = Hash.new
      f = File.open(csv_file)
      @tweets_number = 0 
      f.each do |line|
        tweet_words = line.split(',')[1].split    
        tweet_words.each do |word|
          if documents_hash.has_key? word.to_sym
            documents_hash[ word.to_sym ].push f.lineno 
          else
            documents_hash[ word.to_sym ] = [f.lineno]
          end
        end
        @tweets_number = @tweets_number + 1
      end
      documents_hash
    end

    def build_bin_matrix hash = @documents_hash
      bin_matrix = []
      hash.each do |word_ocurrences|
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
end
