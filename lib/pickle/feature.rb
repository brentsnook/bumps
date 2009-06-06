require 'net/http'

module Pickle
  class Feature
    
    attr_accessor :name, :content
    
    def initialize
      @name = ''
      @content = ''
    end  
    
    def self.pull config
      config.output_stream << "\nRetrieving features from #{config.feature_location} ...\n"
      features = RemoteFeature.fetch(config.feature_location)
      features.each do |feature|
        feature.write_to config.feature_directory
      end
      config.output_stream << "Wrote #{features.size} features to #{config.feature_directory}\n\n"
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