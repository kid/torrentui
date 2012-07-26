RAILS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
PID_FILE = File.join(RAILS_ROOT, 'tmp/pids/transmission.pid')
LOG_FILE = File.join(RAILS_ROOT, 'log/transmission.log')
CONFIG_DIR = "/home/p2p/transmission/"

God.watch do |w|
  w.name = 'transmission-daemon'
  w.start = "transmission-daemon -f -x #{PID_FILE} -e #{LOG_FILE} -g #{CONFIG_DIR}"
  w.pid_file = PID_FILE
  w.log = LOG_FILE
  
  w.uid = 'p2p'
  w.gid = 'sudo'
  
  w.keepalive
  w.stop_timeout = 30.seconds
  w.behavior(:clean_pid_file)
end