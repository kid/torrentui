RAILS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
PID_DIR = File.join(RAILS_ROOT, 'tmp/pids')
LOG_DIR = File.join(RAILS_ROOT, 'log')
CMD_PREFIX = "PATH=/home/p2p/.rbenv/shims:/home/p2p/.rbenv/bin:$PATH"
CMD = "#{CMD_PREFIX}; cd #{RAILS_ROOT}; /usr/bin/env RAILS_ENV=production #{RAILS_ROOT}/script/delayed_job"


1.times do |num|
  God.watch do |w|
    w.name     = "delayed_job-#{num}"
    w.group    = 'delayed_job'
    w.interval = 30.seconds

    w.uid = 'p2p'
    w.gid = 'sudo'

    w.start = "#{CMD} -i #{num} --pid-dir=#{PID_DIR} start" 
    w.start_grace = 30.seconds 
    w.restart_grace = 30.seconds 

    w.stop = "#{CMD} stop" 
    
    w.log = "#{LOG_DIR}/delayed_job.#{num}.log" 
    w.pid_file = "#{PID_DIR}/delayed_job.#{num}.pid"

    w.interval = 15.seconds 
    w.behavior(:clean_pid_file) 

    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 300.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end
  
    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end
    
      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end
  
    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end