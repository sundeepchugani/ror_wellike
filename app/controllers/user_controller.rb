require 'will_paginate/array'
class UserController < ApplicationController
 def create #<-----comment-----create method use for create new user account or sign up with emailid
   puts"_---------------------------------------------------====@#{params.inspect}params.inspect"
    @user = User.new(params[:user])
    if !(params[:cover_photo]).nil?
     cover_photo = (params[:cover_photo]).gsub(" ", "+")
      data = StringIO.new(Base64.decode64(cover_photo))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "#{@user.first_name}.jpg"
      data.content_type = "image/jpg"
      @user.cover_photo = data
      @user.cover_photo_url = @user.cover_photo
      
    end
    if !(params[:profile_picture]).nil?  # <..........Comment..... user have profile picture the responce form the user side is base64 format using this method we convert base64 string into image.
      @prof_pic=(params[:profile_picture]).gsub(" ", "+")
      data = StringIO.new(Base64.decode64(@prof_pic))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "#{@user.first_name}.jpg"
      data.content_type = "image/jpg"
      @user.profile_picture = data
      @user.provider = "email"
      @user.profile_picture_url = @user.profile_picture
   end
      @user.privacy = "0"
      @user.friend_like_my_activity_for_pn = "1"
      @user.friend_like_my_activity_for_mail = "0"
      @user.any_one_like_my_activity_for_pn = "1"
      @user.any_one_like_my_activity_for_mail = "0"
      @user.friend_mention_me_in_comment_for_pn = "1"
      @user.friend_mention_me_in_comment_for_mail = "1"
      @user.any_one_mention_me_in_comment_for_pn = "1"
      @user.any_one_mention_me_in_comment_for_mail = "1"
      @user.a_friend_follow_my_category_for_pn ="1"
      @user.a_friend_follow_my_category_for_mail = "0"
      @user.any_one_friend_follow_my_category_for_pn = "1"
      @user.any_one_friend_follow_my_category_for_mail = "0"
      @user.a_friend_shares_a_place_tip_or_entity_with_me_for_pn = "1"
      @user.a_friend_shares_a_place_tip_or_entity_with_me_for_mail = "0"
      @user.any_one_shares_a_place_tip_or_entity_with_me_for_pn = "1"
      @user.any_one_shares_a_place_tip_or_entity_with_me_for_mail = "1"
      @user.i_receive_a_friend_request_of_friend_confirmation_for_pn = "1"
      @user.i_receive_a_friend_request_of_friend_confirmation_for_mail = "1"
      @user.a_new_friend_from_facebook_join_we_like_for_pn = "1"
      @user.keep_me_up_to_date_with_welike_news_and_update_for_pn = "0"
      @user.keep_me_up_to_date_with_welike_news_and_update_for_mail ="1"
      @user.send_me_weekly_updates_about_whats_my_friends_are_up_to_for_pn = "0"
      @user.send_me_weekly_updates_about_whats_my_friends_are_up_to_for_mail = "1"
      @user.save_photo_phone = "1"
      @user.geotag_post ="1"
      @user.post_are_private = "0"

    
      respond_to do |format|
    if @user.save
      @entity_setting = EntitySetting.new
      @entity_setting.update_attributes(:user_id => @user.id, :sort_by => "Recent", :narrow_by_city => "", :narrow_by_sub_category => "")
      @entity_setting.save
      format.json {render :json => @user}
    else
      format.json {render :json => @user.errors}
     end

    end
  end

  def update
    @user = User.where(:id => params[:user_id]).first
    @user.update_attributes(params[:user])
     if params[:cover_photo]
      cover_photo = (params[:cover_photo]).gsub(" ", "+")
      data = StringIO.new(Base64.decode64(cover_photo))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "cover photo.jpg"
      data.content_type = "image/jpg"
      @user.cover_photo = data
      @user.cover_photo_url = @user.cover_photo
    end
    if params[:profile_picture]
      pic = (params[:profile_picture]).gsub(" ", "+")
      data = StringIO.new(Base64.decode64(pic))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "profile photo.jpg"
      data.content_type = "image/jpg"
      @user.profile_picture = data
      @user.profile_picture_url = @user.profile_picture
    end
    
    respond_to do |format|
    if @user.save
      format.json {render :json => @user}
    else
      format.json {render :json => @user.errors}
    end
    end
  end

  
  def update_notifications
    @user = User.where(:id => params[:user][:user_id]).first
    @user.update_attributes(params[:user])
    respond_to do |format|
    if @user.save
      format.json {render :json => @user}
    else
      format.json {render :json => @user.errors}
    end
    end
  end
  def change_password
    user = User.authenticate_password(params[:email], params[:password])
    respond_to do |format|
      if user.present?
       user.update_attributes(params[:change])
      if user.save
        
        format.json {render :json => {:message => "Your Password is successfully Updated"}}
      end
    else
      format.json {render :json => {:message => "Your Password does not match"}}
      end
    end
  end



 def other_user
   user = {}
  category = {}
  groups = {}
   @user = Array.new
   @categories = Array.new
   @group = Array.new
   @users = User.where(:id => params[:other_user_id]).first
   @user_categorise = UserCategory.where(:user_id => @users.id)
   @user_categorise.each do |user_cate|
     @master_cat = MasterCategory.where(:id => user_cate.master_category_id )
     @master_cat.each do |catename|
       cate = category.merge(:category_name => catename.category_name, :category_image => catename.category_image, :user_category_id => user_cate.id, :master_category_id => catename.id)
       @categories << cate
     end
  end
   @user_groups = Group.where(:group_owner_id => @users.id)
   @user_groups.each do |user_group|
     group = groups.merge(:_id => user_group.id, :group_name => user_group.group_name, :group_image_url => user_group.group_image_url)
     @group << group
   end
   @user_rela = Relatoinship.where(:user_id => params[:user_id], :friend_user_id => params[:other_user_id]).first
   if @user_rela.present?
     user_data = user.merge(:user_id => @users.id, :email => @users.email, :user_name => @users.first_name, :cover_photo => @users.cover_photo_url, :profile_picture => @users.profile_picture_url, :is_friend => "YES")
   @user << user_data
   else
     user_data = user.merge(:user_id => @users.id, :email => @users.email, :user_name => @users.first_name, :cover_photo => @users.cover_photo_url, :profile_picture => @users.profile_picture_url, :is_friend => "NO")
   @user << user_data

   end
   respond_to do |format|
     format.json {render :json => {:users  => @user , :category => @categories, :group => @group}}
   end
 end


 def peoples
   people = {}
   @people = Array.new
   @us = Array.new
   @peo = Array.new
    respond_to do |format|
   @user_relesions = Relatoinship.where(:user_id => params[:user_id], :is_active => "true")
   @user_relesions.each do |user_relations|
     @peo << user_relations.friend_user_id
   end
   @people_friend = @peo.uniq
   @people_friend.each do |friends_id|
     @user = User.where(:id => friends_id).uniq{|p| p.id && p.first_name}
     @user.each do |user|
       pepel = people.merge(:friend_user_id => user.id, :profile_picture => user.profile_picture_url, :cover_photo => user.cover_photo_url, :user_name => user.first_name, :status => "YES")
       @people << pepel
     end
   end
   arrays = @people.sort{|a,b| [a[:friend_user_id]] <=> [b[:friend_user_id]]} && @people.sort_by { |k| k["user_name"]}
   if !arrays.blank?
      format.json {render :json => arrays}
   else
      format.json {render :json => {:message => "There is no data"}}
   end
 end
 end
 
 def user_feed
   @entity = Array.new
   entity = {}
   post = {}
   @posts = Array.new
   @CategoryPosts = Array.new
   @rating = Array.new
   entities ={}
   @cat = Array.new
   @master = Array.new
   @category = Array.new
   @users = User.where(:id => params[:user_id]).first
           @user_entity = UserEntity.where( :user_id => params[:user_id],:is_public => "true").order_by(:created_at => "desc").uniq{|p| p.id}.paginate(:page => params[:page], :per_page => 10)
         @user_entity.each do |user_entity|

           @comments = Comment.where(:user_entity_id => user_entity.id)
           ue = user_entity.id
           @ratings = Rating.where(:user_entity_id =>  ue.to_s )
       @user_categoriess = UserCategory.where(:id => user_entity.user_category_id)
       @user_categoriess.each do |ca|
         @master_cat = MasterCategory.where(:id => ca.master_category_id)
         @master_cat.each do |master|
           start_time =  user_entity.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
           @catee_user = UserCategory.where(:user_id => params[:user_id], :master_category_id => master.id).first
                         if @catee_user.present?
