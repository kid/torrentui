namespace :transmission do
  desc "Install latest stable release of transmission"
  task :install, roles: :app do
    run "#{sudo} add-apt-repository -y ppa:transmissionbt/ppa"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install transmission-daemon"
    run "#{sudo} update-rc.d -f transmission-daemon remove"
    stop
  end
  after "deploy:install", "transmission:install"

  desc "Setup transmission configuration for this application"
  task :setup, roles: :app do
    run "mkdir -p /home/#{user}/transmission/downloads/extracted"
    template "transmission_settings.json.erb", "/home/#{user}/transmission/settings.json"
  end
  after "deploy:setup", "transmission:setup"

  %w[start stop restart reload].each do |command|
    desc "#{command} transmission"
    task command, roles: :app do
      run "#{sudo} service transmission-daemon #{command}"
    end
  end
end