require_relative '../lib/data_parser/bin_matrix.rb'
require 'tempfile'

describe BinMatrix do
  before :each do
    @csv_input_file = Tempfile.new('csv_input') 
    @csv_input_file.write("253583303901327362,BestYouNevrHad,ayrikahnichole xbox\n")
    @csv_input_file.write("253583300558454785,myhiroto_bot,yuda hono\n")
    @csv_input_file.write("253583301900640256,Yung_Cino,cazorla playing imp\n")
    @csv_input_file.rewind

    @csv_matrix_file = Tempfile.new('csv_matrix')
  end

  describe "#build_documents_hash" do
    it "converts the csv file into an hash, where keys are the words, and the values are arrays with the number of the line where the word ocurred" do
      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @csv_input_file.path, 2)
      @bin_matrix.documents_hash.should eq({ayrikahnichole: [ 0 ], xbox: [ 0 ], yuda: [ 1 ], hono: [ 1 ], cazorla: [ 2 ], playing: [ 2 ], imp: [ 2 ]})
    end
    it "builds a document hash with ids specified in the csv file, if given as last argument" do
      @bin_matrix = BinMatrix.new( @csv_matrix_file.path, @csv_input_file.path, 2, 0)
      @bin_matrix.documents_hash.should eq({:ayrikahnichole=>["253583303901327362"], :xbox=>["253583303901327362"], :yuda=>["253583300558454785"], :hono=>["253583300558454785"], :cazorla=>["253583301900640256"], :playing=>["253583301900640256"], :imp=>["253583301900640256"]})
    end
  end
end
