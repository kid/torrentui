namespace :god do
  desc "Install latest stable release of god"
  task :install, roles: :app do
  	run "gem install god"
  end
  after "deploy:install", "god:install"
  
  desc "Setup God app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "god_init.erb", "#{shared_path}/config/god_init.sh"
    run "chmod +x #{shared_path}/config/god_init.sh"
    run "#{sudo} ln -nsf #{shared_path}/config/god_init.sh /etc/init.d/god_#{application}"
    run "#{sudo} update-rc.d -f god_#{application} defaults"
  end
  after "deploy:setup", "god:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "#{sudo} service god_#{application} #{command}"
    end
    after "deploy:#{command}", "god:#{command}"
  end
end