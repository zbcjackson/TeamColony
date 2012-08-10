class PadsController < ApplicationController
  load_and_authorize_resource
    
  def create
    ether = EtherpadLite.connect(:local, File.new(Rails.configuration.pad_api_key_file))
    group = ether.group "team_colony_1"
    pad = group.pad "team_colony_#{@pad.title}"
    @pad.group_id = group.id
    @pad.pad_id = EtherpadLite::Pad.degroupify_pad_id pad.id
    if @pad.save
      redirect_to @pad, :notice => "New pad has been created."
    else
      redirect_to pads_url, :alert => "Error in creating a pad"
    end
  end
  
  def show
    ether = EtherpadLite.connect(:local, File.new(Rails.configuration.pad_api_key_file))
    @group = ether.group "team_colony_1"
    @ether_pad = @group.pad(@pad.pad_id)
    author = ether.author("team_colony_#{current_user.id}", :name => current_user.name)
    sess = session[:pad_sessions][@group.id] ? ether.get_session(session[:pad_sessions][@group.id]) : @group.create_session(author, 60)
    if sess.expired?
      sess.delete
      sess = @group.create_session(author, 60)
    end
    session[:pad_sessions][@group.id] = sess.id
    # Set the EtherpadLite session cookie. This will automatically be picked up by the jQuery plugin's iframe.
    cookies[:sessionID] = {:value => sess.id}
  end
  
end
