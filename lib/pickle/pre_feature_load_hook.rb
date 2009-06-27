module Pickle
  class PreFeatureLoadHook
    def self.register_on clazz
      clazz.class_eval do
        
        alias_method :original_load_plain_text_features, :load_plain_text_features
        
        def pickle_load_plain_text_features
          Pickle::PreFeatureLoadHook.tasks.each { |task| instance_eval &(task.block) }
          original_load_plain_text_features
        end
        
        alias_method :load_plain_text_features, :pickle_load_plain_text_features

      end
    end
    
    def self.tasks
      [
        HookTasks::SetFeatureDirectoryTask,
        HookTasks::PullFeaturesTask,
        HookTasks::RegisterPushFormatterTask
      ]
    end
  end
end