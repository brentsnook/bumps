module Bumps::HookTasks
  
  SetFeatureDirectoryTask = lambda do
    # nasty? hell yeah. got any better ideas? need access to that protected method...
    feature_directories = configuration.send :feature_dirs
    
    error_message = 'More than one feature directory/file was specified. ' +
          'Please only specify a single feature directory when using bumps'
    raise error_message if feature_directories.size > 1
    Bumps::Configuration.feature_directory = feature_directories.first
  end
  
  PullFeaturesTask = lambda do
    Bumps::Feature.pull 
  end
  
  RegisterPushFormatterTask = lambda do
    configuration.options[:formats]['Bumps::ResultsPushFormatter'] = Bumps::Configuration.output_stream
  end
  
  SetOutputStreamTask = lambda do
    Bumps::Configuration.output_stream = @out_stream
  end
  
end