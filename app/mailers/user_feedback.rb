class UserFeedback < ActionMailer::Base
 # default :from => "yogesh.Waghmare@techvalens.com"
#  mail("X-Spam" => value)

  def feedback(email,user_id, message, subject, user_name)
    puts":::::::::::::::::::::::::::::::#{email.inspect}"
    @username = user_id
    @url  = "http://example.com/login"
    mail(:from => email,:to => 'welike.feedback@gmail.com',:message => message, :subject => subject, :name => user_name)
  end

end
