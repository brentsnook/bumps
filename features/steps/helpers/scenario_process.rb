class ScenarioProcess

  @commands = []
  
  def initialize command, name
    @command = command
    @name = name
  end  
  
  def run
    remove log
    IO.popen(full_command).sync = true
    wait_for log
  end
  
  def run_and_wait
    remove log
    `#{full_command}`
  end
  
  def self.run command, name
    new(command,name).run
    @commands << command
  end
 
  def self.run_and_wait command, name
    new(command,name).run_and_wait
  end
  
  def self.kill_all
    @commands.each { |command| kill command }
  end
  
  def self.kill command
    # this method of killing stuff sucks, feels brittle
    
    `ps`.each do |process|
      # the space at the front of the pattern is essential...
      # otherwise this will only work intermittently; if the pid you want to kill
      # is shorter than others in the process list then the group will not capture it        
      matches = process.match /\s*(\d*).*#{Regexp.escape(command)}/
      `kill #{matches[1]}` if matches
    end
  end
  
  private
  
  def log
    File.expand_path(File.dirname(__FILE__) + "/../../../tmp/#{@name}.log")
  end 
  
  def remove file
    FileUtils.rm file, :force => true
  end 
  
  def full_command
    "(#{@command}) > #{log} 2>&1"
  end
  
  def wait_for file
    until File.exists? file
      sleep 0.2
    end
    
  end

end