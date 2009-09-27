desc "Define and create temp directory"
task :create_tmp do
  ENV['BUMPS_TEMP'] = File.expand_path(File.join(File.dirname(__FILE__), '../tmp'))
  mkdir_p ENV['BUMPS_TEMP'], :verbose => false
end
