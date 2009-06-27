module Pickle::HookTasks
  
  SetFeatureDirectoryTask = lambda do
    # nasty? hell yeah. got any better ideas? need access to that protected method...
    feature_directories = configuration.send :feature_dirs
    
    error_message = 'More than one feature directory/file was specified. ' +
          'Please only specify a single feature directory when using pickle'
    raise error_message if feature_directories.size > 1
    Pickle::Configuration.feature_directory = feature_directories.first
  end
  
  PullFeaturesTask = lambda do
    Pickle::Feature.pull 
  end
  
  RegisterPushFormatterTask = lambda do
    formats = configuration.options[:formats]
    formats['Pickle::ResultsPushFormatter'] = formats.values.first
  end
  
end