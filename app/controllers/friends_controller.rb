require 'will_paginate/array'
class FriendsController < ApplicationController
  # Controller & Method Name : Friends  Controller create method
  # Summary : This method used to Add friend by facebook_id. This method also create Relationship between user & Friends via user_id & feiends_id and status.
  # Status : Active.
  # Parameters :friends[friends_id] = User Id of User table , friends[provider] = facebook , friends[facebook_id] =  facebook_ids comma saperated
  # Output : Add Your Friens

  def add_friend_form_facebook_and_email
    respond_to do |format|
    if params[:email] == "1"
      email_friends = params[:email_friend_id].split(",")
      email_friends.each do |i|
        @user_sw = User.where(:email => i)
        if @user_sw.present?
          @user_sw.each do |users|
             @friend = Relatoinship.new #.......create the relation between two users relesionship model contain user_id, friends_id, status.
             @friend.user_id = params[:user_id]
             @friend.friend_user_id = users.id
             @friend.status = "follow"
             @friend.is_active = "1"
             @friend.save
          end
          format.json {render :json => {:message => "Add friend successfully"} }
        else
         format.json {render :json => {:message => "There is no Friends"} }
        end
    end
    else
    friends = params[:facebook_friend_id].split(",")
    friends.each do |i|
      @userws = User.where(:facebook_id =>i)
      if @userws.present?
         @userws.each do |users|
             @friend = Relatoinship.new #.......create the relation between two users relesionship model contain user_id, friends_id, status.
             @friend.user_id = params[:user_id]
             @friend.friend_user_id = users.id
             @friend.status = "follow"
             @friend.is_active = "1"
             @friend.save
          end
          format.json {render :json => {:message => "Add friend successfully"} }
        else
         format.json {render :json => {:message => "There is no Friends"} }
      end
             
    end
    if !@friend.blank?
       format.json {render :json => {:message => "Add friend successfully"} }
     else
       format.json {render :json => {:message => "There is no Friends"} }
     end
    
    end
    
    end
 end

  def create
      @facebook = Array.new
      facebook = {}
      respond_to do |format|
    if params[:friends][:provider]== "facebook"
      friends = params[:friends][:friends_id].split(",")
        @user = User.where(:facebook_id => params[:friends][:facbook_id_id] ).first
        @friends = friends.collect { |f| User.where(:provider => 'facebook',:facebook_id => f).first}.compact
        @friends.each do |i|
          @user_relation = Relatoinship.where(:user_id => params[:user_id], :friend_user_id => i.id)
          if @user_relation.present?
            fb_friend = facebook.merge(:user_id => i.id, :profile_picture_url => i.profile_picture_url, :user_name => i.first_name, :facebook_id => i.facebook_id, :is_friend => "YES")
            @facebook << fb_friend
          else
            fb_friend = facebook.merge(:user_id => i.id, :profile_picture_url => i.profile_picture_url, :user_name => i.first_name, :facebook_id => i.facebook_id, :is_friend => "NO")
          @facebook << fb_friend
          end
        end
       end
        if !@facebook.blank?
           format.json {render :json => @facebook }
         else
           format.json {render :json => {:status => "There is no Friends"} }
         end
  end
  end

  def email_friends
    respond_to do |format|
    emails = {}
    @emails = Array.new
    @emails_v = Array.new
    if params[:friends][:provider] == "email"
      email_friend = params[:friends][:friends_email].split(",")
      @user = User.where(:email => params[:friends][:email] ).first
      @friends_email = email_friend.collect { |f| User.where(:provider => 'email',:email => f).first }.compact
      @friends_email.each do |i|
         @user_relation = Relatoinship.where(:user_id => params[:user_id], :friend_user_id => i.id,:is_active => "true")
         if @user_relation.present?
           email = emails.merge(:user_id => i.id, :profile_picture_url => i.profile_picture_url, :user_name => i.first_name, :email => i.email, :is_friend => "YES",:is_active => "1")
           @emails << email
         else
           email = emails.merge(:user_id => i.id, :profile_picture_url => i.profile_picture_url, :user_name => i.first_name, :email => i.email, :is_friend => "NO")
           @emails << email
         end
      end
       if !@emails.blank?
          format.json {render :json => @emails }
       else
         format.json {render :json => {:message => "There is no friend"} }
       end
    end
   end
  end

    # Controller & Method Name : Friends  Controller create method
    # Summary : This method used to Add friend by email_friends. This method also create Relationship between user & Friends via user_id & feiends_id and status.
    # Status : Active.
    # Parameters : friends[email] = User Email  of User table , friends[provider] = email , friends[friends_email] = List of Email ids comma saperated.
    # Output : Add Your Friens in json
    

    # Controller & Method Name : Friends  Controller category_friends method
    # Summary : This method used to follow Master categories automatically when user add friend by email_id.
    # Status : Active.
    # Parameters : friends[email] = User Email  of User table , friends[provider] = email , friends[friends_email] = List of Email ids comma saperated.
    # Output :  Add Friend Successfully in json
