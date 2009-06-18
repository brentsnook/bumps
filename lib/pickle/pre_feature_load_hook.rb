module Pickle
  class PreFeatureLoadHook
    def self.register_on clazz
      clazz.class_eval {
        
        alias :original_load_plain_text_features :load_plain_text_features
        
        def load_plain_text_features
          register_pickle_feature_directory
          Pickle::Feature.pull
          original_load_plain_text_features
        end
        
        def register_pickle_feature_directory
          # nasty? hell yeah. got any better ideas? need access to that protected method...
          feature_directories = configuration.send :feature_dirs
          
          error_message = 'More than one feature directory/file was specified. ' +
                'Please only specify a single feature directory when using pickle'
          raise error_message if feature_directories.size > 1
          Pickle::Configuration.feature_directory = feature_directories.first
        end  
      }
    end
  end
end