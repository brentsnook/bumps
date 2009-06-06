require 'net/http'

module Pickle
  class Feature
    
    attr_accessor :name, :content
    
    def initialize
      @name = ''
      @content = ''
    end  
    
    def self.pull configuration
      RemoteFeature.fetch(configuration.feature_location).each do |feature|
        feature.write_to configuration.feature_directory
      end
    end
    
    def write_to directory
      file = File.new(File.expand_path(directory, name), 'w')
      file.write content
    end 
    
    def eql? match
      self.instance_variables.each do |attr|
        self_attr = self.instance_variable_get(attr)
        match_attr = match.instance_variable_get(attr)
        return false unless self_attr == match_attr
      end
        
      true
    end   
  end
end  