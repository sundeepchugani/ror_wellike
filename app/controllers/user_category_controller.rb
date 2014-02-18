class UserCategoryController < ApplicationController
  def new
    @users = User.all
  end

  def create  #<......comment-----the create method use for create the users category....
   cs=  params[:user_category][:master_category_id].split(",")
    category = {}
    @category = Array.new
    respond_to do |format|
      cs.each do |i|
         @user_categories = UserCategory.where(:user_id => params[:user_category][:user_id], :master_category_id => i.to_s).first
         if @user_categories.present?
             @master_cate = MasterCategory.where(:id => @user_categories.master_category_id).first
             @user_categories.update_attributes(:is_active => "1")
             @user_categories.save
             cate = category.merge(:is_present => "Yes", :user_category_name => @master_cate.category_name, :user_category_image => @master_cate.category_image, :master_category_id => @user_categories.master_category_id ,:user_category_id => @user_categories.id,:user_id =>@user_categories.user_id, :is_active => @user_categories.is_active, :status => "YES")
             @category << cate
             @user_category_relations = UserCategoryRelation.where(:user_id => params[:user_category][:user_id], :user_category_id => @user_categories.id, :friend_user_id => params[:user_category][:user_id]).first
             if @user_category_relations.present?
             @user_category_relations.update_attributes(:is_active => "1")
             @user_category_relations.save

             else
              @user_category_relationss = UserCategoryRelation.new
              @user_category_relationss.update_attributes(:master_category_id=> i.to_s,:is_active => "1" , :user_id => params[:user_category][:user_id], :user_category_id => @user_categories.id, :friend_user_id => params[:user_category][:user_id])
              @user_category_relationss.save
             end


           format.json {render :json=> @category }
         end
        if !@user_categories.present?
           @master_category = MasterCategory.where(:id => i)
           @master_category.each do |master_cate|
             @user_category = UserCategory.new  #.<comment.........create the user category the UserCategory model contain master_category_id, user_id etc
             @user_category.update_attributes(:master_category_id => i.to_s ,:user_id =>params[:user_category][:user_id], :is_active => "1")
             @user_category.save
             cate = category.merge(:is_present => "No",:user_category_name => master_cate.category_name, :user_category_image => master_cate.category_image, :master_category_id => @user_category.master_category_id ,:user_category_id => @user_category.id,:user_id =>@user_category.user_id, :is_active => @user_category.is_active, :status => "NO")
             @category << cate
             @user_category_relation = UserCategoryRelation.new
             @user_category_relation.update_attributes(:master_category_id=> i.to_s,:is_active => "1" , :user_id => params[:user_category][:user_id], :user_category_id => @user_category.id, :friend_user_id => params[:user_category][:user_id])
             @user_category_relation.save

          end
          
          format.json {render :json=> @category }
        end
      end
    end
  end
   
  def get_friend
    user_c = {}
    @category_friends = Array.new
    @user_category = UserCategory.where(:master_category_id => params[:category][:master_category_id])
    @user_category.each do |user|
      @users = User.where(:id => user.user_id).all
      @users.each do |image|
        ch = user_c.merge(:first_name => image.first_name,:user_id => image.id, :profile_picture =>image.profile_picture)
        @category_friends << user << ch
      end
    end
    respond_to do |format|
      format.json {render :json => @category_friends }
    end
 end


  def aggrigrator
    category_user = {}
    respond_to do |format|
        @aggrigrator_screen = Array.new
        @aggrigrator = UserCategory.where(:user_id => params[:category][:user_id],:is_active => "true").order_by([:created_at,:desc])
        @aggrigrator.each do |category|
          @master_category = MasterCategory.where(:id => category.master_category_id)
          @master_category.each do |master_category|
            cat = category_user.merge(:user_id => category.user_id, :user_categy_name => master_category.category_name, :user_category_image => master_category.category_image, :user_category_id => category.id, :master_category_id => master_category.id )
             @aggrigrator_screen << cat
        end
         end
              format.json {render :json => @aggrigrator_screen}
        end
     end

  def all_category
    @master = Array.new
    master_category = {}
    @all_category = MasterCategory.all
     respond_to do |format|
    @all_category.each do |cat|
       @user_cat = UserCategory.where(:user_id => params[:user_id],:master_category_id => cat.id, :is_active => "1").all
       if (@user_cat.empty?)
         master_entity = master_category.merge(:master_category_id => cat.id, :status => "NO", :master_category_name => cat.category_name, :master_category_image => cat.category_image)
         @master << master_entity
       else
         @user_cat.each do |user_cat|
         user_entity = master_category.merge(:master_category_id => cat.id, :status => "YES" , :master_category_name => cat.category_name, :master_category_image => cat.category_image, :user_category_id => user_cat.id)
         @master << user_entity
        end
       end
    end
    sorted = @master.sort {|a,b| b[:status] <=> a[:status]}
      format.json {render :json => sorted}
    end
