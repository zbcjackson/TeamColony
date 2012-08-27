class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end

  def profile
    
  end

  def invitation
    UserMailer.invitation_letter(current_user, params[:email], params[:message]).deliver
    redirect_to profile_url, :notice => "Invitation sent!"
  end
  
end
