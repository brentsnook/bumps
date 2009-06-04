class ScenarioProcess

  @commands = []

  def self.run command, name
    log = File.expand_path(File.dirname(__FILE__) + "/../../../tmp/#{name}.log")
    FileUtils.rm log, :force => true
    process = IO.popen "(#{command}) > #{log} 2>&1"
    process.sync = true
    wait_for log

    @commands << command
  end

  def self.kill_all
    # this method of killing stuff sucks, feels error prone
    @commands.each do |command|
      `ps`.each do |process|
        # the space at the front of the pattern is essential...
        # otherwise this will only work intermittently; if the pid you want to kill
        # is shorter than others in the process list then the group will not capture it        
        matches = process.match /\s*(\d*).*#{Regexp.escape(command)}/
        `kill #{matches[1]}` if matches
      end
    end  
  end

  private

  def self.wait_for file
    until File.exists? file
      sleep 0.2
    end
    
  end

end