#    def category_friends
#      user_cat = params[:user_category_id].split(",")
#      friends = (params[:friend_user_id]).split(",")
#      respond_to do |format|
#        user_cat.each do |cat|
#         friends.each do |friend|
#              @cat_rela = UserCategoryRelation.where(:user_id=> params[:user_id], :friend_user_id => friend, :user_category_id => cat)
#              if @cat_rela.present?
#               format.json {render :json => {:message => "You are already follow this user for this category"}}
#              else
#
#               @category_friends = UserCategoryRelation.new
#               @category_friends.update_attributes(:is_active => "1", :friend_user_id => friend,:user_id => params[:user_id],:user_category_id => cat)
#               @category_friends.save
#             end
#            end
#        end
#        if !@category_friends.blank?
#          format.json {render :json => {:message => "Add Friend Successfully"}}
#        else
#          format.json {render :json => @category_friends.errors}
#        end
#    end
#    end

#    def category_friends
#      user_cat = params[:user_category_id].split(",")
#      friends = (params[:friend_user_id]).split(",")
#      respond_to do |format|
#        if (params[:user_category_id]).nil?
#
#            friends.each do |friend|
#            @other_friend = Relatoinship.where(:user_id => params[:user_id], :friend_user_id => friend)
#            if @other_friend.present?
#              @other_friend.each do |ot|
#                ot.is_active = "1"
#                if ot.save
#                  format.json {render :json => {:message => "Add Friend Successfully"}}
#                else
#                   format.json {render :json => {:message => "You are already follow this user for this category"}}
#                end
#              end
#            else
#              @other_friendss = Relatoinship.new
#              @other_friendss.update_attributes(:user_id => params[:user_id], :friend_user_id => friend, :is_active => "1")
#              if @other_friendss.save
#                format.json {render :json => {:message => "Add Friend Successfully"}}
#              else
#                format.json {render :json => {:message => "You are already follow this user for this category"}}
#              end
#            end
#          end
#        else
#
#          user_cat.each do |cat|
#           friends.each do |friend|
#
#                @cat_rela = UserCategoryRelation.where(:user_id=> params[:user_id], :friend_user_id => friend, :user_category_id => cat)
#                if @cat_rela.present?
#                  @cat_rela.each do |catt|
#                    catt.is_active = "1"
#                   catt.save
#                   format.json {render :json => {:message => "Add Friend Successfully"}}
#
#                  end
#                else
#                    @category_friends = UserCategoryRelation.new
#                 @category_friends.update_attributes(:is_active => "1", :friend_user_id => friend,:user_id => params[:user_id],:user_category_id => cat)
#                  @category_friends.save
#
#
#                   if !@category_friends.blank?
#                    format.json {render :json => {:message => "Add Friend Successfully"}}
#                 else
#                   format.json {render :json => @category_friends.errors}
#                 end
#               end
#              end
#          end
#        end
#    end
#
#    end

    def category_friends_sign_up
      user_cat = params[:user_category_id].split(",")
      friends = (params[:friend_user_id]).split(",")
      respond_to do |format|
   
          friends.each do |friend|
               @other_friendss = Relatoinship.new
              @other_friendss.update_attributes(:user_id => params[:user_id], :friend_user_id => friend, :is_active => "1")
              @other_friendss.save
          end

          user_cat.each do |cat|
           friends.each do |friend|
     
             @masster = UserCategory.where(:id => cat).first
                 @category_friends = UserCategoryRelation.new
                 @category_friends.update_attributes(:master_category_id => @masster.master_category_id,:is_active => "1", :friend_user_id => friend,:user_id => params[:user_id],:user_category_id => cat)
                 @category_friends.save

              end
          end
        if !@category_friends.blank?
          format.json {render :json => {:message => "Add Friend Successfully"}}
        else
          format.json {render :json => @category_friends.errors}
        end

    end

    end



  def category_friends
      user_cat = params[:user_category_id].split(",")
      friends = (params[:friend_user_id]).split(",")
      respond_to do |format|
        if user_cat.empty?
          friends.each do |friend|
            @other_friend = Relatoinship.where(:user_id => params[:user_id], :friend_user_id => friend,:is_active => "true")
            if @other_friend.present?
              format.json {render :json => {:message => "You are already follow this user for this category"}}
            else
              @other_friendss = Relatoinship.new
              @other_friendss.update_attributes(:user_id => params[:user_id], :friend_user_id => friend, :is_active => "1")
              @other_friendss.save
            end
          end
           if !@other_friendss.blank?
          format.json {render :json => {:message => "Add Friend Successfully"}}
        else
          format.json {render :json => @other_friendss.errors}
        end
        else
          user_cat.each do |cat|
           friends.each do |friend|
                @cat_rela = UserCategoryRelation.where(:user_id=> params[:user_id], :friend_user_id => friend, :user_category_id => cat)
                if @cat_rela.present?
                  @cat_rela.each do |cat_rel|

                    cat_rel.update_attributes(:is_active => "1")
                    cat_rel.save
                  end

                 format.json {render :json => {:message => "Add Friend Successfully"}}
                else
                 @masster = UserCategory.where(:id => cat).first
                 @category_friends = UserCategoryRelation.new
                 @category_friends.update_attributes(:master_category_id => @masster.master_category_id,:is_active => "1", :friend_user_id => friend,:user_id => params[:user_id],:user_category_id => cat)
                 @category_friends.save

               end
              end
          end
        if !@category_friends.blank?
          format.json {render :json => {:message => "Add Friend Successfully"}}
        else
          format.json {render :json => @category_friends.errors}
        end
        end
    end

    end


  def other_friends_relations
     friends = (params[:friend_user_id]).split(",")
      respond_to do |format|
         friends.each do |friend|
           @cat_relas = Relatoinship.where(:user_id=> params[:user_id], :friend_user_id => friend)#.first
              if @cat_relas.present?
               format.json {render :json => {:message => "You are already follow this user"}}
              else
                @category_friends = Relatoinship.create
               @category_friends.update_attributes(:is_active => "1", :friend_user_id => friend,:user_id => params[:user_id])
               @category_friends.save
             end
            end
        if !friends.blank?
          format.json {render :json => {:message => friends}}
        else
          format.json {render :json => @category_friends.errors}
        end
    end
  end

 

    def all_friends
      @userss = Array.new
      self_user = Array.new
      msaa = (params[:master_category_id]).split(",")
      @user_category = UserCategory.in(:master_category_id => msaa)
      @user_category.each do |userss|
        @userss << userss.user_id
      end
      self_user << params[:user_id]
      @us = (@userss - self_user)
      @users = Array.new
      user_friends = {}
      @user = User.in(:id => @us)
      @user.each do |user|
        users = user_friends.merge(:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name)
        @users << users
      end
      respond_to do |format|
        if @users.blank?
          format.json {render :json =>{:message =>  "There is No friend"} }
        else
        format.json {render :json => @users}
        end
        
      end
    end

 def friend_clouds
    @followors = Array.new
      @followor = UserCategoryRelation.where(:user_id => params[:user_id]).uniq {|p| p.user_id}
      @followor.each do |follo|
         @cm = follo
     end
   @friend_clouds = Array.new
   friend = {}
   @cd = Array.new
   user_cat = (params[:user_category_list]).split(",")
   user_cat.each do |cat|
     @user_cat = UserCategory.where(:id => cat)
     @user_cat.each do |us_ct|
       @cd << us_ct.master_category_id
     end
   end
    @cd.each do |mac|
      @user_category = UserCategory.where(:master_category_id => mac)#.excludes(:user_id =>params[:user_id])#.uniq {|p| p.user_id}
      @user_category.each do |category|
        @user_cat_relation = UserCategoryRelation.where(:user_category_id => category.id).excludes(:user_id =>@cm.friend_user_id).uniq {|p| p.user_id}
        @user_cat_relation.each do |relation|
          @user_entitiess = UserEntity.where(:user_category_id => relation.user_category_id)
          @users = User.where(:id => relation.user_id)
          @users.each do |user|
            fr = friend.merge(:user_category_id =>  relation.user_category_id,:user_name => user.first_name,:user_id => user.id, :profile_picture => user.profile_picture_picture, :entity_count => @user_entitiess.count)
            @friend_clouds << fr
          end
        end
        end
     end
     respond_to do |format|
       format.json {render :json => @friend_clouds}
     end
     end


    def following
      @cm = Array.new
    follow = {}
    @categ = Array.new
    @followings = Array.new
    @followin = Array.new
      @following = UserCategoryRelation.where(:user_id => params[:user_id],:user_category_id => params[:user_category_id], :is_active => "true")
      @following.each do |follo|
        @cm << follo.friend_user_id
      end
        @user_cate = UserCategory.in(:user_id => @cm).where(:master_category_id => params[:master_category_id])
        @user_cate.each do |user_cate|
          @entity_user = UserEntity.where(:user_id => user_cate.user_id, :user_category_id => user_cate.id)
        @users = User.where(:id => user_cate.user_id)
        @users.each do |users|
          ft = follow.merge(:master_category_id => user_cate.master_category_id,:email => users.email,:user_name => users.first_name,:user_id => users.id, :profile_picture => users.profile_picture_url, :entity_count => @entity_user.count, :status => "YES")
          @followings << ft
        end
        end
      @follo = @followings.sort{|a,b| [a[:user_id]] <=> [b[:user_id]]}
      respond_to do |format|
        format.json {render :json => @follo.uniq.count  }
      end
    end



  def  following_data
    @cm = Array.new
    follow = {}
    @categ = Array.new
    @followings = Array.new
    @followin = Array.new
      @following = UserCategoryRelation.where(:user_id => params[:user_id],:user_category_id => params[:user_category_id], :is_active => "true")
      @following.each do |follo|
        @cm << follo.friend_user_id
      end
        @user_cate = UserCategory.in(:user_id => @cm).where(:master_category_id => params[:master_category_id])
        @user_cate.each do |user_cate|
          @entity_user = UserEntity.where(:user_id => user_cate.user_id, :user_category_id => user_cate.id)
        @users = User.where(:id => user_cate.user_id)
        @users.each do |users|
          ft = follow.merge(:master_category_id => user_cate.master_category_id,:user_id => users.id,:email => users.email,:user_name => users.first_name,:friend_user_id => users.id, :profile_picture => users.profile_picture_url, :entity_count => @entity_user.count, :status => "YES")
          @followings << ft
        end
        end
       @user_category = UserCategory.in.excludes(:user_id => @cm).where(:master_category_id => params[:master_category_id], :is_active => "true").uniq {|p| p.user_id}
      @user_category.each do |u_category|
        @categ << u_category.user_id
      end
      der = (@categ - @cm)
      der.uniq
     # end
      cwe = (@categ.uniq)
       @user_category = UserCategory.in(:user_id => der).where(:master_category_id => params[:master_category_id], :is_active => "true").uniq {|p| p.user_id}
       @user_category.each do |cat|
         @user_entity = UserEntity.where(:user_id => cat.user_id, :user_category_id => cat.id)
         @users = User.where(:id => cat.user_id)
         @users.each do |users|
            fl = follow.merge(:master_category_id => cat.master_category_id,:user_id => users.id,:email => users.email,:user_name => users.first_name,:friend_user_id => users.id, :profile_picture => users.profile_picture_url, :entity_count => @user_entity.count, :status => "NO")
            @followings << fl
         end
       end

         @follo = @followings.sort{|a,b| [a[:user_id]] <=> [b[:user_id]]}# && @followings.sort_by { |k| k["user_name"]}
         #@follo =  @followings.sort{|a,b|  [a[:email]] <=> [b[:email]]}
        respond_to do |format|
        if !@follo.blank?
          format.json {render :json =>  @follo.uniq }
        else
          format.json {render :json =>  {:message => "There is no Following"}}
        end
      end
  end

 def all_category
    @master = Array.new
    master_category = {}
    @all_category = MasterCategory.all
     respond_to do |format|
    @all_category.each do |cat|
       @user_cat = UserCategory.where(:user_id => params[:user_id],:master_category_id => cat.id).all
       if (@user_cat.empty?)
         master_entity = master_category.merge(:master_category_id => cat.id, :status => "NO", :master_category_name => cat.category_name, :master_category_image => cat.category_image)
         @master << master_entity
       else
         user_entity = master_category.merge(:master_category_id => cat.id, :status => "YES" , :master_category_name => cat.category_name, :master_category_image => cat.category_image)
         @master << user_entity
        end
    end
      format.json {render :json => @master}
    end
 end


