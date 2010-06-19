require 'open-uri'
require 'json'

module Bumps
  
  class RemoteFeature

    def self.fetch location
      parse(open(location){|f| f.read})
    end
    
    def self.parse json
      document = JSON.parse json
      document['features'].collect do |id, feature_document|
        feature = Feature.new
        feature.name, feature.content = feature_document['name'], feature_document['content']
        feature
      end
    end
    
  end
end