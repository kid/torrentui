require 'unrar'

class DownloadedFile < ActiveRecord::Base
  attr_accessible :length, :path
  
  belongs_to :torrent
  
  validates_presence_of :path
  
  def file_name
    File.split(path).last
  end
  
  def is_archive?
    file_name.end_with? '.rar'
  end
  
  def absolute_path
    File.expand_path File.join(AppSettings.transmission_download_dir, self.path)
  end
  
  def extract
    unrar = Unrar::new(absolute_path)
    unrar.list.each do |f|
      if unrar.extract(f[:path], AppSettings.extract_files_destination)
        extracted = ExtractedFile::new(f)
        raise "File not found." unless File.exist? extracted.absolute_path
        torrent.extracted_files << extracted
        torrent.save
      end
    end
  end
end
