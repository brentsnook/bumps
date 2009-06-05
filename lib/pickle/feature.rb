module Pickle
  class Feature
    
    attr_reader :name, :content
    
    def initialize
      @name = ''
      @content = ''
    end  
    
    def self.pull configuration
      fetch(configuration.feature_location).write_to configuration.feature_directory
    end
      
    def self.fetch location
      raise 'implement me'
    end
    
    def write_to directory
      file = File.new(File.expand_path(directory, name), 'w')
      file.write content
    end  
  end
end  