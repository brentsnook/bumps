require 'cucumber/formatter/html'
require 'net/http'

module Pickle
  class ResultsPushFormatter < Cucumber::Ast::Visitor
    
    def initialize(step_mother, io, options)
      super step_mother
      @step_mother = step_mother
      @io = io
      @options = options
    end

    def visit_features features
      push results_of_running(features)
    end
    
    def push results
      uri = URI.parse(Pickle::Configuration.push_url)
      response, body = Net::HTTP.post_form uri, {:results => results}
      if response.code_type == Net::HTTPOK
        @io << "Successfully pushed results to #{Pickle::Configuration.push_url}\n\n"
      else
        @io << "Failed to push results to #{Pickle::Configuration.push_url} - HTTP #{response.code}: \n#{response.body}\n\n"
      end
    end
    
    def wrapped_formatter_class
      Cucumber::Formatter::Html
    end
    
    def results_of_running features
      StringIO.open do |io|
        formatter = wrapped_formatter_class.new step_mother, io, options
        formatter.visit_features features
        
        io.string
      end
    end
  end
end