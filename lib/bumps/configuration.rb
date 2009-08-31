require 'uri'

module Bumps
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
        :results_formatter => Cucumber::Formatter::Html
      }
    end
    
    def method_missing method, *args
      return @config[method] if @config.has_key?(method)
      method_name = method.to_s
      method_name =~ /=$/ ? @config[method_name.chop.to_sym] = args[0] : super(method, args)
    end
    
    def configure &block
      instance_eval(&block)
    end
    
    def use_server server
      @config[:pull_url] = URI.join(server, 'features/content').to_s
      @config[:push_url] = URI.join(server, 'features/results').to_s
    end
    
    def push_to url
      @config[:push_url] = url
    end
    
    def pull_from url
      @config[:pull_url] = url
    end
    
    def format_results_with formatter_class
      @config[:results_formatter] = formatter_class
    end
  end
end  