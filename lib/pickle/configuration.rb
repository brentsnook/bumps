module Pickle
  class Configuration

    def initialize output_stream
      @config = {}
      @config[:output_stream] = output_stream
    end  
    
    def method_missing method, *args
      @config.has_key?(method) ? @config[method] : super(method, args)
    end
    
    def configure &block
      instance_eval &block
    end
    
    def use_server server
      @config[:feature_location] = "#{server}/pull_features"
    end
    
  end
end  