#curl -X POST -d "user_id=524120f201ce2ec869000003&user_category_id=524152d701ce2ef82d000004&master_category_id=51873871b554cfd51d000004"  http://ec2-54-225-243-66.compute-1.amazonaws.com/friends/followers_data.json
    def followers
      follows = {}
      @followors = Array.new
      @user_categoriess = Array.new
      @user_category = UserCategory.where(:master_category_id => params[:master_category_id])#,:user_id => params[:user_id])
      @user_category.each do |us_cate|

        @user_categoriess << us_cate.id
      end
        @cate_reletion_user = UserCategoryRelation.in(:user_category_id => @user_categoriess).where(:friend_user_id =>  params[:user_id], :is_active => "true")
        @cate_reletion_user.each do |cate_rele|
          @use_entity = UserEntity.where(:user_id => cate_rele.user_id)
          @user = User.where(:id => cate_rele.user_id)
          @user.each do |users|
            fl = follows.merge(:user_name => users.first_name,:user_id => users.id, :profile_picture => users.profile_picture_url, :entity_count => @use_entity.count, :status => "NO")
             @followors << fl
          end
        end

       @follo = @followors.sort{|a,b| [a[:user_id]] <=> [b[:user_id]]}
     respond_to do |format|
        if !@follo.blank?
          format.json {render :json =>  @follo.uniq.count}
        else
          format.json {render :json =>  {:message => "There is no Followers"}}
        end
      end
    end


    def followers_data
      follows = {}
      @followors = Array.new
      @user_categoriess = Array.new
      @user_category = UserCategory.where(:master_category_id => params[:master_category_id])#,:user_id => params[:user_id])
      @user_category.each do |us_cate|
        @user_categoriess << us_cate.id
      end
        @cate_reletion_user = UserCategoryRelation.in(:user_category_id => @user_categoriess).where(:friend_user_id =>  params[:user_id], :is_active => "true")
        @cate_reletion_user.each do |cate_rele|
          @follo_cat_user = UserCategoryRelation.in(:user_category_id => @user_categoriess).where(:user_id => params[:user_id],:friend_user_id => cate_rele.user_id, :is_active => "true")
          if @follo_cat_user.present?
            @use_entity = UserEntity.where(:user_id => cate_rele.user_id)
          @user = User.where(:id => cate_rele.user_id)
          @user.each do |users|
            fl = follows.merge(:user_name => users.first_name,:user_id => users.id, :profile_picture => users.profile_picture_url, :entity_count => @use_entity.count, :status => "YES")
             @followors << fl
          end
          else
            @use_entity = UserEntity.where(:user_id => cate_rele.user_id)
          @user = User.where(:id => cate_rele.user_id)
          @user.each do |users|
            fl = follows.merge(:user_name => users.first_name,:user_id => users.id, :profile_picture => users.profile_picture_url, :entity_count => @use_entity.count, :status => "NO")
             @followors << fl
          end
          end
          
        end
      
       @follo = @followors.sort{|a,b| [a[:user_id]] <=> [b[:user_id]]}
      respond_to do |format|
         if !@follo.blank?
          format.json {render :json =>  @follo.uniq}
        else
          format.json {render :json =>  {:message => "There is no Followers"}}
        end
      end
    end


 def traids
  @traids = Array.new
  ur = Array.new
  weliike ={}
  @rating = Array.new
  user_category = UserCategory.where(:master_category_id => params[:master_category_id])
  user_category.each do |category|
    @user_relations = UserCategoryRelation.where(:user_category_id => category.id).uniq {|p|  p.user_id}
    @user_relations.each do |user_relation|
      ur << user_relation.user_category_id
       end
        end
