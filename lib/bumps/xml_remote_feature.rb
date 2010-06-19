require 'nokogiri'
require 'open-uri'

module Bumps
  
  class XmlRemoteFeature

    def self.fetch location
      parse(open(location){|f| f.read})
    end
    
    def self.parse xml
      Nokogiri::XML(xml).search('feature').collect do |feature|
        Feature.new(feature.attribute('name').to_s, feature.text.strip)
      end  
    end
    
  end
end  