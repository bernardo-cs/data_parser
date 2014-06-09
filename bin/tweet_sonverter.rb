# Converts JSON tweets, into csv documents.
# Only preserves:
#       * tweet id -> so the tweet can be retrieved in the future
#       * text     -> tweets text is trimmed for easyer clustering
#       * username -> not sure the reason for this one...
#

require_relative '../lib/data_parser'