ur.each do |urs|
      @user_entity = UserEntity.where(:user_category_id => urs ).paginate(:page => params[:page],:per_page => 5).uniq {|p|  p.entity_name}
        @user_entity.each do |user_entity|
          u_id = user_entity.id
          @ratings = Rating.where(:user_entity_id=> u_id.to_s )
          if @ratings.present?
           @ratings.each do |rat|
             @rating << rat.rating_count
           end
          cd = (user_entity.rating_count).to_i
          @rating << cd
          total = 0

        @rating.each do |item|
           total += item
        end
        average = total / @rating.length
      else
        if user_entity.rating_count == "0"
          average = "0"
        else
          @rating << (user_entity.rating_count).to_i
          total = 0
          average = 0
          @rating.each do |item|
           total += item
        end
        average = total / @rating.length
        end
     end
 
          @user = User.where(:id => user_entity.user_id)
          @user.each do |user|
          we = weliike.merge(:user_id => user.id,:user_name => user.first_name, :entity_address => user_entity.address, :profile_picture => user.profile_picture_url, :master_category_id => params[:master_category_id], :entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image, :rating_count => average, :entity_id =>user_entity.id)
          @traids << we
          end
        end
end
 
    respond_to do |format|
      format.json {render :json => @traids}
    end
  end

 def all_friend_for_welike
   @friend = Array.new
   friend = {}
   cdn  = Array.new
   @user_category = UserCategory.where(:master_category_id => params[:master_category_id])
