class UserMailer < ActionMailer::Base
  default :from => "weliike.feedback@gmail.com"

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => "welike.feedback@gmail.com", :subject => "Welcome to My Awesome Site")
  end
end
