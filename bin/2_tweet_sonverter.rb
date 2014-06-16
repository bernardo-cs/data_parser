# Converts JSON tweets, into csv documents.
# Only preserves:
#       * tweet id -> so the tweet can be retrieved in the future
#       * text     -> tweets text is trimmed for easyer clustering
#       * username -> not sure the reason for this one...
#

require_relative '../lib/data_parser'

folder_local = '/src/thesis/inesc_data_set_sample/decompressed'
folder_server = '/home/bersimoes/coding/twitter_data_francisco/decompressed/'
# Get all files in this folder that start with tweets
Dir.foreach( folder_server ) do |file_path|
  next if file_path =='.' || file_path == '..'
  unless file_path.match(/\.wcount/) || file_path.match(/\.csv/)
    puts "parsing file #{File.basename(file_path)}..."
    JSONData.new( folder_server, file_path, file_path + "_english_trimed.csv").to_csv
  end
end
