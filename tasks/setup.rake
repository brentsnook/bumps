desc "Create temp directory"
task :create_tmp do
  mkdir_p ENV['BUMPS_TEMP'], :verbose => false
end
