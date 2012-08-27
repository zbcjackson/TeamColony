class UserMailer < ActionMailer::Base
  default from: "teamcolony@iagile.me"

  def invitation_letter(user, to, message)
  	@user = user
  	@url = "http://beta.iagile.me"
  	@message = message
  	mail(:to => to, :subject => "Invitation to TeamColony")
  end
end
