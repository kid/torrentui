namespace :transmission do
  desc "Install latest stable release of transmission"
  task :install, roles: :app do
    run "#{sudo} add-apt-repository ppa:transmissionbt/ppa"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install transmission-daemon"
  end
  after "deploy:install", "transmission:install"

  desc "Setup transmission configuration for this application"
  task :setup, roles: :app do
    run "mkdir -p /home/#{user}/transmission/downloads"
    run "#{sudo} perl -i -p -e 's/^USER=debian-transmission/USER=#{user}/' /etc/init.d/transmission-daemon"
    
    stop
    template "transmission_settings.json.erb", "/tmp/transmission_settings"
    
    unless remote_file_exists?("/etc/transmission-daemon/settings.json.copy")
      run "#{sudo} mv /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.copy"
    end
    
    run "mv /tmp/transmission_settings /home/#{user}/transmission/settings.json"
    run "#{sudo} ln -nfs /home/#{user}/transmission/settings.json /etc/transmission-daemon/settings.json"
    start
  end
  after "deploy:setup", "transmission:setup"

  %w[start stop restart reload].each do |command|
    desc "#{command} transmission"
    task command, roles: :app do
      run "#{sudo} service transmission-daemon #{command}"
    end
  end
end