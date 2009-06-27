module Pickle
  class ResultsPushFormatter < Cucumber::Ast::Visitor
    def initialize(step_mother, io, options)
      super step_mother
    end
  end
end