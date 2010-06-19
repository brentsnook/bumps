require 'open-uri'
require 'json'

module Bumps
  
  class RemoteFeature

    def self.fetch location
      parse(open(location){|f| f.read})
    end
    
    def self.parse json
      JSON.parse(json)['features'].collect do |id, feature|
        content = %{@id="#{id}" @version="#{feature['version']}"\n#{feature['content']}}
        Feature.new(feature['name'], content)
      end
    end
    
  end
end