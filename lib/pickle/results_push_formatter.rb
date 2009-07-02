require 'cucumber/formatter/html'

module Pickle
  class ResultsPushFormatter < Cucumber::Ast::Visitor
    
    def initialize(step_mother, io, options)
      super step_mother
      @formatter_io = StringIO.new
      @formatter = Cucumber::Formatter::Html.new step_mother, @formatter_io, options
    end

    def visit_features features
      @formatter.visit_features features
      @formatter_io.close
    end
  end
end