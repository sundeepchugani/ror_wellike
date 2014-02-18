class FacebookController < ApplicationController

  # Controller & Method Name : Facebook  Controller create method
  # Summary : This method is used to create(Register/login) welike user via facebook A/c.
  # If user not exist in weliike then it will register automatically else its record updated according to latest facebook details.
  # Status : Active.
  # Parameters : user[first_name]= First Name , user[last_name]=Last Name , user[email]= User Email , user[fb_token]= Facebook token, user[facebook_id] = Facebook Id , user[gender] = Gender , user[provider] = facebook , user[name] = Full Name
  # Output : Details of Registered user.
  def create
    puts"::::::::::::::::::::::::::::::::::::::::::#{params.inspect}"
    @facebook = Array.new
    facebook = {}
    if params[:user][:provider]
        @authhash = Hash.new #<..........Comment..... {"email" => '', "name" => '', "uid" =>'',  "provider" =>''} create hash for contain value in same formate
        @authhash[:provider] = params[:user][:provider] or ''
          if params[:user][:provider] == 'facebook'
            @authhash[:email] = params[:user][:email] or ''
            @authhash[:name] =  params[:user][:name] or ''
            @authhash[:first_name] =  params[:user][:first_name] or ''
            @authhash[:last_name] =  params[:user][:last_name] or ''
            @authhash[:gender] =  params[:user][:gender] or ''
            @authhash[:profile_picture] =  params[:user][:profile_picture] or ''
            @authhash[:cover_photo] =  params[:user][:cover_photo] or ''
            @authhash[:facebook_id] =  params[:user][:facebook_id].to_s or ''
          end
        if @authhash[:facebook_id] != '' and @authhash[:provider] != ''
            @auth_service = User.where(:facebook_id => @authhash[:facebook_id]).first
                respond_to do |format|
                  if @auth_service.present? # <..........Comment.....if user is already registerd then the user profile update only.
                      fb = facebook.merge(:user_id =>@auth_service.id , :email=>@auth_service.email,:first_name =>@auth_service.first_name,:last_name => @auth_service.last_name,:facebook_id=>@auth_service.facebook_id,:provider=> @auth_service.provider, :gender => @auth_service.gender,:last_login_time => Time.now, :privacy => @auth_service.privacy,:friend_like_my_activity_for_pn => @auth_service.friend_like_my_activity_for_pn,:friend_like_my_activity_for_mail => @auth_service.friend_like_my_activity_for_mail,  :any_one_like_my_activity_for_pn => @auth_service.any_one_like_my_activity_for_pn ,:any_one_like_my_activity_for_mail => @auth_service.any_one_like_my_activity_for_mail ,:friend_mention_me_in_comment_for_pn => @auth_service.friend_mention_me_in_comment_for_pn,:friend_mention_me_in_comment_for_mail => @auth_service.friend_mention_me_in_comment_for_mail, :any_one_mention_me_in_comment_for_pn =>    @auth_service.any_one_mention_me_in_comment_for_pn ,   :any_one_mention_me_in_comment_for_mail =>  @auth_service.any_one_mention_me_in_comment_for_mail,   :a_friend_follow_my_category_for_pn =>  @auth_service.a_friend_follow_my_category_for_pn ,   :a_friend_follow_my_category_for_mail =>  @auth_service.a_friend_follow_my_category_for_mail,   :any_one_friend_follow_my_category_for_pn =>  @auth_service.any_one_friend_follow_my_category_for_pn ,  :any_one_friend_follow_my_category_for_mail =>   @auth_service.any_one_friend_follow_my_category_for_mail ,  :a_friend_shares_a_place_tip_or_entity_with_me_for_pn  => @auth_service.a_friend_shares_a_place_tip_or_entity_with_me_for_pn ,   :a_friend_shares_a_place_tip_or_entity_with_me_for_mail =>  @auth_service.a_friend_shares_a_place_tip_or_entity_with_me_for_mail ,   :any_one_shares_a_place_tip_or_entity_with_me_for_pn =>  @auth_service.any_one_shares_a_place_tip_or_entity_with_me_for_pn ,   :any_one_shares_a_place_tip_or_entity_with_me_for_mail =>  @auth_service.any_one_shares_a_place_tip_or_entity_with_me_for_mail ,   :i_receive_a_friend_request_of_friend_confirmation_for_pn =>  @auth_service.i_receive_a_friend_request_of_friend_confirmation_for_pn ,  :i_receive_a_friend_request_of_friend_confirmation_for_mail => @auth_service.i_receive_a_friend_request_of_friend_confirmation_for_mail ,  :a_new_friend_from_facebook_join_we_like_for_pn =>   @auth_service.a_new_friend_from_facebook_join_we_like_for_pn,   :keep_me_up_to_date_with_welike_news_and_update_for_pn =>  @auth_service.keep_me_up_to_date_with_welike_news_and_update_for_pn,  :keep_me_up_to_date_with_welike_news_and_update_for_mail =>   @auth_service.keep_me_up_to_date_with_welike_news_and_update_for_mail,   :send_me_weekly_updates_about_whats_my_friends_are_up_to_for_pn =>  @auth_service.send_me_weekly_updates_about_whats_my_friends_are_up_to_for_pn ,   :send_me_weekly_updates_about_whats_my_friends_are_up_to_for_mail =>   @auth_service.send_me_weekly_updates_about_whats_my_friends_are_up_to_for_mail , :geotag_post =>  @auth_service.geotag_post ,:post_are_private => @auth_service.post_are_private ,   :profile_picture_url =>  @auth_service.profile_picture_url,:cover_photo_url => @auth_service.cover_photo_url , :already_exists => "1")
                     @facebook << fb
                     format.json {render :json => @facebook}
                  else
                    @user = User.create # <..........Comment.....if user does not exist then we will create the user.
                    @user.update_attributes(:profile_picture_url => @authhash[:profile_picture], :cover_photo_url =>@authhash[:cover_photo] ,:email=>@authhash[:email],:first_name => @authhash[:first_name],:last_name => @authhash[:last_name],:facebook_id=>@authhash[:facebook_id],:provider=>@authhash[:provider], :gender => @authhash[:gender],:last_login_time => Time.now,@user.privacy => "0", @user.friend_like_my_activity_for_pn => "1", @user.friend_like_my_activity_for_mail => "0",   @user.any_one_like_my_activity_for_pn => "1",@user.any_one_like_my_activity_for_mail => "0", @user.friend_mention_me_in_comment_for_pn => "1",     @user.friend_mention_me_in_comment_for_mail => "1",     @user.any_one_mention_me_in_comment_for_pn => "1",     @user.any_one_mention_me_in_comment_for_mail => "1",     @user.a_friend_follow_my_category_for_pn => "1",     @user.a_friend_follow_my_category_for_mail => "0",     @user.any_one_friend_follow_my_category_for_pn => "1",     @user.any_one_friend_follow_my_category_for_mail => "0",   @user.a_friend_shares_a_place_tip_or_entity_with_me_for_pn  => "1",     @user.a_friend_shares_a_place_tip_or_entity_with_me_for_mail => "0",     @user.any_one_shares_a_place_tip_or_entity_with_me_for_pn => "1",     @user.any_one_shares_a_place_tip_or_entity_with_me_for_mail => "1",     @user.i_receive_a_friend_request_of_friend_confirmation_for_pn => "1",     @user.i_receive_a_friend_request_of_friend_confirmation_for_mail => "1",     @user.a_new_friend_from_facebook_join_we_like_for_pn => "1",     @user.keep_me_up_to_date_with_welike_news_and_update_for_pn => "0",     @user.keep_me_up_to_date_with_welike_news_and_update_for_mail => "1",     @user.send_me_weekly_updates_about_whats_my_friends_are_up_to_for_pn => "0",     @user.send_me_weekly_updates_about_whats_my_friends_are_up_to_for_mail => "1",     @user.save_photo_phone => "1", @user.geotag_post => "1", @user.post_are_private => "0")
                    @user.save
                    @entity_setting = EntitySetting.new
                    @entity_setting.update_attributes(:user_id => @user.id, :sort_by => "Recent", :narrow_by_city => "", :narrow_by_sub_category => "")
                    @entity_setting.save
                    fb = facebook.merge(:user_id => @user.id ,:email=>@user.email,:first_name =>@user.first_name,:last_name => @user.last_name,:facebook_id=>@user.facebook_id,:provider=>@user.provider, :gender => @user.gender,:last_login_time => Time.now, :privacy => @user.privacy,:friend_like_my_activity_for_pn => @user.friend_like_my_activity_for_pn,:friend_like_my_activity_for_mail => @user.friend_like_my_activity_for_mail,  :any_one_like_my_activity_for_pn => @user.any_one_like_my_activity_for_pn ,:any_one_like_my_activity_for_mail => @user.any_one_like_my_activity_for_mail ,:friend_mention_me_in_comment_for_pn => @user.friend_mention_me_in_comment_for_pn,:friend_mention_me_in_comment_for_mail => @user.friend_mention_me_in_comment_for_mail, :any_one_mention_me_in_comment_for_pn =>    @user.any_one_mention_me_in_comment_for_pn ,   :any_one_mention_me_in_comment_for_mail =>  @user.any_one_mention_me_in_comment_for_mail,   :a_friend_follow_my_category_for_pn =>  @user.a_friend_follow_my_category_for_pn ,   :a_friend_follow_my_category_for_mail =>  @user.a_friend_follow_my_category_for_mail,   :any_one_friend_follow_my_category_for_pn =>  @user.any_one_friend_follow_my_category_for_pn ,  :any_one_friend_follow_my_category_for_mail =>   @user.any_one_friend_follow_my_category_for_mail ,  :a_friend_shares_a_place_tip_or_entity_with_me_for_pn  => @user.a_friend_shares_a_place_tip_or_entity_with_me_for_pn ,   :a_friend_shares_a_place_tip_or_entity_with_me_for_mail =>  @user.a_friend_shares_a_place_tip_or_entity_with_me_for_mail ,   :any_one_shares_a_place_tip_or_entity_with_me_for_pn =>  @user.any_one_shares_a_place_tip_or_entity_with_me_for_pn ,   :any_one_shares_a_place_tip_or_entity_with_me_for_mail =>  @user.any_one_shares_a_place_tip_or_entity_with_me_for_mail ,   :i_receive_a_friend_request_of_friend_confirmation_for_pn =>  @user.i_receive_a_friend_request_of_friend_confirmation_for_pn ,  :i_receive_a_friend_request_of_friend_confirmation_for_mail => @user.i_receive_a_friend_request_of_friend_confirmation_for_mail ,  :a_new_friend_from_facebook_join_we_like_for_pn =>   @user.a_new_friend_from_facebook_join_we_like_for_pn,   :keep_me_up_to_date_with_welike_news_and_update_for_pn =>  @user.keep_me_up_to_date_with_welike_news_and_update_for_pn,  :keep_me_up_to_date_with_welike_news_and_update_for_mail =>   @user.keep_me_up_to_date_with_welike_news_and_update_for_mail,   :send_me_weekly_updates_about_whats_my_friends_are_up_to_for_pn =>  @user.send_me_weekly_updates_about_whats_my_friends_are_up_to_for_pn ,   :send_me_weekly_updates_about_whats_my_friends_are_up_to_for_mail =>   @user.send_me_weekly_updates_about_whats_my_friends_are_up_to_for_mail , :geotag_post =>  @user.geotag_post ,:post_are_private => @user.post_are_private ,   :profile_picture_url =>  @user.profile_picture_url,:cover_photo_url => @user.cover_photo_url ,  :already_exists => "0")
                    @facebook << fb
                    format.json {render :json => @facebook}
                     end
               end
         end
      end
   end

 def facebook_friend_counts
    respond_to do |format|
    if params[:provider]== "facebook"
      friends = params[:friends_id].split(",")
      puts"........................................#{friends.inspect}"
        @user = User.where(:facebook_id => params[:facebook_id] ).first
        @friends = friends.collect { |f| User.where(:provider => 'facebook',:facebook_id => f).first }.compact
        format.json {render :json => @friends}
    end
  end
 end
end

#curl -X POST -d "friends_id="558682946,751223367,1068275487,100001776478329,"&provider=facebook&facebook_id=100000056252703&" http://localhost:3000/facebook/facebook_friend_counts.json