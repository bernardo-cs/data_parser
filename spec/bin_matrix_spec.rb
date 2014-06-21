require_relative '../lib/data_parser/bin_matrix.rb'
require 'tempfile'

describe BinMatrix do
  before :each do
    @csv_input_file = Tempfile.new('csv_input') 
    @csv_input_file.write("253583303901327362,BestYouNevrHad,ayrikahnichole xbox\n")
    @csv_input_file.write("253583300558454785,myhiroto_bot,yuda xbox hono\n")
    @csv_input_file.write("253583301900640256,Yung_Cino,cazorla playing imp\n")
    @csv_input_file.rewind

    @csv_matrix_file = Tempfile.new('csv_matrix')
  end

  describe "#build_documents_hash" do
    it "converts the csv file into an hash, where keys are the words, and the values are arrays with the number of the line where the word ocurred" do
      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @csv_input_file.path, 2)
      @bin_matrix.documents_hash.should eq({ayrikahnichole: [ 0 ], xbox: [ 0,1 ], yuda: [ 1 ], hono: [ 1 ], cazorla: [ 2 ], playing: [ 2 ], imp: [ 2 ]})
    end

    it "keeps track of tweets ids and the line they where at, if the id position in the csv is specified" do

      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @csv_input_file.path, 2, 0)
      @bin_matrix.line_id_logger.should eql({"253583303901327362" => 0, 
                                             "253583300558454785" => 1,
                                             "253583301900640256" => 2})
    end
  end

  describe '#build_bin_matrix' do
    it "constructs a binary matrix from the documents hash" do
      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @csv_input_file.path, 2)
      @bin_matrix.build_bin_matrix.should eql([ [1, 1, 0, 0, 0, 0, 0],
                                                [0, 1, 1, 1, 0, 0, 0],
                                                [0, 0, 0, 0, 1, 1, 1] ])
    end
  end
end
