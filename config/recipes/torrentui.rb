namespace :torrentui do
  desc "Install various things needed by torrentui"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install unrar"
    stop
  end
  after "deploy:install", "torrentui:install"

  desc "Setup various things needed by torrentui"
  task :setup, roles :app do
    
  end
end