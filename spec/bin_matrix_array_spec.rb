require_relative '../lib/data_parser/bin_matrix.rb'
require 'tempfile'

describe BinMatrix do
  before :each do
    @input_array = []
    @input_array << "253583303901327362,BestYouNevrHad,ayrikahnichole xbox\n"
    @input_array << "253583300558454785,myhiroto_bot,yuda xbox hono\n"
    @input_array << "253583301900640256,Yung_Cino,cazorla playing imp\n"

    @csv_matrix_file = Tempfile.new('csv_matrix')
  end

  describe "#build_documents_hash" do
    it "converts the csv file into an hash, where keys are the words, and the values are arrays with the number of the line where the word ocurred" do
      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @input_array, 2)
      @bin_matrix.documents_hash.should eq({ayrikahnichole: [ 0 ], xbox: [ 0,1 ], yuda: [ 1 ], hono: [ 1 ], cazorla: [ 2 ], playing: [ 2 ], imp: [ 2 ]})
    end
    ## Empty strings are needed to maintain order
    it "can receive empty strings" do
    @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @input_array, 2)
    @bin_matrix.documents_hash.should eq({ayrikahnichole: [ 0 ], xbox: [ 0,1 ], yuda: [ 1 ], hono: [ 1 ], cazorla: [ 2 ], playing: [ 2 ], imp: [ 2 ]})
    end
  end

  describe '#build_bin_matrix' do
    it "constructs a binary matrix from the documents hash" do
        @input_array = []
    @input_array << "ayrikahnichole xbox"
    @input_array << "yuda xbox hono"
    @input_array << "cazorla playing imp"
    #supports emmpty strings
    @input_array << ""
   @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @input_array, 0 )
      @bin_matrix.build_bin_matrix.should eql([ [1, 1, 0, 0, 0, 0, 0],
                                                [0, 1, 1, 1, 0, 0, 0],
                                                [0, 0, 0, 0, 1, 1, 1],
                                                [0, 0, 0, 0, 0, 0, 0]] )
    end
  end
  describe '#build_bin_matrix' do
    it "constructs a binary matrix from the documents hash" do
      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @input_array, 2)
      @bin_matrix.build_bin_matrix.should eql([ [1, 1, 0, 0, 0, 0, 0],
                                                [0, 1, 1, 1, 0, 0, 0],
                                                [0, 0, 0, 0, 1, 1, 1] ])
    end
  end

  describe '#read_tweet' do
    it "reads a binary vector and converts it to a tweet" do
      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @input_array, 2)
      @bin_matrix.read_tweet(@bin_matrix.bin_matrix.first).should eql("ayrikahnichole xbox")
    end
  end

  describe '#to_csv' do
    it "converts the binary matrix to a csv file" do
      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @input_array, 2)
      @bin_matrix.to_csv!
      File.read( @bin_matrix.bin_matrix_csv ).should eql(
        "ayrikahnichole,xbox,yuda,hono,cazorla,playing,imp\n1,1,0,0,0,0,0\n0,1,1,1,0,0,0\n0,0,0,0,1,1,1\n")
    end
  end
end
