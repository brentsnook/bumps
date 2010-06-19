module Bumps
  class Feature
    
    attr_accessor :name, :content
    
    def initialize name, content
      @name = name
      @content = content
    end  
    
    def self.pull
      Configuration.output_stream << "Retrieving features from #{Configuration.pull_url} ...\n"
      begin
        features = RemoteFeature.fetch(Configuration.pull_url)
      rescue Exception => e
        Configuration.output_stream << "Could not pull features: #{e}\n"
        features = []
      end
        
      features.each do |feature|
        feature.write_to Configuration.feature_directory
      end
      Configuration.output_stream << "Wrote #{features.size} features to #{Configuration.feature_directory}\n\n"
    end
    
    def write_to directory
      write_content_to absolute_path_under(directory)
    end
    
    def write_content_to file_path
      FileUtils.makedirs File.dirname(file_path)
      File.open(file_path, 'w') {|f| f.write(content) }
    end
    
    def absolute_path_under directory
      expanded_directory = File.expand_path directory
      file_path = File.expand_path(File.join(directory, file_name))
      unless file_path =~ /^#{expanded_directory}/
         raise "Could not write feature to path #{file_path}, path is not below #{expanded_directory}"
       end
      file_path
    end
    
    def eql? match
      self.instance_variables.each do |attr|
        self_attr = self.instance_variable_get(attr)
        match_attr = match.instance_variable_get(attr)
        return false unless self_attr == match_attr
      end
        
      true
    end   
    
    private
    
    def file_name
      "#{name.downcase.strip.gsub(' ', '_')}.feature"
    end
  end
end  