class DownloadedFilesController < ApplicationController
  skip_before_filter :authenticate_user!
  respond_to :json, :html

  def index
    @files = torrent.downloaded_files
    respond_with @files
  end
  
  def download
    @download = DownloadedFile.find(params[:id])
    
    response.header["Accept-Ranges"]=  "bytes"
    response.header["Content-Transfer-Encoding"] = "binary"

    send_file(@download.absolute_path, :url_based_filename => true)
  end

  private
  def torrent
    @torrent ||= Torrent.find(params[:torrent_id])
  end
end