@user_category.each do |category|
 @friend_relation = UserCategoryRelation.where(:user_category_id => category.id,:user_id => params[:user_id])
  @friend_relation.each do |relation|
    cdn << relation.friend_user_id
  end
   end
   cdn.each do |cd|
     @user_categories = UserCategory.where(:master_category_id => params[:master_category_id], :user_id => cd)
     @user_categories.each do |cat_user|
        @friend_entity = UserEntity.where(:user_category_id => cat_user.id , :user_id => cat_user.user_id)
        @friend_entity.each do |entity|
          @users = User.where(:id => entity.user_id).all
          @users.each do |user|
            fr = friend.merge(:user_id => user.id,:user_name => user.first_name,:entity_id => entity.id, :entity_address => entity.address, :profile_picture => user.profile_picture, :master_category_id => params[:master_category_id], :entity_name => entity.entity_name, :entity_image => entity.entity_image, :rating_count => entity.rating_count)
            @friend << fr
          end
        end
     end
   end
   respond_to do |format|
     if !@friend.blank?
       format.json {render :json => @friend}
     else
       format.json {render :json => {:message => "There is no data"}}
     end
   end
 end

 def group_friend
   use = {}
   @user = Array.new
   @friends1 = Relatoinship.where(:user_id => params[:user_id]).paginate(:per_page => 3, :page => params[:page])
   @friends1.each do |f|
     @users = User.where(:id => f.friend_user_id)
     @users.each do |users|
       us = use.merge(:user_id => users.id, :user_name => users.first_name, :profile_picture => users.profile_picture_url)
       @user << us
     end
   end
     respond_to do |format|
      if @user.present?
        format.json {render :json => @user}
      else
        format.json {render :json => {:message => "There is no friend"}}
      end
    end
