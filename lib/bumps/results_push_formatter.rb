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
      response, body = Net::HTTP.post_form uri, {:results => results}
      if response.code_type == Net::HTTPOK
        @io << "Successfully pushed results to #{Bumps::Configuration.push_url}\n\n"
      else
        @io << "Failed to push results to #{Bumps::Configuration.push_url} - HTTP #{response.code}: \n#{response.body}\n\n"
      end
    end
    
    def method_missing(method, *args, &block)
      formatter.send(method, *args, &block)
    end

    def respond_to?(message, include_private = false)
      super(message, include_private) || formatter.respond_to?(message, include_private)
    end
    
  end
end