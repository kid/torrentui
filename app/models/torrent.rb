class Torrent < ActiveRecord::Base
  # attr_readonly :info_hash
  attr_accessible :name, :category_id
  attr_accessor :url, :file, :rate_download, :rate_upload, :percent_done

  belongs_to :category
  has_many :downloaded_files, :dependent => :destroy
  has_many :downloaders
  
  def get_details_from_transmission
    return if self.downloaded_files.count > 0
    
    client = Transmission::Client.new(AppSettings.transmission_rpc_host, AppSettings.transmission_rpc_port)
    result = client.request 'torrent-get', {:ids => [info_hash], :fields => ['name', 'files']}
    
    while !result['torrents'][0]['files'].any?
      sleep 1
      result = client.request 'torrent-get', {:ids => [info_hash], :fields => ['name', 'files']}
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
end
