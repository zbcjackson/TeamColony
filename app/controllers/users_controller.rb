class UsersController < ApplicationController
  def new
    @user = User.new(:invitation_token => params[:invitation_token])
    if @user.check_invitation
      @user.email = @user.invitation.recipient_email
    else
      redirect_to root_url, :alert => "Invitation is not valid."
    end
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
    invitation = Invitation.new(:recipient_email => params[:email])
    invitation.sender = current_user
    if (invitation.save)
      url = "#{root_url}signup/#{invitation.token}"
      UserMailer.invitation_letter(current_user, params[:email], params[:message], url).deliver
      redirect_to profile_url, :notice => "Invitation sent!"
    else
      flash[:alert] = invitation.errors.full_messages
      render "profile"
    end

  end
  
end