end

def likers
 likers = {}
 count_liker1 = Array.new
 count_liker2 = Array.new
 count_liker3 = Array.new
 count_liker4 = Array.new
 count_liker5 = Array.new
@likers1 = Array.new
  @liker_entity = UserEntity.where(:id => params[:user_entity_id]).first
  @liker_post =  Post.where(:user_entity_id => @liker_entity.id)
  @likers =  ILiikes.where(:user_entity_id =>  params[:user_entity_id])
#  @liker_rating = Rating.where(:user_entity_id => params[:user_entity_id])
#  @liker_rating.each do |rat|
#    if rat.rating_count == 1
#      @user = User.where(:id => rat.self_user_id)
#      @user.each do |users|
#        like = likers.merge(:user_id => users.id, :user_name => users.first_name, :entity_rating_count => rat.rating_count,:profile_picture =>  users.profile_picture_url )
#        count_liker1 << like
#      end
#    elsif rat.rating_count == 2
#      @user = User.where(:id => rat.self_user_id)
#      @user.each do |users|
#        like = likers.merge(:user_id => users.id, :user_name => users.first_name, :entity_rating_count => rat.rating_count ,:profile_picture =>  users.profile_picture_url)
#       count_liker2 << like
#      end
#    elsif rat.rating_count == 3
#      @user = User.where(:id => rat.self_user_id)
#      @user.each do |users|
#        like = likers.merge(:user_id => users.id, :user_name => users.first_name , :entity_rating_count => rat.rating_count ,:profile_picture =>  users.profile_picture_url)
#         count_liker3 << like
#      end
#    elsif rat.rating_count == 4
#      @user = User.where(:id => rat.self_user_id)
#      @user.each do |users|
#        like = likers.merge(:user_id => users.id, :user_name => users.first_name, :entity_rating_count => rat.rating_count,:profile_picture =>  users.profile_picture_url )
#         count_liker4 << like
#      end
#    elsif rat.rating_count == 5
#      @user = User.where(:id => rat.self_user_id)
#      @user.each do |users|
#        like = likers.merge(:user_id => users.id, :user_name => users.first_name, :entity_rating_count => rat.rating_count,:profile_picture =>  users.profile_picture_url )
#         count_liker5 << like
#      end
#    end
#  end
 respond_to do |format|
  # format.json {render  :json => {:rating_count_1 => count_liker1, :rating_count_2 => count_liker2, :rating_count_3 => count_liker3,:rating_count_4 => count_liker4, :rating_count_5 => count_liker5 }}

    format.json {render  :json => @liker_post}
 end

