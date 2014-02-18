class FeedbackController < ApplicationController
   def feedback_user
     @feedback = UserFeedback.feedback(params[:email],params[:user_id],params[:message],params[:subject],params[:user_name])
     respond_to do |format|
     if  @feedback.deliver
       format.json {render :json => {:message => "Feedback"}}
     else
       format.json {render :json => {:errors => "Some error during mail"}}
    end

     end
  end


   def invite_user
      @users = User.where(:id => params[:user_id]).first
      @emails = params[:email].split(",")
      respond_to do |format|
        @emails.each do |emailss|
          @invitaions = Invitations.where(:user_id => params[:user_id], :email_id => emailss)
          @invite_user = InviteUser.invite_friend(emailss, params[:friend_name], @users.first_name, @users.last_name).deliver
          if @invitaions.present?
          else
            @invitaions_first = Invitations.new
            @invitaions_first.update_attributes(:status => "1", :user_id => params[:user_id], :email_id => emailss, :providers => "email")
            @invitaions_first.save
          end
        
       end
      format.json {render :json => {:message => "Invite User Successfully"}}
     end
   end
end
##  curl -X POST -d "email=yogesh.waghmare@techvalens.com&user_id=511b3957158e4d92c900000f&friend_name=Deepak" http://localhost:3000/feedback/invite_user.json