end

def remove_category
    @category = UserCategory.where(:id => params[:user_category_id], :user_id => params[:user_id]).first
    respond_to do |format|
      if @category.present?
        @category.update_attributes(:is_active=> "0")
        @category.save
        format.json {render :json => {:message => "Remove Category Successfully"}}
      else
        format.json {render :json => {:errors => "Some Errors During Category Deletion" }}
      end
    end
end

def follow_category
  @user_category = UserCategory.where(:master_category_id => params[:master_category_id], :user_id => params[:user_id]).first
  respond_to do |format|
    if @user_category.present?
    @user_relations = UserCategoryRelation.where(:user_id => params[:user_id], :friend_user_id => params[:friend_user_id], :user_category_id => @user_category.id)
    if @user_relations.present?
      @user_relations.each do |us_re|
        us_re.is_active = "1"
        us_re.save
        format.json {render :json => {:message => "Follow Category Successfully"}}
      end
    else
           @category_friends = UserCategoryRelation.new
           @category_friends.update_attributes(:master_category_id => params[:master_category_id],:is_active => "1", :friend_user_id => params[:friend_user_id],:user_id => params[:user_id],:user_category_id =>@user_category.id)
           @category_friends.save
          format.json {render :json => {:message => "Follow Category Successfully"}}
    end
  else
    @user_categories = UserCategory.new
    @user_categories.update_attributes(:master_category_id => params[:master_category_id], :user_id => params[:user_id], :is_active => "1")
    if @user_categories.save
       @user_relations = UserCategoryRelation.where(:user_id => params[:user_id], :friend_user_id => params[:friend_user_id], :user_category_id => @user_categories.id)
    if @user_relations.present?
      @user_relations.each do |us_re|
        us_re.is_active = "1"
         us_re.save
         format.json {render :json => {:message => "Follow Category Successfully"}}
      end
    else
           @category_friends = UserCategoryRelation.new
           @category_friends.update_attributes(:master_category_id => params[:master_category_id],:is_active => "1", :friend_user_id => params[:friend_user_id],:user_id => params[:user_id],:user_category_id =>@user_categories.id)
           @category_friends.save
           format.json {render :json => {:message => "Follow Category Successfully"}}
    end
  end

  end
 

  end
end


def unfollow_category
   @user_relations = UserCategoryRelation.where(:user_id => params[:user_id], :friend_user_id => params[:friend_user_id], :user_category_id => params[:user_category_id]).first
  respond_to do |format|
    if @user_relations.present?
      @user_relations.update_attributes(:is_active=> "0")
      @user_relations.save
      format.json {render :json => {:message => @user_relations}}
    else
     format.json {render :json => {:error => "Error During Unfollow Category"}}
    end
  end
end

def is_active
  @mast = MasterCategory.all
  @mast.each do |master|
    @user_cat = UserCategory.where(:master_category_id => master.id)
    @user_cat.each do |user_cat|
      user_cat.is_active = "1"
      user_cat.save
    end
  end
  respond_to do |format|
    format.json {render :json => {:message => "successfully updated"}}
  end
end



end



#curl -X POST -d "user_id=&friend_user_id=&user_category_id=&master_category_id=" http://localhost:3000/user_category/follow_category.json