end

def entity_likers
  @liikers = Array.new
  liiker = {}
  @likers =  ILiikes.where(:user_entity_id =>  params[:user_entity_id],:is_liikes => "true").order_by(:created_at => "desc")
  @likers.each do |like|
    @users = User.where(:id => like.user_id)
    @users.each do |user|
      likee = liiker.merge(:user_id => user.id, :profile_picture => user.profile_picture, :first_name => user.first_name,:last_name => user.last_name,:user_entity_id => like.id)
      @liikers << likee
    end
  end
  respond_to do |format|
    format.json {render  :json => @liikers.uniq}
  end
end

def unfollow
  @relationship = Relatoinship.where(:user_id => params[:user_id], :friend_user_id => params[:friend_user_id])
  respond_to do |format|
  if params[:user_category_id].nil?
    if @relationship.present?
      @relationship.each do |rels|
        rels.is_active = "0"
        rels.save
      end
      format.json {render :json => {:message => "Successfully Unfollow Friend"}}
    end
    
  elsif !(params[:user_category_id]).nil?
     @user_relations = UserCategoryRelation.where(:user_id => params[:user_id], :friend_user_id => params[:friend_user_id], :user_category_id => params[:user_category_id])
     @user_relations.each do |user_relat|
       user_relat.is_active = "0"
       user_relat.save
     end
      format.json {render :json => {:message => "Successfully Unfollow Friend"}}
  else
     format.json {render :json => {:message => "Some Error during Unfollowing friend"}}
    end
  end
  end


