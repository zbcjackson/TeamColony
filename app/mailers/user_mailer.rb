class UserMailer < ActionMailer::Base
  default from: "teamcolony@iagile.me"

  def invitation_letter(user, to, message, url)
  	@user = user
  	@url = url
  	@message = message
  	mail(:to => to, :subject => "Invitation to TeamColony")
  end
end
