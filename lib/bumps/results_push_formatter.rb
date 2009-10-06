require 'cucumber/formatter/html'
require 'net/http'

module Bumps
  class ResultsPushFormatter
    
    attr_reader :formatter, :results
    
    def initialize(step_mother, io, options)
      @step_mother = step_mother
      @io = io
      @options = options
    end
    
    def before_features features
      @results = StringIO.open
      @formatter = Bumps::Configuration.results_formatter.new @step_mother, results, @options
      formatter.before_features features
    end
    
    def after_features features
      formatter.after_features features
      results.close
      push results.string
    end
    
    def push results
      uri = URI.parse(Bumps::Configuration.push_url)
      begin
        response, body = Net::HTTP.post_form uri, {:results => results}
      rescue Exception => e
        @io << failure_message(e.message)
        return
      end
      
      response_ok = response.code_type == Net::HTTPOK 
      @io << (response_ok ? success_message : failure_message("HTTP #{response.code}: \n#{response.body}"))
    end
    
    def method_missing(method, *args, &block)
      formatter.send(method, *args, &block)
    end

    def respond_to?(message, include_private = false)
      super(message, include_private) || formatter.respond_to?(message, include_private)
    end
    
    private
    
    def failure_message(message)
      "Failed to push results to #{Bumps::Configuration.push_url} - #{message}\n"
    end
    
    def success_message
      "Successfully pushed results to #{Bumps::Configuration.push_url}\n"
    end  
  end
end