module Pickle
  class Configuration
    
    CONFIG_FILE = 'pickle.yml'
    
    def method_missing method, *args
      config.has_key?(method.to_s) ? config[method.to_s] : super(method, args)
    end  
    
    private
    
    def config
      return @config if @config
      unless File.exist? CONFIG_FILE
        raise "Pickle configuration file (#{CONFIG_FILE}) was not found"
      end
      properties = YAML::load(IO.read(CONFIG_FILE))
      assert_required_present properties
      @config = properties
    end
    
    def assert_required_present properties
      ['feature_location', 'feature_directory'].each do |required_property|
        unless properties.keys.include? required_property
          raise "Required property #{required_property} not found in #{CONFIG_FILE}"
        end   
      end
    end
  end
end  