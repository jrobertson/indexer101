# Introducing the Indexer101 gem


## Usage

    require 'indexer101'
    require 'wordsdotdat'

    ix = Indexer101.new

    ix.build WordsDotDat.words.compact
    ix.search 'bank'
    #=> ["bank", "banks", "banker", "bankia", "banking", "banksia", ...] 
    ix.index[:bank] #=> "" 

## Resources

* indexer101 https://rubygems.org/gems/indexer101

index indexer indexer101 gem search lookup
