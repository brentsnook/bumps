require 'json'
require 'time'

module Bumps
  
  class JSONFormatter
    
    def self.now
      Time.now
    end
    
    def initialize step_mother, io, options
      @io = io
      @features = {}
    end
    
    # required to keep cukes happy
    def before_features(*args);end

    def tag_name tag
      name, value = tag.split(":", 2)
      instance_variable_set(name, value)
    end
  
    def before_feature(feature)
      @feature = {
        'started' => JSONFormatter.now.iso8601,
        'scenarios' => []
      }
    end

    def step_name(keyword, step_match, status, source_indent, background)
     @step = {
       'status' => status,
       'line' => line(step_match.file_colon_line)
     }
     @scenario['steps'] << @step
     @scenario['status'] = status unless status == :skipped
    end
 
    def scenario_name(keyword, name, file_colon_line, source_indent)
      @scenario = {
        'line' => line(file_colon_line),
        'steps' => []
      }
      @feature['scenarios'] << @scenario
    end
     
    def after_feature(feature)
      @feature.merge!({'finished' => JSONFormatter.now.iso8601, 'version' => @version})
      @features[@id] = @feature
    end
    
    def after_features(*args)
      document = {
        'features' => @features  
      }
    
      @io.print(document.to_json)
      @io.flush
    end
  
    private
  
    def line(file_colon_line)
      # ignore first line containing id and version tags
      file_colon_line.split(':')[1].to_i - 1
    end
  end
end