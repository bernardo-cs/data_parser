require 'csv'

class BinMatrix
  attr_accessor :documents_hash, :bin_matrix, :words, :csv_input, :line_id_logger, :bin_matrix_csv
  include Enumerable

  def initialize(bin_matrix_csv = 'spec/fixtures/100_tweets/bin_matrix.csv',
                 csv_input = 'spec/fixtures/100_tweets/tweets_english.csv',
                 text_index = 2,
                 id_index = nil)
    @text_index = text_index
    @id_index = id_index
    @bin_matrix_csv = bin_matrix_csv
    @csv_input =  csv_input
    @tweets_number = get_tweets_number
    @documents_hash = Hash.new
    @line_id_logger = {}

    build_documents_hash()
    @bin_matrix = build_bin_matrix
    @words = @documents_hash.keys
  end

  def build_documents_hash
    begin
      build_for_file()
    rescue TypeError
      #Raise e
      build_for_array()
    #else
      #Raise 'Build Matrix Receives File or Array'
    end
  end

  def build_bin_matrix
    @documents_hash.inject([]) { |vec, word_ocurrences| vec.push(build_row(word_ocurrences.last))}.transpose
  end

  def read_tweet bin_vector
    convert_indexes_to_string( find_words_indexes( bin_vector ))
  end

  def to_csv!
    File.delete(@bin_matrix_csv) if File.exist?(@bin_matrix_csv)
    CSV.open(@bin_matrix_csv, 'ab') do |csv|
      csv << @words if @words != nil
      @bin_matrix.each do |vec|
        csv << vec
      end
    end
  end

  private
  def get_tweets_number
    csv_input.class == String ? File.open(csv_input).readlines.size : csv_input.size
  end

  def build_for_file
      File.open(@csv_input).each_line.with_index do |line, i|
        @line_id_logger[get_id(line)] = i unless @id_index.nil?
        words_from(line){ |word|  add_to_documents_hash( i, word)  }
      end
  end

  def build_for_array
    @csv_input.each.with_index{ |t, i| words_from(t){ |word| add_to_documents_hash( i, word)  } }
  end

  def convert_indexes_to_string indexes_array
    indexes_array.inject(""){ |str,i| str + @words[i].to_s + " "}[0..-2]
  end

  def find_words_indexes bin_vector
    bin_vector.each_index.select{ |i| bin_vector[i] == 1 }
  end

  def build_row ocurrences
      ocurrences.inject(Array.new(@tweets_number)){|vec,p| vec[p] = 1; vec}.map{|p| p.nil? ? 0 : 1}
  end

  def add_to_documents_hash i, word
    word = word.to_sym
    @documents_hash.has_key?( word ) ? @documents_hash[ word ].push( i ) : @documents_hash[ word ] = [i]
  end

  def words_from line, &block
     line.split(',')[@text_index].split.each{ |word| yield word}
  end

  def get_id(line)
    @id_index.nil? ? nil : line.split(',')[@id_index]
  end

  def method_missing( meth, *args, &block )
    @bin_matrix.send( meth, *args, &block )
  end
end
