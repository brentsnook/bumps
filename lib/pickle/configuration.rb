module Pickle
  class Configuration
    
    DEFAULT_CONFIG_FILE = 'pickle.yml'
    
    attr_reader :output_stream
    
    def initialize output_stream
      @output_stream = output_stream
    end  
    
    def method_missing method, *args
      config.has_key?(method.to_s) ? config[method.to_s] : super(method, args)
    end
    
    def file
      config_file = ARGV[0] || DEFAULT_CONFIG_FILE
      unless File.exist? config_file
        raise "Pickle configuration file (#{config_file}) was not found"
      end
      config_file
    end  
    
    private
    
    def config
      return @config if @config
      properties = YAML::load(IO.read(file))
      assert_required_present properties
      @config = properties
    end
    
    def assert_required_present properties
      ['feature_location', 'feature_directory'].each do |required_property|
        unless properties.keys.include? required_property
          raise "Required property #{required_property} not found in #{file}"
        end   
      end
    end
    
  end
end  