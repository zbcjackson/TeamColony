class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :invitation_token
  has_secure_password
  validates_presence_of :name, :email, :password, :on => :create
  validates :email, :uniqueness => true

  has_and_belongs_to_many :groups

  has_one :invitation, :class_name => "Invitation", :foreign_key => "recipient_id"
  validate :invitation_is_valid

  after_create :update_invitation

  def invitation_token
  	invitation.token if invitation
  end 

  def invitation_token=(token)
  	self.invitation = Invitation.find_by_token(token)
  end

  def check_invitation
  	invitation and !invitation.recipient_id_was
  end

  private

  def invitation_is_valid
  	errors.add :invitation, "Invitation is not valid." if !check_invitation
  end

  def update_invitation
  	invitation.recipient = self
  	invitation.save
  end
end
