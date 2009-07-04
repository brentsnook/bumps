require 'uri'

module Pickle
  class Configuration
    
    def self.method_missing method, *args, &block
      singleton.send method, *args, &block  
    end
    
    def self.singleton
      @singleton = Configuration.new unless defined? @singleton
      @singleton 
    end
    
    def initialize
      @config = {
        :output_stream => STDOUT,
        :push_content_formatter => Cucumber::Formatter::Html
      }
    end
    
    def method_missing method, *args
      return @config[method] if @config.has_key?(method)
      method.to_s.end_with?('=') ? @config[method.to_s.chop.to_sym] = args[0] : super(method, args)
    end
    
    def configure &block
      instance_eval(&block)
    end
    
    def use_server server
      @config[:pull_url] = URI.join(server, 'features/content').to_s
      @config[:push_url] = URI.join(server, 'features/results').to_s
    end
  end
end  