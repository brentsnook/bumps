module Bumps
  class CucumberConfig
    
    def initialize source_config
      @source_config = source_config
    end  
    
    def process!
      validate
      update_bumps_config
      register_formatter
    end
    
    def validate
      error_message = 'More than one feature directory/file was specified. ' +
            'Please only specify a single feature directory when using bumps'
      raise error_message if @source_config.feature_dirs.size > 1
    end
    
    def update_bumps_config
      Bumps::Configuration.feature_directory = @source_config.feature_dirs.first
      Bumps::Configuration.output_stream = @source_config.out_stream
    end
    
    def register_formatter
      @source_config.options[:formats] << ['Bumps::ResultsPushFormatter', Bumps::Configuration.output_stream]
    end
  end
end