require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "the truth" do
    user = User.first
 
    # Send the email, then test that it got queued
    email = UserMailer.invitation_letter(user).deliver
    assert !ActionMailer::Base.deliveries.empty?
  end
end
