class Torrent < ActiveRecord::Base
  # attr_readonly :info_hash
  attr_accessible :name, :category_id
  attr_accessor :url, :file, :rate_download, :rate_upload, :percent_done, :status

  belongs_to :category
  has_many :downloaders
  has_many :downloaded_files, :dependent => :destroy
  has_many :extracted_files, :dependent => :destroy
  
  before_destroy do |torrent|
    transmission.torrent_remove(info_hash, true)
  end
  
  STATUS_CODES = {
    0 => 'STOPPED',        # Torrent is stopped
    1 => 'CHECK_WAIT',     # Queued to check files
    2 => 'CHECK',          # Checking files
    3 => 'DOWNLOAD_WAIT',  # Queued to download
    4 => 'DOWNLOAD',       # Downloading
    5 => 'SEED_WAIT',      # Queued to seed
    6 => 'SEED',           # Seeding
    7 => 'ISOLATED',       # Torrent can't find peers
  }
  
  def status_message
    STATUS_CODES[self.status]
  end
  
  def get_details_from_transmission
    return if self.downloaded_files.count > 0
    
    result = transmission.request 'torrent-get', {:ids => [info_hash], :fields => ['name', 'files']}
    
    while !result['torrents'][0]['files'].any?
      sleep 1
      result = transmission.request 'torrent-get', {:ids => [info_hash], :fields => ['name', 'files']}
    end
    
    if result['torrents']
      transaction do
        self.name = result['torrents'][0]['name']
        for f in result['torrents'][0]['files']
          self.downloaded_files << DownloadedFile.new(:path => f['name'], :length => f['length'])
        end
        save!
      end
    end
  end
  
  private
  def transmission
    @transmission ||= Transmission::Client.new(AppSettings.transmission_rpc_host, AppSettings.transmission_rpc_port)
  end
end
