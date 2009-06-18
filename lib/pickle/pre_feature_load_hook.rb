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
          error_message = 'More than one feature directory/file was specified. ' +
                'Please only specify a single feature directory when using pickle'
          raise error_message if configuration.feature_dirs.size > 1
          Pickle::Configuration.feature_directory = configuration.feature_dirs.first
        end  
      }
    end
  end
end