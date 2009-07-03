require 'uri'

module Pickle
  class Configuration
    
    def self.method_missing method, *args
      config.has_key?(method) ? config[method] : super(method, args)
    end
    
    def self.configure &block
      instance_eval(&block)
    end
    
    def self.use_server server
      config[:pull_url] = URI.join(server, 'features/content').to_s
      config[:push_url] = URI.join(server, 'features/results').to_s
    end
    
    def self.feature_directory= directory
      config[:feature_directory] = directory
    end
    
    def self.output_stream= output_stream
      config[:output_stream] = output_stream
    end
      
    private 
    
    def self.config
      return @config if defined? @config
      @config = {:output_stream => STDOUT}
    end
  end
end  