class PadController < ApplicationController
  def create
    ether = EtherpadLite.connect(:local, "KLLJbqN8mmbVPDY2J3ecgEE0dvEboELB")
    group = ether.group "team_colony_1"
    pad = group.pad params[:name]
    redirect_to pad, :notice => "New pad has been created."
  end
  
  def show
    ether = EtherpadLite.connect(:local, "KLLJbqN8mmbVPDY2J3ecgEE0dvEboELB")
    @group = ether.group "team_colony_1"
    @pad = @group.pad(params[:padId])
    authorize! :edit, @pad
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