def delete_user
   @user = User.where(:id => params[:user_id])
  respond_to do |format|
  if @user.destroy
    format.json {render :json => {:message => "Successfully Deleted"}}
  end
  end


end

def unfollow_all
  @relationship = Relatoinship.where(:user_id => params[:user_id], :friend_user_id => params[:friend_user_id])
  respond_to do |format|
    if @relationship.present?
      @relationship.each do |rels|
        rels.destroy
      end
    end
     @user_relations = UserCategoryRelation.where(:user_id => params[:user_id], :friend_user_id => params[:friend_user_id])
     @user_relations.each do |user_relat|
       user_relat.destroy
     end
      format.json {render :json => {:message => "Successfully Unfollow Friend"}}
  end
end

def all_friends_search
  @use = Array.new
     @search_users = Array.new
      user_friends = {}
      @user = User.excludes(:id => params[:user_id])
      @user.each do |userss|
        @use << userss.id
      end
      @use.each do |us|
        @users = User.where(:id => us, :first_name => /.*#{params[:first_name][:char]}*./i )
        @users.each do |user|
          users = user_friends.merge(:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name)
          @search_users << users
        end

      end
      respond_to do |format|
        format.json {render :json => @search_users}
      end
    end

def check_facebook
  check = {}
  @c_facebook = Array.new
  @users = User.where(:provider => params[:provider])
  @users.each do |users|
    ch = check.merge(:user_id => users.id,:user_name => users.first_name, :facebook_id => users.facebook_id )
    @c_facebook << ch
  end

  respond_to do |format|
    format.json {render :json =>@c_facebook }
  end
end

def following_search
  @cm = Array.new
    follow = {}
    @categ = Array.new
    @followings = Array.new
    @followin = Array.new
      @following = UserCategoryRelation.where(:user_id => params[:user_id],:user_category_id => params[:user_category_id], :is_active => "true")
      @following.each do |follo|
        @cm << follo.friend_user_id
      end
        @user_cate = UserCategory.in(:user_id => @cm).where(:master_category_id => params[:master_category_id])
        @user_cate.each do |user_cate|
          @entity_user = UserEntity.where(:user_id => user_cate.user_id, :user_category_id => user_cate.id)
        @users = User.where(:id => user_cate.user_id, :first_name =>/.*#{params[:user_name][:char]}*./i)
        @users.each do |users|
          ft = follow.merge(:user_id => users.id,:email => users.email,:user_name => users.first_name,:friend_user_id => users.id, :profile_picture => users.profile_picture_url, :entity_count => @entity_user.count, :status => "YES")
          @followings << ft
        end
        end
       @user_category = UserCategory.in.excludes(:user_id => @cm).where(:master_category_id => params[:master_category_id], :is_active => "true").uniq {|p| p.user_id}
      @user_category.each do |u_category|
        @categ << u_category.user_id
      end
      der = (@categ - @cm)
      der.uniq
     # end
      cwe = (@categ.uniq)
       @user_category = UserCategory.in(:user_id => der).where(:master_category_id => params[:master_category_id], :is_active => "true").uniq {|p| p.user_id}
       @user_category.each do |cat|
         @user_entity = UserEntity.where(:user_id => cat.user_id, :user_category_id => cat.id)
         @users = User.where(:id => cat.user_id, :first_name =>/.*#{params[:user_name][:char]}*./i)
         @users.each do |users|
            fl = follow.merge(:user_id => users.id,:email => users.email,:user_name => users.first_name,:friend_user_id => users.id, :profile_picture => users.profile_picture_url, :entity_count => @user_entity.count, :status => "NO")
            @followings << fl
         end
       end

         @follo = @followings.sort{|a,b| [a[:user_id]] <=> [b[:user_id]]}# && @followings.sort_by { |k| k["user_name"]}
         #@follo =  @followings.sort{|a,b|  [a[:email]] <=> [b[:email]]}
        respond_to do |format|
        if !@follo.blank?
          format.json {render :json =>  @follo.uniq }
        else
          format.json {render :json =>  {:message => "There is no Following"}}
        end
      end
end

  end
