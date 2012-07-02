require 'open3'

class Unrar
  def initialize(filename)
    @archive = filename
  end

  def list
    files = []
    
    Open3.popen3('unrar', 'l', @archive) do |stdin, stdout, stderr, wait_thread|
      if wait_thread.value == 0 && stdout.read() =~ /^-+\n(.+\n)+^-+/m
        $1.split("\n").collect do |line|
          if line =~ / ([^?*:{}\\]+) (\d+) \d+  -->/
            files << {:path => $1, :length => $2}
          end
        end
      end
    end
    
    files
  end

  def extract(file, dest = nil)
    Open3.popen3('unrar', '-y', 'e', @archive, file, :chdir => dest || '.') { |stdin, stdout, stderr, wait_thread|
      unless wait_thread.value == 0
        raise stderr.read()
      end
      true
    }
  end
end