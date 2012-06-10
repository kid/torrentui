class DownloadedFilesController < ApplicationController
  respond_to :json, :html

  def index
    @files = torrent.downloaded_files
    respond_with @files
  end

  def download
    @download = DownloadedFile.find(params[:id])
    path = File.join(AppSettings.transmission_download_dir, @download.path)
    response.header["Accept-Ranges"] = "bytes"
    response.header["Content-Length"] = File.size(path)
    send_file path
  end

  private
  def torrent
    @torrent ||= Torrent.find(params[:torrent_id])
  end
end
