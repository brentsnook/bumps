require 'nokogiri'

require 'open-uri'

module Bumps
  
  class RemoteFeature
    
    def self.fetch location
      parse(open(location){|f| f.read})
    end
    
    def self.parse xml
      document = Nokogiri::XML xml
      document.search('feature').collect do |feature_element|
        feature = Feature.new
        feature.content = feature_element.text.strip
        feature.name = feature_element.attribute('name').to_s
        feature
      end  
    end  
  end
end  