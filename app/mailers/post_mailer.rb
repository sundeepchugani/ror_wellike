class PostMailer < ActionMailer::Base
    default :from => "welike.feedback@gmail.com"
#  mail("X-Spam" => value)

  def post_mailers(email)
    @entity_name = "hi"
    @url  = "http://example.com/login"
   # attachments.inline['photo.png'] = File.read('#{image}')
    mail(:to => email, :subject => "Welcome to My Awesome Site")
  end
end
