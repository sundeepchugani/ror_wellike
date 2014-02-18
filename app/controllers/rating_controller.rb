class RatingController < ApplicationController
  def post_rating
    @rating = Raiting.new(params[:rating])
    respond_to do |format|
    if @rating.save
      format.json {render :json => {:message => "Ratting Suceesfully"}}
    else
      format.json {render :json => {:message => "Some Errors"}}
    end
    end
  end

 

  def rating_entity
    @rating = Rating.new
       @entity = UserEntity.where(:id => params[:user_entity_id], :user_id => params[:user_id]).first
        respond_to do |format|
         if params[:rating_count]
           @rating.update_attributes(:self_user_id => params[:self_user_id],:user_id => params[:user_id], :user_entity_id => params[:user_entity_id], :rating_count => params[:rating_count])
            if  @rating.save
             if @entity.user_id == @rating.self_user_id
             else
             @entities = UserEntity.where(:user_id => @rating.self_user_id, :other_entity_id => @rating.user_entity_id).first
          if @entities.present?
            @entities.update_attributes(:is_public  => "1", :api_id => @entity.api_id)
            @entities.save
            @user_category_relations = UserCategoryRelation.where(:user_id => params[:self_user_id], :user_category_id => @entities.user_category_id, :friend_user_id => params[:self_user_id]).first
       if @user_category_relations.present?
          @user_category_relations.update_attributes(:is_active => "1")
          @user_category_relations.save
       else
          @user_category_relationss = UserCategoryRelation.new
          @user_category_relationss.update_attributes(:is_active => "1" , :user_id => params[:self_user_id], :user_category_id => @entities.user_category_id, :friend_user_id => params[:self_user_id])
          @user_category_relationss.save
       end
              @likes = ILiikes.where(:friend_user_id => params[:user_id], :user_id => params[:self_user_id] , :user_entity_id => params[:user_entity_id]).first
            if @likes.present?
               @likes.update_attributes(:is_liikes => "1")
               @likes.save
            else
              @iliikes = ILiikes.new
              @iliikes.update_attributes(:friend_user_id => params[:user_id], :user_id => params[:self_user_id] , :user_entity_id => @entity.id,:is_liikes => "1")
              @iliikes.save
            end
       
             else
              @user_category = UserCategory.where(:id => @entity.user_category_id).first
             @cat_user = UserCategory.where(:user_id => @rating.self_user_id , :master_category_id =>@user_category.master_category_id ).first
             if @cat_user.present?
                 @user_category_relations = UserCategoryRelation.where(:user_id => params[:self_user_id], :user_category_id => @cat_user.id, :friend_user_id => params[:self_user_id]).first
       if @user_category_relations.present?
          @user_category_relations.update_attributes(:is_active => "1")
          @user_category_relations.save
       else
          @user_category_relationss = UserCategoryRelation.new
          @user_category_relationss.update_attributes(:is_active => "1" , :user_id => params[:self_user_id], :user_category_id => @cat_user.id, :friend_user_id => params[:self_user_id])
          @user_category_relationss.save
       end
               @user_entity_create = UserEntity.new
               @user_entity_create.update_attributes(:caputredDeviceOrientation => @entity.caputredDeviceOrientation,:artist=> @entity.artist,:xcody => @entity.xcody, :ycody => @entity.ycody,:is_liike => "1",:entity_name => @entity.entity_name,:user_category_id => @cat_user.id, :user_id => @rating.self_user_id, :is_active => "1", :is_public => "1" , :entity_image => @entity.entity_image, :entity_image_url => @entity.entity_image_url, :comment => @entity.comment, :address => @entity.address, :lat => @entity.lat, :longitude => @entity.longitude, :rating_count => @rating.rating_count, :sub_category => @entity.sub_category, :other_entity_id => @entity.id, :api_id => @entity.api_id)
               @user_entity_create.save
            @likes = ILiikes.where(:friend_user_id => params[:user_id], :user_id => params[:self_user_id] , :user_entity_id => params[:user_entity_id]).first
            if @likes.present?
               @likes.update_attributes(:is_liikes => "1")
               @likes.save
            else
              @iliikes = ILiikes.new
              @iliikes.update_attributes(:friend_user_id => params[:user_id], :user_id => params[:self_user_id] , :user_entity_id => @entity.id,:is_liikes => "1")
              @iliikes.save
            end
             else
               @user_category_create = UserCategory.new
               @user_category_create.update_attributes(:user_id => @rating.self_user_id,:master_category_id => @user_category.master_category_id, :is_active => "1" )
               @user_entity_creates = UserEntity.new
               @user_entity_creates.update_attributes(:caputredDeviceOrientation => @entity.caputredDeviceOrientation,:artist=> @entity.artist,:xcody => @entity.xcody, :ycody => @entity.ycody,:is_liike => "1",:user_id => @rating.self_user_id,:api_id => @entity.api_id,:entity_name => @entity.entity_name,:user_category_id => @user_category_create.id, :is_active => "1", :is_public => "1" , :entity_image => @entity.entity_image, :entity_image_url => @entity.entity_image_url, :comment => @entity.comment, :address => @entity.address, :lat => @entity.lat, :longitude => @entity.longitude, :rating_count => @rating.rating_count, :sub_category => @entity.sub_category, :other_entity_id => @entity.id)
               @user_category_create.save
               @user_entity_creates.save
                @user_category_relations = UserCategoryRelation.where(:user_id => params[:self_user_id], :user_category_id => @user_category_create.id, :friend_user_id => params[:self_user_id]).first
       if @user_category_relations.present?
          @user_category_relations.update_attributes(:is_active => "1")
          @user_category_relations.save
       else
          @user_category_relationss = UserCategoryRelation.new
          @user_category_relationss.update_attributes(:is_active => "1" , :user_id => params[:self_user_id], :user_category_id => @user_category_create.id, :friend_user_id => params[:self_user_id])
          @user_category_relationss.save
       end
            @likes = ILiikes.where(:friend_user_id => params[:user_id], :user_id => params[:self_user_id] , :user_entity_id => params[:user_entity_id]).first
            if @likes.present?
               @likes.update_attributes(:is_liikes => "1")
               @likes.save
            else
              @iliikes = ILiikes.new
              @iliikes.update_attributes(:friend_user_id => params[:user_id], :user_id => params[:self_user_id] , :user_entity_id => @entity.id,:is_liikes => "1")
              @iliikes.save
            end
             end
             end
             end
             format.json {render :json => {:message => "Rating Successfully", :dc =>@entities }}
            else
             format.json {render :json => {:error => "Sone Error During Rating "}}
            end
         end
  end
end
end
