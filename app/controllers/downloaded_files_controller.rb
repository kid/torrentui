class DownloadedFilesController < ApplicationController
  respond_to :json, :html

  def index
    @files = torrent.downloaded_files
    respond_with @files
  end

  def download
    @download = DownloadedFile.find(params[:id])
    send_file File.join(AppSettings.transmission_download_dir, @download.path)
  end

  private
  def torrent
    @torrent ||= Torrent.find(params[:torrent_id])
  end
end
