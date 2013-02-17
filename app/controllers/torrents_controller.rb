class TorrentsController < ApplicationController
  respond_to :json, :html
  
  # GET /torrents
  # GET /torrents.json
  def index
    @torrents = Torrent.includes(:category, :downloaders => [:user]).order('name ASC') .all
    
    live_data = transmission.request('torrent-get', :fields => [:hashString, :status, :rateDownload, :rateUpload, :percentDone])
    
    for t in @torrents
      data = live_data['torrents'].detect { |d| t.info_hash == d['hashString'] }
      if data
        t.status = data['status']
        t.rate_download = data['rateDownload']
        t.rate_upload = data['rateUpload']
        t.percent_done = data['percentDone'] * 100
      end
    end
    
    respond_with @torrents
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

    if params[:torrent][:url].blank?
      file_content = params[:torrent][:file].read
      info = BEncode.load(file_content)['info']
      
      @torrent.name = info['name']
      @torrent.info_hash = Digest::SHA1.hexdigest(info.bencode)
      
      if @torrent.valid?
        result = transmission.torrent_add_file(file_content)
        if result['torrent-added']
          flash[:notice] = 'Torrent was successfully created.' if @torrent.save
          @torrent.delay.get_details_from_transmission
        end
      end
    else
      link = params[:torrent][:url]
      if /magnet\:\?xt=urn\:btih\:([0-9a-zA-Z]+)/ =~ link
        @torrent.info_hash = $1.downcase.length == 32 ? Base32.decode($1).unpack('H*')[0].downcase : $1.downcase
        if @torrent.valid?
          result = transmission.torrent_add_url link
          if result['torrent-added']
            flash[:notice] = 'Torrent was successfully created.' if @torrent.save
            @torrent.delay.get_details_from_transmission
          end
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
  
  def start
    @torrent = Torrent.find(params[:id])
    transmission.torrent_start(@torrent.info_hash)
    flash[:notice] = 'Torrent was successfully started'
    redirect_to :action => 'index'
  end
  
  def stop
    @torrent = Torrent.find(params[:id])
    transmission.torrent_stop(@torrent.info_hash)
    flash[:notice] = 'Torrent was successfully stopped'
    redirect_to :action => 'index'
  end
  
  private
  def transmission
    @client ||= Transmission::Client.new(AppSettings.transmission_rpc_host, AppSettings.transmission_rpc_port)
  end
end
