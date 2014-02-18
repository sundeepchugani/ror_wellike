class InviteUser < ActionMailer::Base
  # default :from => "welike.feedback@gmail.com"
#  mail("X-Spam" => value)

  def invite_friend(email, friend_name, sender_first_name, sender_last_name)
   


    puts"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#{email}"
    @email = email
    @friend_name = friend_name
    @user_first_name = sender_first_name
    @user_last_name = sender_last_name
    @url  = "http://example.com/login"
   # attachments.inline['photo.png'] = File.read('#{image}')
   mail(:from => "welike.feedback@gmail.com",:to => "#{email}", :subject => "Invite For WeLiike App", :message => "Hi #{@friend_name} , #{@user_first_name}  #{@user_last_name} Invited you for join on WeLiike App")
end

end
