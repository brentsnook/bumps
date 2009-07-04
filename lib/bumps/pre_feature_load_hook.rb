module Bumps
  class PreFeatureLoadHook
    def self.register_on clazz
      clazz.class_eval do
        
        alias_method :original_load_plain_text_features, :load_plain_text_features
        
        def bumps_load_plain_text_features
          Bumps::PreFeatureLoadHook.tasks.each { |task| instance_eval(&task) }
          original_load_plain_text_features
        end
        
        alias_method :load_plain_text_features, :bumps_load_plain_text_features

      end
    end
    
    def self.tasks
      [
        HookTasks::SetFeatureDirectoryTask,
        Bumps::HookTasks::SetOutputStreamTask,
        HookTasks::PullFeaturesTask,
        HookTasks::RegisterPushFormatterTask
      ]
    end
  end
end