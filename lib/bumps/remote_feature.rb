require 'open-uri'
require 'json'

module Bumps
  
  class RemoteFeature

    def self.fetch location
      parse(open(location){|f| f.read})
    end
    
    def self.parse json
      JSON.parse(json)['features'].collect do |id, feature|
        Feature.new(feature['name'], feature['content'])
      end
    end
    
  end
end