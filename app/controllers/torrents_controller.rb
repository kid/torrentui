class TorrentsController < ApplicationController
  respond_to :json, :html
  
  # GET /torrents
  # GET /torrents.json
  def index
    @torrents = Torrent.includes(:category, :downloaders => [:user]).all
    
    live_data = transmission.request('torrent-get', :fields => [:hashString, :status, :rateDownload, :rateUpload, :percentDone])
    
    for t in @torrents
      data = live_data['torrents'].detect { |d| t.info_hash == d['hashString'] }
      if data
        t.rate_download = data['rateDownload']
        t.rate_upload = data['rateUpload']
        t.percent_done = data['percentDone'] * 100
      end
    end
    
    respond_with @torrent
  end

  # GET /torrents/1
  # GET /torrents/1.json
  def show
    @torrent = Torrent.find(params[:id])
    respond_with @torrent
  end

  # GET /torrents/new
  # GET /torrents/new.json
  def new
    @torrent = Torrent.new
    respond_with @torrent
  end

  # GET /torrents/1/edit
  def edit
    @torrent = Torrent.find(params[:id])
    respond_with @torrent
  end

  # POST /torrents
  # POST /torrents.json
  def create
    @torrent = Torrent.new params[:torrent].except(:url, :file)
    @torrent.downloaders << Downloader.new(:user_id => current_user.id)
    
    link = params[:torrent][:url]
    if /magnet\:\?xt=urn\:btih\:([0-9a-zA-Z]+)/ =~ link
      @torrent.info_hash = $1.downcase#, :category_id => params[:torrent][:cateogry_id]
      if @torrent.valid?
        result = transmission.torrent_add link
        puts result
        if result['torrent-added']
          if result['torrent-added']['hashString'] != @torrent.info_hash
            @torrent.info_hash = result['torrent-added']['hashString']
          end
          flash[:notice] = 'Torrent was successfully created.' if @torrent.save
          @torrent.delay.get_details_from_transmission
        end
      end
    end
    
    respond_with @torrent
  end

  # PUT /torrents/1
  # PUT /torrents/1.json
  def update
    @torrent = Torrent.find(params[:id])
    flash[:notice] = 'Torrent was successfully updated.' if @torrent.update_attributes params[:torrent]
    respond_with @torrent
  end

  # DELETE /torrents/1
  # DELETE /torrents/1.json
  def destroy
    @torrent = Torrent.find(params[:id])
    flash[:notice] = 'Torrent was successfuly destroyed' if @torrent.destroy
    respond_with @torrent
  end
  
  private
  def transmission
    @client ||= Transmission::Client.new(AppSettings.transmission_rpc_host, AppSettings.transmission_rpc_port)
  end
end