if user_entity.comment.nil?
                            @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                            if @user_e.present?
                               @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                               @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                               if @like.present?
                                  enty = entity.merge(:time => @times, :own_category_id => @catee_user.id,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                               else
                                  enty = entity.merge(:time => @times, :own_category_id => @catee_user.id,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                                end
                             else
                                  enty = entity.merge(:time => @times, :own_category_id => @catee_user.id,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                             end
                           else
                             cd4 =  Comment.comment_text(user_entity.comment, user_entity.user_id,user_entity.id)
                            cd5 = cd4.join(" ")
                              @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                            if @user_e.present?
                               @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                               @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                               if @like.present?
                                 enty = entity.merge(:time => @times, :own_category_id => "",:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                               else
                                  enty = entity.merge(:time => @times, :own_category_id => "",:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                                end
                             else
                                  enty = entity.merge(:time => @times, :own_category_id => "",:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                             end
                           end
                         end
       end
         end ### user entity end
         end
  @entity.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]} && @entity.sort_by! { |thing| thing["created_at"] }
    ##@entity.sort_by! { |thing| thing["created_at"] }
   # @results = Kaminari.paginate_array(@entity).page(params[:page]).per(20)
     respond_to do |format|
       format.json {render :json => @entity}
     end
end



  def friend_feed
   @entity = Array.new
   entity = {}
   post = {}
   @posts = Array.new
   @CategoryPosts = Array.new
   @rating = Array.new
   entities ={}
   @cat = Array.new
   @master = Array.new
   @category = Array.new
   @users = User.where(:id => params[:friend_user_id]).first
           @user_entity = UserEntity.where( :user_id => params[:friend_user_id],:is_active => "true").order_by(:created_at => "desc").uniq{|p| p.id}
         @user_entity.each do |user_entity|

           @comments = Comment.where(:user_entity_id => user_entity.id)
           ue = user_entity.id
           @ratings = Rating.where(:user_entity_id =>  ue.to_s )
      start_time =  user_entity.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
       @user_categoriess = UserCategory.where(:id => user_entity.user_category_id)
       @user_categoriess.each do |ca|
         @master_cat = MasterCategory.where(:id => ca.master_category_id)
         @master_cat.each do |master|
           @catee_user = UserCategory.where(:user_id => params[:user_id], :master_category_id => master.id).first
                         if @catee_user.present?
                           @user_category_rela = UserCategoryRelation.where(:user_id => params[:user_id], :friend_user_id =>  params[:friend_user_id] , :user_category_id => @catee_user.id,:is_active => "true").first
                           if @user_category_rela.present?
                              if user_entity.comment.nil?
                            @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                            if @user_e.present?
                               @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                               @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                               if @like.present?
                                  enty = entity.merge(:time => @times,:is_like=>"Yes",:own_category_id => @catee_user.id,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                               else
                                  enty = entity.merge(:time => @times,:is_like=>"No",:own_category_id => @catee_user.id,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                                end
                             else
                                  enty = entity.merge(:time => @times,:is_like=>"No",:own_category_id => @catee_user.id,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                             end
                           else
                             cd4 =  Comment.comment_text(user_entity.comment, user_entity.user_id,user_entity.id)
                            cd5 = cd4.join(" ")
                              @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                            if @user_e.present?
                               @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                               @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                               if @like.present?
                                 enty = entity.merge(:time => @times,:is_like=>"Yes",:own_category_id => @catee_user.id ,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                               else
                                  enty = entity.merge(:time => @times,:is_like=>"No",:own_category_id => @catee_user.id ,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                                end
                             else
                                  enty = entity.merge(:time => @times,:is_like=>"No",:own_category_id => @catee_user.id ,:is_follow_category => "Yes",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                             end
                           end
                           else
                              if user_entity.comment.nil?
                            @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                            if @user_e.present?
                               @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                               @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                               if @like.present?
                                  enty = entity.merge(:time => @times,:is_like=>"Yes",:own_category_id => @catee_user.id,:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                               else
                                  enty = entity.merge(:time => @times,:is_like=>"No",:own_category_id => @catee_user.id,:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                                end
                             else
                                  enty = entity.merge(:time => @times,:is_like=>"No",:own_category_id => @catee_user.id,:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                             end
                           else
                             cd4 =  Comment.comment_text(user_entity.comment, user_entity.user_id,user_entity.id)
                            cd5 = cd4.join(" ")
                              @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                            if @user_e.present?
                               @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                               @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                               if @like.present?
                                 enty = entity.merge(:time => @times,:is_like=>"Yes",:own_category_id => @catee_user.id ,:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                               else
                                  enty = entity.merge(:time => @times,:is_like=>"No",:own_category_id => @catee_user.id ,:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                                end
                             else
                                  enty = entity.merge(:time => @times,:is_like=>"No",:own_category_id => @catee_user.id ,:is_follow_category => "No",:like_count => @user_e.count,:city => user_entity.city, :xcody => user_entity.xcody, :ycody => user_entity.ycody,:rating_count => user_entity.rating_count,:master_category_id => master.id,:mastet_category_name => master.category_name,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category,:comment_count => @comments.count,:user_entity_id => user_entity.id,:user_id => user_entity.user_id,:profile_picture => @users.profile_picture_url,:user_name => @users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image)
                                  en = entities.merge(:entity_info => enty,:created_at => user_entity.created_at)
                                  @entity.push(en)
                             end
                           end
                           end
                         
                         end
       end
         end ### user entity end
         end
@entity.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]} && @entity.sort_by! { |thing| thing["created_at"] }
  #  @entity.sort_by! { |thing| thing["created_at"] }
    @results = Kaminari.paginate_array(@entity).page(params[:page]).per(10)
     respond_to do |format|
       format.json {render :json => @results.uniq}
     end
end

 def news_feed
      posts = {}
      postsss = {}
      @posts = Array.new
      self_user = Array.new
      entity = {}
      entities = {}
      @catt =  Array.new
      @fr_end = Array.new
      @entity = Array.new
      @en = Array.new
      @en11 = Array.new
      @master_cat = Array.new
      @user_relations = Array.new
      @category = Array.new
      @master_cate = Array.new
      @oth_cat = Array.new
      @catedd = Array.new
      @arr_hash_cat = Array.new
      @s =  Array.new
      fr4 = {}
             @user_category_relationships = UserCategoryRelation.where(:user_id => params[:user_id],:is_active => "true").excludes(:friend_user_id => params[:user_id] )#.uniq{|p| p.user_id && p.friend_user_id}
             @user_category_relationships.each do |user_relation|
                 @user_relations << user_relation.friend_user_id
                # @catedd << user_relation.user_category_id
                 @us = UserCategory.where(:id => user_relation.user_category_id)

                    @cdd = fr4.merge(:master_id => user_relation.master_category_id, :user_id => user_relation.friend_user_id)
                    @catedd << @cdd
             end
             @catedd.each do | (key, value) |
               @user_category_last = UserCategory.where(:master_category_id => key[:master_id], :user_id => key[:user_id])
               @user_category_last.each do |user_category_id|
                 @category << user_category_id.id
              end

             end
             @entity_users = UserEntity.in(:user_category_id => @category.uniq).where(:is_active => "true",:is_public => "true").order_by(:created_at => "desc")
             @entity_users.each do |user_entity|
               start_time =  user_entity.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
                @user_other_cate = UserCategory.where(:id => user_entity.user_category_id)
                @user_other_cate.each do |for_master|
                    @master_other_fr = MasterCategory.where(:id => for_master.master_category_id)
                    @master_other_fr.each do |master|
                      @comments = Comment.where(:user_entity_id => user_entity.id)
                      @users = User.where(:id => user_entity.user_id)
                      @users.each do |users|
                         @catee_user = UserCategory.where(:user_id => params[:user_id], :master_category_id => master.id).first
                         if @catee_user.present?
                           if user_entity.comment.nil?
                            @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                            if @user_e.present?
                               @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                               @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                               if @like.present?
                                  enty = posts.merge(:time => @times,:own_category_id => @catee_user.id,:is_follow_category => "Yes",:xcody =>user_entity.xcody, :ycody => user_entity.ycody, :like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"Yes",:city =>user_entity.city,:master_category_id => master.id, :mastet_category_name => master.category_name,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                                 
                                #  @posts.push(en)
                               else
                                  enty = posts.merge(:time => @times,:own_category_id => @catee_user.id,:is_follow_category => "Yes",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:master_category_id => master.id, :mastet_category_name => master.category_name,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                                  
                               #   @posts.push(en)
                                end
                             else
                                  enty = posts.merge(:time => @times,:own_category_id => @catee_user.id,:is_follow_category => "Yes",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:master_category_id => master.id, :mastet_category_name => master.category_name,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                                 
                                 # @posts.push(en)
                             end
                             @posts.push(enty)
                           else
                             cd4 =  Comment.comment_text(user_entity.comment, user_entity.user_id,user_entity.id)
                            cd5 = cd4.join(" ")
                              @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                            if @user_e.present?
                               @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                               @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                               if @like.present?
                                 enty = posts.merge(:time => @times,:own_category_id => @catee_user.id,:is_follow_category => "Yes",:xcody =>user_entity.xcody, :ycody => user_entity.ycody, :like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"Yes",:city =>user_entity.city,:master_category_id => master.id, :mastet_category_name => master.category_name,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                                  
                                  #@posts.push(en)
                               else
                                  enty = posts.merge(:time => @times,:own_category_id => @catee_user.id,:is_follow_category => "Yes",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:master_category_id => master.id, :mastet_category_name => master.category_name,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                                 
                                 # @posts.push(en)
                                end
                             else
                                  enty = posts.merge(:time => @times,:own_category_id => @catee_user.id,:is_follow_category => "Yes",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:master_category_id => master.id, :mastet_category_name => master.category_name,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                                  
                                 # @posts.push(en)
                             end
                             @posts.push(enty)
                           end

                            end
                         end
                      end
                  end
              end

      @other_friend = Relatoinship.where(:user_id => params[:user_id],:is_active => "true")#.uniq{|p| p.user_id && p.friend_user_id}
      @other_friend.each do |other_fr|
          @fr_end << other_fr.friend_user_id
        end
        

          @user_other_catec = UserCategory.in(:user_id => @fr_end)
            @user_other_catec.each do |fo_master|
              @oth_cat << fo_master.id
              end
              @cmm = @oth_cat - @category
              @cmm.uniq
              @user_other_cat = UserCategory.in(:id => @cmm)
              @user_other_cat.each do |for_master|
                @en11 << for_master.id
                 end
 
        
                
     @entity_other = UserEntity.in(:user_category_id => @en11).where(:is_active => "true",:is_public => "true").order_by(:created_at => "desc")
         @entity_other.each do |user_entity|
           start_time =  user_entity.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
           @user_other_cats = UserCategory.where(:id => user_entity.user_category_id, :is_active => "true")
              @user_other_cats.each do |for_master|
@master_other_frs = MasterCategory.where(:id => for_master.master_category_id)
                @master_other_frs.each do |master|

                   @comments = Comment.where(:user_entity_id => user_entity.id)
                   @users = User.where(:id => user_entity.user_id)
                   @users.each do |users|
                      @cat_user = UserCategory.where(:user_id => params[:user_id], :master_category_id => master.id).first
                      if user_entity.comment.nil?
                        if @cat_user.present?
                         @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                         if @user_e.present?
                            @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                            @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                            if @like.present?
                               enty = entity.merge(:time => @times,:own_category_id => @cat_user.id,:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody, :like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"Yes",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                              
                              # @entity.push(en)
                            else
                               enty = entity.merge(:time => @times,:own_category_id => @cat_user.id,:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                               
                             #  @entity.push(en)
                            end
                          else
                              enty = entity.merge(:time => @times,:own_category_id => @cat_user.id,:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                              
                           #  @entity.push(en)
                          end
                           @entity.push(enty)
                      else
                        @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                         if @user_e.present?
                            @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                            @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                            if @like.present?
                               enty = entity.merge(:time => @times,:own_category_id => "",:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody, :like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"Yes",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                               
                              # @entity.push(en)
                            else
                               enty = entity.merge(:time => @times,:own_category_id => "",:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                               
                               #@entity.push(en)
                            end
                          else
                              enty = entity.merge(:time => @times,:own_category_id => "",:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => user_entity.comment,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                             
                            #  @entity.push(en)
                          end
                           @entity.push(enty)
                      end
                      else
                        cd4 =  Comment.comment_text(user_entity.comment, user_entity.user_id,user_entity.id)
                            cd5 = cd4.join(" ")
                        if @cat_user.present?
                         @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                         if @user_e.present?
                            @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                            @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                            if @like.present?
                               enty = entity.merge(:time => @times,:own_category_id => @cat_user.id,:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody, :like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"Yes",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)

                               #@entity.push(en)
                            else
                               enty = entity.merge(:time => @times,:own_category_id => @cat_user.id,:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
             
                              # @entity.push(en)
                            end
                          else
                              enty = entity.merge(:time => @times,:own_category_id => @cat_user.id,:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                             
                             
                          end
                           @entity.push(enty)
                      else
                        @user_e = ILiikes.where(:user_entity_id => user_entity.id,:is_liikes => "true")
                         if @user_e.present?
                            @like = ILiikes.where(:user_id => params[:user_id] , :user_entity_id => user_entity.id,:is_liikes => "true")
                            @like_count = ILiikes.where(:user_entity_id => user_entity.id)
                            if @like.present?
                               enty = entity.merge(:time => @times,:own_category_id => "",:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody, :like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"Yes",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                               
                             #  @entity.push(en)
                            else
                               enty = entity.merge(:time => @times,:own_category_id => "",:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                              
                             # @entity.push(en)
                            end
                          else
                              enty = entity.merge(:time => @times,:own_category_id => "",:master_category_id =>master.id, :mastet_category_name => master.category_name,:is_follow_category => "No",:xcody =>user_entity.xcody, :ycody => user_entity.ycody,:like_count => @user_e.count,:comment_count =>@comments.count,:is_like=>"No",:city =>user_entity.city,:user_entity_id => user_entity.id, :user_id => user_entity.user_id,:profile_picture => users.profile_picture_url,:user_name => users.first_name,:user_category_id => user_entity.user_category_id, :address => user_entity.address, :comment => cd5,:entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image,:rating_count => user_entity.rating_count,:created_at => user_entity.created_at,:sub_category => user_entity.sub_category)
                              
                             # @entity.push(en)
                          end
                           @entity.push(enty)
                      end
                      end
                    end
                end
                end
              end

   @things =  @entity + @posts
@things.each do |th|
  @timsss = th[:created_at].strftime("%d %b. %Y  %H:%M")
  @s1 = entities.merge(:time => th[:time],:own_category_id => th[:own_category_id],:master_category_id =>th[:master_category_id], :mastet_category_name => th[:mastet_category_name],:is_follow_category => th[:is_follow_category],:xcody =>th[:xcody], :ycody => th[:ycody],:like_count => th[:like_count],:comment_count =>th[:comment_count],:is_like =>th[:is_like],:city =>th[:city],:user_entity_id => th[:user_entity_id], :user_id =>th[:user_id],:profile_picture => th[:profile_picture],:user_name => th[:user_name],:user_category_id => th[:user_category_id], :address =>th[:address], :comment => th[:comment],:entity_name => th[:entity_name], :entity_image => th[:entity_image],:rating_count => th[:rating_count],:created_at => th[:created_at],:sub_category => th[:sub_category])
  @s<< postsss.merge(:times =>  @timsss,:entity_info => @s1 )
end
tmp = @s.find_all { |e| e and e[:times] }
my_array = tmp.uniq.sort_by { |obj| obj[:times] }.reverse
    @results = Kaminari.paginate_array(my_array).page(params[:page]).per(10)
     respond_to do |format|
       format.json {render :json =>  @results}#.paginate(:page => params[:page], :per_page => 10) }
     end
 end



 def friend_search
      friends = {}
      @friends = Array.new
      @user_relesion = Relatoinship.where(:user_id => params[:user_id])
      @user_relesion.each do |relations|
        @users = User.where(:id => relations.friend_user_id, :first_name=>/.*#{params[:entity][:char]}*./i)
        @users.each do |user|
          fr = friends.merge(:user_name => user.first_name, :profile_picture => user.profile_picture_url, :user_id => user.id)
          @friends << fr
        end
      end
      respond_to do |format|
        if !@friends.blank?
          format.json {render :json => @friends}
        end
        format.json {render :json => {:message => "There is no friend"}}
      end
    end

    def add_facebook_id
      @user = User.where(:id => params[:user_id]).first
      @user.update_attributes(:facebook_id => params[:facebook_id])
      respond_to do |format|
        if @user.save
          format.json {render :json => {:message => "Save Facebook Id"}}
        else
          format.json {render :json => {:message => "Error"}}
        end
      end
   end

def search_friend_on_people
  
  people = {}
  @po = Array.new
   @people = Array.new
   @peo1 = Array.new
   @us = Array.new
   @peo = Array.new
    respond_to do |format|
   @user_relesions = Relatoinship.where(:user_id => params[:user_id], :is_active => "true")
   @user_relesions.each do |user_relations|
     @peo << user_relations.friend_user_id
   end
   @people_friend = @peo.uniq
   @people_friend.each do |friends_id|
     @user = User.where(:id => friends_id,:first_name =>/.*#{params[:user_name][:char]}*./i )
     @user.each do |user|
       pepel = people.merge(:user_id => user.id,:friend_user_id => user.id, :profile_picture => user.profile_picture_url, :cover_photo => user.cover_photo_url, :user_name => user.first_name, :status => "YES")
       @people << pepel
       @po << user.id
     end
   end
       @users = User.all
     @users.each do |users|
       @peo1 << users.id
     end
     cd = (@peo1 - @po)
     @user = User.in(:id => cd).where(:first_name =>/.*#{params[:user_name][:char]}*./i )
     @user.each do |us|
        pepel = people.merge(:user_id => us.id,:friend_user_id => us.id, :profile_picture => us.profile_picture_url, :cover_photo => us.cover_photo_url, :user_name => us.first_name, :status => "NO")
        @people << pepel
     end
  
   arrays = @people.sort{|a,b| [a[:friend_user_id]] <=> [b[:friend_user_id]]} && @people.sort_by { |k| k["user_name"]}

     if arrays.blank?
       format.json {render :json => {:message => "There is no Friend" } }
     else
       format.json {render :json => arrays}
     end
      end
   end


def delete_user
  @userss = Comment.where(:user_id => params[:user_id])
  respond_to do |format|
  if @userss.present?
    @userss.each do |cat|
      cat.destroy
    end
    format.json {render :json => {:message => "Deleted"}}
  else
    format.json {render :json => {:message => "Error"}}
  end
  end
end

def ago_time_for
  start_time =  "2013-10-24T14:38:59.157Z"
  end_time   =  Time.now
   @final =  distance_of_time_in_words(start_time, end_time)
   #@times = time_ago_in_words(Time.now - @tim)

 puts"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#{@final.inspect}"
end
def time_ago_in_words(from_time, include_seconds_or_options = {})
  distance_of_time_in_words(from_time, Time.now, include_seconds_or_options)
end


def distance_of_time_in_words(from_time, to_time = 0, include_seconds_or_options = {}, options = {})
  if include_seconds_or_options.is_a?(Hash)
    options = include_seconds_or_options
  else
    ActiveSupport::Deprecation.warn "distance_of_time_in_words and time_ago_in_words now accept :include_seconds " +
                                    "as a part of options hash, not a boolean argument"
    options[:include_seconds] ||= !!include_seconds_or_options
  end

  options = {
    :scope => :'datetime.distance_in_words'
  }.merge!(options)

  from_time = from_time.to_time if from_time.respond_to?(:to_time)
  to_time = to_time.to_time if to_time.respond_to?(:to_time)
  from_time, to_time = to_time, from_time if from_time > to_time
  distance_in_minutes = ((to_time - from_time)/60.0).round
  distance_in_seconds = (to_time - from_time).round

  I18n.with_options :locale => options[:locale], :scope => options[:scope] do |locale|
    case distance_in_minutes
      when 0..1
        return distance_in_minutes == 0 ?
               locale.t(:less_than_x_minutes, :count => 1) :
               locale.t(:x_minutes, :count => distance_in_minutes) unless options[:include_seconds]

        case distance_in_seconds
          when 0..4   then locale.t :less_than_x_seconds, :count => 5
          when 5..9   then locale.t :less_than_x_seconds, :count => 10
          when 10..19 then locale.t :less_than_x_seconds, :count => 20
          when 20..39 then locale.t :half_a_minute
          when 40..59 then locale.t :less_than_x_minutes, :count => 1
          else             locale.t :x_minutes,           :count => 1
        end

      when 2...45           then locale.t :x_minutes,      :count => distance_in_minutes
      when 45...90          then locale.t :about_x_hours,  :count => 1
      # 90 mins up to 24 hours
      when 90...1440        then locale.t :about_x_hours,  :count => (distance_in_minutes.to_f / 60.0).round
      # 24 hours up to 42 hours
      when 1440...2520      then locale.t :x_days,         :count => 1
      # 42 hours up to 30 days
      when 2520...43200     then locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
      # 30 days up to 60 days
      when 43200...86400    then locale.t :about_x_months, :count => (distance_in_minutes.to_f / 43200.0).round
      # 60 days up to 365 days
      when 86400...525600   then locale.t :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
      else
        if from_time.acts_like?(:time) && to_time.acts_like?(:time)
          fyear = from_time.year
          fyear += 1 if from_time.month >= 3
          tyear = to_time.year
          tyear -= 1 if to_time.month < 3
          leap_years = (fyear > tyear) ? 0 : (fyear..tyear).count{|x| Date.leap?(x)}
          minute_offset_for_leap_year = leap_years * 1440
          # Discount the leap year days when calculating year distance.
          # e.g. if there are 20 leap year days between 2 dates having the same day
          # and month then the based on 365 days calculation
          # the distance in years will come out to over 80 years when in written
          # english it would read better as about 80 years.
          minutes_with_offset = distance_in_minutes - minute_offset_for_leap_year
        else
          minutes_with_offset = distance_in_minutes
        end
        remainder                   = (minutes_with_offset % 525600)
        distance_in_years           = (minutes_with_offset.div 525600)
        if remainder < 131400
          locale.t(:about_x_years,  :count => distance_in_years)
        elsif remainder < 394200
          locale.t(:over_x_years,   :count => distance_in_years)
        else
          locale.t(:almost_x_years, :count => distance_in_years + 1)
        end
    end
  end
end
end
# curl -X POST -d "user_id=51419daef7e4f31bea000032" http://localhost:3000/user/peoples.json
# curl -X POST -d "user_id=51419daef7e4f31bea000032" http://localhost:3000/user/add_facebook_id.json
