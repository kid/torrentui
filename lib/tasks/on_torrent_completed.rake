namespace :torrentui  do
  desc "Executed when a torrent is completed"
  task :on_torrent_completed => :environment, :info_hash do |t|
    
  end
end