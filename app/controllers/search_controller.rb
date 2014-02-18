class SearchController < ApplicationController
  def search_all
    @entity_search = Array.new
    @rating = Array.new
    entity_search = {}
    @category_relations = Array.new
    @sort_setting = EntitySetting.where(:user_id => params[:user_id]).first
    respond_to do |format|
      if @sort_setting.present?
      if params[:search] == "i_liike"
        if @sort_setting.sort_by == "Rating"
          @user_entities_rat_all = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_only_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entity_with_rating = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p| p.user_id && p.entity_name}
          if @sort_setting.narrow_by_sub_category.empty?
            @user_entity_with_rating.each do |with_rating|
               @users = User.where(:id => with_rating.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_rating.api_id,:xcody => with_rating.xcody,:ycody => with_rating.ycody,:caputredDeviceOrientation => with_rating.caputredDeviceOrientation,:is=> "Rating",:user_entity_id => with_rating.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_rating.address, :comment => with_rating.comment, :entity_image => with_rating.entity_image, :entity_name => with_rating.entity_name,  :rating_count => with_rating.rating_count, :sub_category => with_rating.sub_category, :lat => with_rating.lat , :longitude => with_rating.longitude, :user_category_id =>  with_rating.user_category_id)
                 @entity_search << es
               end
             end
          else 
              if @user_entities_rat_all.present?
             @user_entities_rat_all.each do |user_entity|
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:is=> "Rating",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_and_city.present?
             @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                 @users = User.where(:id => sub_category_and_city.user_id)
                 @users.each do |users|
                   es = entity_search.merge(:api_id => sub_category_and_city.api_id,:xcody => sub_category_and_city.xcody,:ycody => sub_category_and_city.ycody,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:is=> "Rating",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                   @entity_search << es
               end
             end
           elsif @user_entities_with_rat_and_city_or_sub_category.present?
             @user_entities_with_rat_and_city_or_sub_category.each do |city_or_sub_category_with_rat|
               @users = User.where(:id => city_or_sub_category_with_rat.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => city_or_sub_category_with_rat.api_id,:xcody => city_or_sub_category_with_rat.xcody,:ycody => city_or_sub_category_with_rat.ycody,:caputredDeviceOrientation => city_or_sub_category_with_rat.caputredDeviceOrientation,:is=> "Rating",:user_entity_id => city_or_sub_category_with_rat.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city_or_sub_category_with_rat.address, :comment => city_or_sub_category_with_rat.comment, :entity_image => city_or_sub_category_with_rat.entity_image, :entity_name => city_or_sub_category_with_rat.entity_name,  :rating_count => city_or_sub_category_with_rat.rating_count, :sub_category => city_or_sub_category_with_rat.sub_category, :lat => city_or_sub_category_with_rat.lat , :longitude => city_or_sub_category_with_rat.longitude, :user_category_id =>  city_or_sub_category_with_rat.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_or_city.present?
             @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
               @users = User.where(:id => sub_category_or_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => sub_category_or_city.api_id,:xcody => sub_category_or_city.xcody,:ycody => sub_category_or_city.ycody,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:is=> "Rating",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_city.present?
             @user_entities_with_only_city.each do |with_city|
               @users = User.where(:id => with_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_city.api_id,:xcody => with_city.xcody,:ycody => with_city.ycody,:caputredDeviceOrientation => with_city.caputredDeviceOrientation,:is=> "Rating",:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => with_city.rating_count, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_sub_category.present?
             @user_entities_with_only_sub_category.each do |with_sub_category|
               @users = User.where(:id => with_sub_category.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_sub_category.api_id,:xcody => with_sub_category.xcody,:ycody => with_sub_category.ycody,:caputredDeviceOrientation => with_sub_category.caputredDeviceOrientation,:is=> "Rating",:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => with_sub_category.rating_count, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id)
                 @entity_search << es
               end
             end
           end
              
          end
             if !@entity_search.blank?
                format.json {render :json => @entity_search}
             else
                format.json {render :json => {:message => "Search not found"} }
             end
      elsif @sort_setting.sort_by == "Recent"
          @user_entities_recent_all = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name}  | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_recent_and_city_or_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name} |  UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_only_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
          @user_entity_with_recent = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name} |UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name}
          if @sort_setting.narrow_by_sub_category.empty?
            @user_entity_with_recent.each do |with_rating|
               @users = User.where(:id => with_rating.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_rating.api_id,:xcody => with_rating.xcody,:ycody => with_rating.ycody,:caputredDeviceOrientation => with_rating.caputredDeviceOrientation,:user_entity_id => with_rating.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_rating.address, :comment => with_rating.comment, :entity_image => with_rating.entity_image, :entity_name => with_rating.entity_name,  :rating_count => with_rating.rating_count, :sub_category => with_rating.sub_category, :lat => with_rating.lat , :longitude => with_rating.longitude, :user_category_id =>  with_rating.user_category_id)
                 @entity_search << es
               end
             end
          else
          if @user_entities_recent_all.present?
             @user_entities_recent_all.each do |user_entity|
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                 @entity_search << es
               end
             end
            elsif @user_entities_with_sub_category_and_city.present?
             @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                 @users = User.where(:id => sub_category_and_city.user_id)
                 @users.each do |users|
                   es = entity_search.merge(:api_id => sub_category_and_city.api_id,:xcody => sub_category_and_city.xcody, :ycody => sub_category_and_city.ycody,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                   @entity_search << es
               end
             end
            elsif @user_entities_with_recent_and_city_or_sub_category.present?
             @user_entities_with_recent_and_city_or_sub_category.each do |city_or_sub_category_with_rat|
               @users = User.where(:id => city_or_sub_category_with_rat.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => city_or_sub_category_with_rat.api_id,:xcody => city_or_sub_category_with_rat.xcody,:ycody => city_or_sub_category_with_rat.ycody,:caputredDeviceOrientation => city_or_sub_category_with_rat.caputredDeviceOrientation,:user_entity_id => city_or_sub_category_with_rat.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city_or_sub_category_with_rat.address, :comment => city_or_sub_category_with_rat.comment, :entity_image => city_or_sub_category_with_rat.entity_image, :entity_name => city_or_sub_category_with_rat.entity_name,  :rating_count => city_or_sub_category_with_rat.rating_count, :sub_category => city_or_sub_category_with_rat.sub_category, :lat => city_or_sub_category_with_rat.lat , :longitude => city_or_sub_category_with_rat.longitude, :user_category_id =>  city_or_sub_category_with_rat.user_category_id)
                 @entity_search << es
               end
             end
            elsif @user_entities_with_sub_category_or_city.present?
             @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
               @users = User.where(:id => sub_category_or_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => sub_category_or_city.api_id,:xcody => sub_category_or_city.xcody,:ycody => sub_category_or_city.ycody,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                 @entity_search << es
               end
             end
            elsif @user_entities_with_only_city.present?
             @user_entities_with_only_city.each do |with_city|
               @users = User.where(:id => with_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_city.api_id,:xcody => with_city.xcody,:ycody => with_city.ycody,:caputredDeviceOrientation => with_city.caputredDeviceOrientation,:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => with_city.rating_count, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id)
                 @entity_search << es
               end
             end
            elsif @user_entities_with_only_sub_category.present?
             @user_entities_with_only_sub_category.each do |with_sub_category|
               @users = User.where(:id => with_sub_category.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_sub_category.api_id,:xcody => with_sub_category.xcody,:ycody => with_sub_category.ycody,:caputredDeviceOrientation => with_sub_category.caputredDeviceOrientation,:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => with_sub_category.rating_count, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id)
                 @entity_search << es
               end
             end
          end
          end
          
           if !@entity_search.blank?
            format.json {render :json => @entity_search}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
        elsif @sort_setting.sort_by == "Proximity"
          center = Geocoder.coordinates(params[:address])
          @user_entities_proxy_all = UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_sub_category_and_city = UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_proxy_and_city_or_sub_category = UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name} | UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_sub_category_or_city = UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name} | UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_only_city = UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).uniq{|p| p.user_id && p.entity_name} | UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_only_sub_category = UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
          @user_entity_with_proxy = UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).uniq{|p| p.user_id && p.entity_name} | UserEntity.near(center,100).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).uniq{|p| p.user_id && p.entity_name}
          if @user_entities_proxy_all.present?
            @user_entities_proxy_all.each do |pro|
             @users = User.where(:id => pro.user_id)
             @users.each do |users|
               es = entity_search.merge(:api_id => pro.api_id,:xcody => pro.xcody,:ycody => pro.ycody,:caputredDeviceOrientation => pro.caputredDeviceOrientation,:user_entity_id => pro.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => pro.address, :comment => pro.comment, :entity_image => pro.entity_image, :entity_name => pro.entity_name,  :rating_count => pro.rating_count, :sub_category => pro.sub_category, :lat => pro.lat , :longitude => pro.longitude, :user_category_id =>  pro.user_category_id)
               @entity_search << es
             end
          end
          if !@entity_search.blank?
            format.json {render :json => @entity_search}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
        elsif @user_entities_with_sub_category_and_city.present?
          @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
            @users = User.where(:id => sub_category_and_city.user_id)
             @users.each do |users|
               es = entity_search.merge(:api_id => sub_category_and_city.api_id,:xcody => sub_category_and_city.xcody,:ycody => sub_category_and_city.ycody,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
               @entity_search << es
             end
          end
          if !@entity_search.blank?
            format.json {render :json => @entity_search}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
        elsif @user_entities_with_proxy_and_city_or_sub_category.present?
          @user_entities_with_proxy_and_city_or_sub_category.each do |proxy_and_city_or_sub_category|
            @users = User.where(:id => proxy_and_city_or_sub_category.user_id)
             @users.each do |users|
               es = entity_search.merge(:api_id => proxy_and_city_or_sub_category.api_id,:xcody => proxy_and_city_or_sub_category.xcody,:ycody => proxy_and_city_or_sub_category.ycody,:caputredDeviceOrientation => proxy_and_city_or_sub_category.caputredDeviceOrientation,:user_entity_id => proxy_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy_and_city_or_sub_category.address, :comment => proxy_and_city_or_sub_category.comment, :entity_image => proxy_and_city_or_sub_category.entity_image, :entity_name => proxy_and_city_or_sub_category.entity_name,  :rating_count => proxy_and_city_or_sub_category.rating_count, :sub_category => proxy_and_city_or_sub_category.sub_category, :lat => proxy_and_city_or_sub_category.lat , :longitude => proxy_and_city_or_sub_category.longitude, :user_category_id =>  proxy_and_city_or_sub_category.user_category_id)
               @entity_search << es
             end
          end
          if !@entity_search.blank?
            format.json {render :json => @entity_search}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
        elsif @user_entities_with_sub_category_or_city.present?
          @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
            @users = User.where(:id => sub_category_or_city.user_id)
             @users.each do |users|
               es = entity_search.merge(:api_id => sub_category_or_city.api_id,:xcody => sub_category_or_city.xcody,:ycody => sub_category_or_city.ycody,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
               @entity_search << es
             end
          end
          if !@entity_search.blank?
            format.json {render :json => @entity_search}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
          elsif @user_entities_with_only_city.present?
            @user_entities_with_only_city.each do |city|
             @users = User.where(:id => city.user_id)
              @users.each do |users|
               es = entity_search.merge(:api_id => city.api_id,:xcody => city.xcody,:ycody => city.ycody,:caputredDeviceOrientation => city.caputredDeviceOrientation,:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
               @entity_search << es
             end
            end
            if !@entity_search.blank?
            format.json {render :json => @entity_search}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
          elsif @user_entities_with_only_sub_category.present?
            @user_entities_with_only_sub_category.each do |sub_category|
             @users = User.where(:id => sub_category.user_id)
              @users.each do |users|
               es = entity_search.merge(:api_id => sub_category.api_id,:xcody => sub_category.xcody,:ycody => sub_category.ycody,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
               @entity_search << es
             end
            end
            if !@entity_search.blank?
            format.json {render :json => @entity_search}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
          elsif @user_entity_with_proxy.present?
            @user_entity_with_proxy.each do |proxy|
              @users = User.where(:id => proxy.user_id)
              @users.each do |users|
               es = entity_search.merge(:api_id => proxy.api_id,:xcody => proxy.xcody,:ycody => proxy.ycody,:caputredDeviceOrientation => proxy.caputredDeviceOrientation,:user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
               @entity_search << es
             end
            end
            if !@entity_search.blank?
            format.json {render :json => @entity_search}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
          else
             format.json {render :json => {:message => "There is no data"}}
          end
        elsif @sort_setting.sort_by == "Friend"
           friends = Array.new
           @user_c = UserCategory.where(:id => params[:user_category_id]).first
           @friends = Relatoinship.where(:user_id => @sort_setting.user_id)
           @friends.each do |friend|
              friends << friend.friend_user_id
           end
            friends.each do |fr|
             @categories = UserCategory.where(:master_category_id => params[:master_category_id], :user_id => fr).uniq {|p| p.user_id}
             @categories.each do |cate|
               puts"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#{cate.inspect}"
                cat = cate.id
                @user_entities_friends_all = UserEntity.where(:user_category_id => cat.to_s, :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => cat.to_s, :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
                @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => cat.to_s,:entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => cat.to_s,:sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
                @user_entities_with_friends_and_city_or_sub_category = UserEntity.where(:user_category_id => cat.to_s,  :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => cat.to_s,  :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name}
                @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => cat.to_s,  :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => cat.to_s,  :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name}
                @user_entities_with_only_city = UserEntity.where(:user_category_id => cat.to_s, :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => cat.to_s, :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).uniq{|p| p.user_id && p.entity_name}
                @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => cat.to_s, :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => cat.to_s, :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
                @user_entity_with_friends = UserEntity.where(:user_category_id => params[:user_category_id], :entity_name => /.*#{params[:entity_name][:char]}*./i).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => params[:user_category_id], :sub_category => /.*#{params[:entity_name][:char]}*./i).uniq{|p| p.user_id && p.entity_name}
                if @user_entities_friends_all.present?
                  @user_entities_friends_all.each do |friends_all|
                    @user = User.where(:id => friends_all.user_id).uniq{|p| p.id}
                    @user.each do |users|
                      es = entity_search.merge(:api_id => friends_all.api_id,:xcody => friends_all.xcody,:ycody => friends_all.ycody,:caputredDeviceOrientation => friends_all.caputredDeviceOrientation,:user_entity_id => friends_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => friends_all.address, :comment => friends_all.comment, :entity_image => friends_all.entity_image, :entity_name => friends_all.entity_name,  :rating_count => friends_all.rating_count, :sub_category => friends_all.sub_category, :lat => friends_all.lat , :longitude => friends_all.longitude, :user_category_id =>  friends_all.user_category_id)
                      @entity_search << es
                   end
                  end
                  if !@entity_search.blank?
                         format.json {render :json => @entity_search}
                      else
                         format.json {render :json => {:message => "Search not found"} }
                      end
                elsif @user_entities_with_sub_category_and_city.present?
                  @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                    @user = User.where(:id => sub_category_and_city.user_id)
                    @user.each do |users|
                      es = entity_search.merge(:api_id => sub_category_and_city.api_id,:xcody => sub_category_and_city.xcody,:ycody => sub_category_and_city.ycody,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                      @entity_search << es
                   end
                                
                   end
                   if !@entity_search.blank?
                         format.json {render :json => @entity_search}
                      else
                         format.json {render :json => {:message => "Search not found"} }
                      end
                 elsif @user_entities_with_friends_and_city_or_sub_category.present?
                     @user_entities_with_friends_and_city_or_sub_category.each do |with_friend_and_city_or_sub_category|
                     @user = User.where(:id => with_friend_and_city_or_sub_category.user_id)
                     @user.each do |users|
                        es = entity_search.merge(:api_id => with_friend_and_city_or_sub_category.api_id,:xcody => with_friend_and_city_or_sub_category.xcody,:ycody => with_friend_and_city_or_sub_category.ycody,:caputredDeviceOrientation => with_friend_and_city_or_sub_category.caputredDeviceOrientation,:user_entity_id => with_friend_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_friend_and_city_or_sub_category.address, :comment => with_friend_and_city_or_sub_category.comment, :entity_image => with_friend_and_city_or_sub_category.entity_image, :entity_name => with_friend_and_city_or_sub_category.entity_name,  :rating_count => with_friend_and_city_or_sub_category.rating_count, :sub_category => with_friend_and_city_or_sub_category.sub_category, :lat => with_friend_and_city_or_sub_category.lat , :longitude => with_friend_and_city_or_sub_category.longitude, :user_category_id =>  with_friend_and_city_or_sub_category.user_category_id)
                        @entity_search << es
                     end
                    end
                    if !@entity_search.blank?
                         format.json {render :json => @entity_search}
                      else
                         format.json {render :json => {:message => "Search not found"} }
                      end
                  elsif @user_entities_with_sub_category_or_city.present?
                    @user_entities_with_sub_category_or_city.each do |with_sub_category_or_city|
                        @user = User.where(:id => with_sub_category_or_city.user_id)
                        @user.each do |users|
                           es = entity_search.merge(:api_id => with_sub_category_or_city.api_id,:xcody => with_sub_category_or_city.xcody,:ycody => with_sub_category_or_city.ycody,:caputredDeviceOrientation => with_sub_category_or_city.caputredDeviceOrientation,:user_entity_id => with_sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category_or_city.address, :comment => with_sub_category_or_city.comment, :entity_image => with_sub_category_or_city.entity_image, :entity_name => with_sub_category_or_city.entity_name,  :rating_count => with_sub_category_or_city.rating_count, :sub_category => with_sub_category_or_city.sub_category, :lat => with_sub_category_or_city.lat , :longitude => with_sub_category_or_city.longitude, :user_category_id =>  with_sub_category_or_city.user_category_id)
                           @entity_search << es
                        end
                    end
                    if !@entity_search.blank?
                         format.json {render :json => @entity_search}
                      else
                         format.json {render :json => {:message => "Search not found"} }
                      end
                  elsif @user_entities_with_only_city.present?
                    @user_entities_with_only_city.each do |with_city|
                      @user = User.where(:id => with_city.user_id)
                      @user.each do |users|
                         es = entity_search.merge(:api_id => with_city.api_id,:xcody => with_city.xcody,:ycody => with_city.ycody,:caputredDeviceOrientation => with_city.caputredDeviceOrientation,:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => with_city.rating_count, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id)
                         @entity_search << es
                      end
                    end
                    if !@entity_search.blank?
                         format.json {render :json => @entity_search}
                      else
                         format.json {render :json => {:message => "Search not found"} }
                      end
                  elsif @user_entities_with_only_sub_category.present?
                    @user_entities_with_only_sub_category.each do |with_sub_category|
                      @user = User.where(:id => with_sub_category.user_id)
                      @user.each do |users|
                         es = entity_search.merge(:api_id => with_sub_category.api_id,:xcody => with_sub_category.xcody,:ycody => with_sub_category.ycody,:caputredDeviceOrientation => with_sub_category.caputredDeviceOrientation,:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => with_sub_category.rating_count, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id)
                         @entity_search << es
                      end
                    end
                    if !@entity_search.blank?
                         format.json {render :json => @entity_search}
                      else
                         format.json {render :json => {:message => "Search not found"} }
                      end
                  elsif @user_entity_with_friends.present?
                    @user_entity_with_friends.each do |with_friends|
                      @user = User.where(:id => with_friends.user_id)
                      @user.each do |users|
                         es = entity_search.merge(:api_id => with_friends.api_id,:xcody => with_friends.xcody,:ycody => with_friends.ycody,:caputredDeviceOrientation => with_friends.caputredDeviceOrientation,:user_entity_id => with_friends.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_friends.address, :comment => with_friends.comment, :entity_image => with_friends.entity_image, :entity_name => with_friends.entity_name,  :rating_count => with_friends.rating_count, :sub_category => with_friends.sub_category, :lat => with_friends.lat , :longitude => with_friends.longitude, :user_category_id =>  with_friends.user_category_id)
                         @entity_search << es
                      end
                    end
                      if !@entity_search.blank?
                         format.json {render :json => @entity_search}
                      else
                         format.json {render :json => {:message => "Search not found"} }
                      end
                else
                   format.json {render :json => {:message => "There is no data"}}
                  end
             end
           end
         elsif @sort_setting.sort_by == "All"

user_entity = {}
    @rating = Array.new

      @get_entity_user =  UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id]).paginate(:page => params[:page],:per_page => 10).uniq {|p|  p.entity_name}
      @get_entity_user.each do |entity|
      df = entity.id
     @ratings = Rating.where(:user_entity_id => df.to_s).all
     if @ratings.present?
           @ratings.each do |rat|
             @rating << rat.rating_count
           end
          cd = (entity.rating_count).to_i
          @rating << cd
          total = 0
          average = 0
        @rating.each do |item|
           total += item
        end
        average = total / @rating.length
      else
        if entity.rating_count == 0
          average = "0"
        else
          @rating << (entity.rating_count).to_i
          total = 0
          average = 0
          @rating.each do |item|
           total += item
        end
        
        end
        average = total / @rating.length
     end
     @user = User.where(:id => entity.user_id)
      @user.each do |user|
        us = entity_search.merge(:api_id => entity.api_id,:xcody => entity.xcody,:ycody => entity.ycody,:caputredDeviceOrientation => entity.caputredDeviceOrientation,:user_id => user.id, :profile_picture => user.profile_picture_url,:user_name => user.first_name, :user_category_id =>entity.user_category_id, :entity_name => entity.entity_name,:entity_image => entity.entity_image, :user_entity_id =>entity.id, :rating_count => average )
       entity_search << us
       end
if !@entity_search.blank?
    format.json {render :json => @entity_search}
else
    format.json {render :json => {:message => "There is no entity"} }
end
      end
         end
         elsif params[:search] == "weliike"

           entity_search = {}
            @entity_search = Array.new
            @category_relations = Array.new
            @rating = Array.new
            @cate = Array.new
            @api_id = Array.new
            @poster = Array.new
            @posters = Array.new
            @api_id_po = Array.new
           if @sort_setting.sort_by == "Rating"
              q = "#{params[:entity_name][:char]}"
             @user_relations = UserCategoryRelation.where(:user_id => @sort_setting.user_id, :user_category_id => params[:user_category_id],:is_active => "true")
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         @category_relations.push(params[:user_id])
              @category_relations.each do |user_re|
                @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
                @user_category_id.each do |catee|
                  @cate << catee.id
                end
              end
        @user_entities_with_sub_category_and_city = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc])|UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc])).group_by { |t| t.api_id }
         @user_entities_with_only_city = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc])|UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc])).group_by { |t| t.api_id }
         @user_entities_with_only_sub_category = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc])| UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc])).group_by { |t| t.api_id }
         @user_entity_with_recent = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).order_by([:rating_count,:desc])|UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).order_by([:rating_count,:desc])).group_by { |t| t.api_id }
  if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_recent.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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

                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                       @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end

                 @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]}  && @entity_search.sort_by { |k| k["rating_count"]}
       if !@final_data.blank?
          format.json {render :json => @final_data.uniq}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
         elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
               @user_entities_with_sub_category_and_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else

                     @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end

           @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end


          @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]}  && @entity_search.sort_by { |k| k["rating_count"]}
       if !@final_data.blank?
          format.json {render :json => @final_data}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
            else
              if @user_entities_recent_all.present?

                 elsif @user_entities_with_sub_category_and_city.present?
                    @user_entities_with_sub_category_and_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                         we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                       @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end

                 elsif @user_entities_with_recent_and_city_or_sub_category.present?
                    @user_entities_with_recent_and_city_or_sub_category.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                     @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end

             @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
            elsif @user_entities_with_only_sub_category.present?
                    @user_entities_with_only_sub_category.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                             @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else

                      @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
                @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
              elsif @user_entities_with_only_city.present?
                    @user_entities_with_only_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                             @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                     @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
           end
       @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]}
       if !@final_data.blank?
         format.json {render :json =>@final_data}
         # format.json {render :json =>@final_data}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
         end

            elsif @sort_setting.sort_by == "Proximity"
     q = "#{params[:entity_name][:char]}"
        userss = Array.new
                  center = Geocoder.coordinates(params[:address])
                  @category_relations = Array.new
                  cd = @sort_setting.user_id
                  @user_relations = UserCategoryRelation.where(:user_id => @sort_setting.user_id, :user_category_id => params[:user_category_id], :is_active => "true")
                  @user_relations.each do |user_relation|
                    @category_relations << user_relation.friend_user_id
                  end
                    @category_relations.each do |user_re|
                @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
                @user_category_id.each do |catee|
                  @cate << catee.id
                end
              end
                @user_entity_with_proxy = (UserEntity.near(center, 10000000).and.in(:user_category_id => @cate).where(:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE),:is_active => "true")|UserEntity.near(center, 10000000).and.in(:user_category_id => @cate).where(:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE))) .group_by { |t| t.api_id }
                @user_entities_proxy_all = (UserEntity.near(center,10000000).and.in(:user_category_id => @cate,:sub_category => @sort_setting.narrow_by_sub_category).where(:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE),:is_active => "true")| UserEntity.near(center,10000000).and.in(:user_category_id => @cate,:sub_category => @sort_setting.narrow_by_sub_category).where(:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE),:is_active => "true")).group_by { |t| t.api_id }
                           if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
                              @user_entity_with_proxy.each do | (key, value) |
                                value.each do |proxy|
                                  if proxy.api_id.nil?
                           ue = proxy.id
                           if proxy.user_id == params[:user_id] && proxy.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>proxy.id )
                             if @ratings.present?
                                @ratings.each do |rat|
                                    @rating << rat.rating_count
                                end
                                cd = (proxy.rating_count).to_i
                                @rating << cd
                                total = 0
                                @rating.each do |item|
                                   total += item
                                end
                                average = total / @rating.length
                              else
                                  if proxy.rating_count == "0"
                                     average = "0"
                                  else
                                     @rating << (proxy.rating_count).to_i
                                     total = 0
                                     average = 0
                                     @rating.each do |item|
                                        total += item
                                     end
                                     average = total / @rating.length
                                  end
                             end
                       else
                         average = proxy.rating_count
                       end
                        distance = 0
                                distance= Geocoder::Calculations.distance_between(center, [proxy.lat, proxy.longitude])
                                @users = User.where(:id => proxy.user_id)
                                @users.each do |users|

                                  es = entity_search.merge(:ycody => proxy.ycody,:xcody => proxy.xcody,:city => proxy.city,:distance => distance.to_s, :is => "Proxy",:coordinates => proxy.coordinates, :user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
                                  @entity_search << es
                                end
                     else
                       @poster << key
                      end
                      @posters << proxy.id
                  end
              end

          @user_entiy_for_api = UserEntity.near(center, 10000000).and.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                            distance = 0
                              distance= Geocoder::Calculations.distance_between(center, [user_entity.lat, user_entity.longitude])
                                 @user = User.where(:id => user_entity.user_id)
                                    @user.each do |users|

                                        es = entity_search.merge(:created_at => @post.created_at,:ycody => user_entity.ycody,user_entity => user_entity.xcody,:city => user_entity.city,:distance => distance.to_s, :is => "Proxy",:coordinates => user_entity.coordinates, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                                        @entity_search << es
                                    end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end
 distance = 0
                              distance = Geocoder::Calculations.distance_between(center, [user_entity.lat, user_entity.longitude])
                                 @user = User.where(:id => user_entity.user_id)
                                    @user.each do |users|

                                        es = entity_search.merge(:ycody => user_entity.ycody,user_entity => user_entity.xcody,:city => user_entity.city,:distance => distance.to_s, :is => "Proxy",:coordinates => user_entity.coordinates, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                                        @entity_search << es
                                    end
                   end
                end


                           else

 @user_entities_proxy_all.each do | (key, value) |
                                value.each do |proxy|
                                  if proxy.api_id.nil?
                           ue = proxy.id
                           if proxy.user_id == params[:user_id] && proxy.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>proxy.id )
                             if @ratings.present?
                                @ratings.each do |rat|
                                    @rating << rat.rating_count
                                end
                                cd = (proxy.rating_count).to_i
                                @rating << cd
                                total = 0
                                @rating.each do |item|
                                   total += item
                                end
                                average = total / @rating.length
                              else
                                  if proxy.rating_count == "0"
                                     average = "0"
                                  else
                                     @rating << (proxy.rating_count).to_i
                                     total = 0
                                     average = 0
                                     @rating.each do |item|
                                        total += item
                                     end
                                     average = total / @rating.length
                                  end
                             end
                       else
                         average = proxy.rating_count
                       end
                        distance = 0
                                distance= Geocoder::Calculations.distance_between(center, [proxy.lat, proxy.longitude])
                                @users = User.where(:id => proxy.user_id)
                                @users.each do |users|

                                  es = entity_search.merge(:ycody => proxy.ycody,:xcody => proxy.xcody,:city => proxy.city,:distance => distance.to_s, :is => "Proxy",:coordinates => proxy.coordinates, :user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
                                  @entity_search << es
                                end
                     else
                       @poster << key
                      end
                      @posters << proxy.id
                  end
              end

          @user_entiy_for_api = UserEntity.near(center, 10000000).and.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                            distance = 0
                              distance= Geocoder::Calculations.distance_between(center, [user_entity.lat, user_entity.longitude])
                                 @user = User.where(:id => user_entity.user_id)
                                    @user.each do |users|

                                        es = entity_search.merge(:created_at => @post.created_at,:ycody => user_entity.ycody,user_entity => user_entity.xcody,:city => user_entity.city,:distance => distance.to_s, :is => "Proxy",:coordinates => user_entity.coordinates, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                                        @entity_search << es
                                    end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end
 distance = 0
                              distance = Geocoder::Calculations.distance_between(center, [user_entity.lat, user_entity.longitude])
                                 @user = User.where(:id => user_entity.user_id)
                                    @user.each do |users|

                                        es = entity_search.merge(:ycody => user_entity.ycody,user_entity => user_entity.xcody,:city => user_entity.city,:distance => distance.to_s, :is => "Proxy",:coordinates => user_entity.coordinates, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                                        @entity_search << es
                                    end
                   end
                end
                           end
                  @final_data = @entity_search.sort{|a,b| [a[:user_id]] <=> [b[:user_id]] && [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["distance"]}
                #    @final_data =  @entity_search.sort_by { |k| k["distance"]}
                    if !@final_data.blank?
                          format.json {render :json => @final_data.uniq}
                       else
                          format.json {render :json => {:message => "Search not found"} }
                       end

            elsif @sort_setting.sort_by == "Recent"
              q = "#{params[:entity_name][:char]}"
               @user_relations = UserCategoryRelation.where(:user_id => @sort_setting.user_id, :user_category_id => params[:user_category_id],:is_active => "true")
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
              @category_relations.each do |user_re|
                @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
                @user_category_id.each do |catee|
                  @cate << catee.id
                end
              end

             @user_entities_with_sub_category_and_city = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc")|UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc")).group_by { |t| t.api_id }
         @user_entities_with_only_city = (UserEntity.where(:is_active => "true",:entity_name =>  Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city) | UserEntity.where(:is_active => "true",:sub_category =>  Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city)).group_by { |t| t.api_id }
         @user_entities_with_only_sub_category = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc")| UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc") ).group_by { |t| t.api_id }
         @user_entity_with_recent = (UserEntity.where(:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE),:is_active => "true").in(:user_category_id => @cate).order_by(:created_at => "desc")| UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).order_by(:created_at => "desc") ).group_by { |t| t.api_id }


#         @user_entities_with_sub_category_and_city = UserEntity.where(:is_active => "true",:entity_name => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc").group_by { |t| t.api_id }# | UserEntity.where(:is_active => "true",:sub_category => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc").group_by { |t| t.api_id }
#         @user_entities_with_only_city = UserEntity.where(:is_active => "true",:entity_name => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city).group_by { |t| t.api_id }# | UserEntity.where(:is_active => "true",:sub_category => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city).group_by { |t| t.api_id }
#         @user_entities_with_only_sub_category = UserEntity.where(:is_active => "true",:entity_name => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc").group_by { |t| t.api_id }# | UserEntity.where(:is_active => "true",:sub_category => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc").group_by { |t| t.api_id }
#         @user_entity_with_recent = UserEntity.where(:is_active => "true",:entity_name => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).order_by(:created_at => "desc").group_by { |t| t.api_id }# | @user_entity_with_recent = UserEntity.where(:is_active => "true",:sub_category => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).order_by(:created_at => "desc").group_by { |t| t.api_id }
         if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_recent.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                    #  @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)#, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                       @poster << key
                      end
                      @posters << user_entity.id
                  end
              end
          @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
       @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]} && @entity_search.sort_by { |thing| thing["created_at"] }
       if !@final_data.blank?
         format.json {render :json =>  @final_data.uniq}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
         elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
               @user_entities_with_sub_category_and_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:user_entities_with_sub_category_and_city =>"1",:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                          @entity_search << we
                       end
                     else
                         @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end

               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
          @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]}
       if !@final_data.blank?
          format.json {render :json => @final_data}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
            else
              if @user_entities_recent_all.present?

                 elsif @user_entities_with_sub_category_and_city.present?
                    @user_entities_with_sub_category_and_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                         we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                        else
                    @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end

            @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
                 elsif @user_entities_with_recent_and_city_or_sub_category.present?
                    @user_entities_with_recent_and_city_or_sub_category.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                         we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:jara => @jara,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                      @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
                  @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end

            elsif @user_entities_with_only_sub_category.present?
                    @user_entities_with_only_sub_category.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                             @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                      @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end

            @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
              elsif @user_entities_with_only_city.present?
                    @user_entities_with_only_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                             @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                         @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
           end
       @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]}
       if !@final_data.blank?
         format.json {render :json =>@final_data}
         # format.json {render :json =>@final_data}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
         end

              
            elsif @sort_setting.sort_by == "Friend"
               q = "#{params[:entity_name][:char]}"
              @rating = Array.new
        @user_relations = UserCategoryRelation.where(:user_id => @sort_setting.user_id, :user_category_id => params[:user_category_id],:is_active => "true")
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
              @category_relations.each do |user_re|
                @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
                @user_category_id.each do |catee|
                  @cate << catee.id
                end
              end


       @user_entities_with_sub_category_and_city = (UserEntity.in(:user_category_id =>@cate).where( :is_active => "true", :entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc')|UserEntity.in(:user_category_id =>@cate).where( :is_active => "true", :sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc')).group_by { |t| t.api_id }
         @user_entities_with_only_city = (UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:city => @sort_setting.narrow_by_city).order_by(:created_at => 'desc')|UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:city => @sort_setting.narrow_by_city).order_by(:created_at => 'desc')).group_by { |t| t.api_id }
         @user_entities_with_only_sub_category = (UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc')|UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc')).group_by { |t| t.api_id }
         @user_entity_with_friends = (UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).order_by(:created_at => 'desc')|UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).order_by(:created_at => 'desc')).group_by { |t| t.api_id }


#         @user_entities_with_sub_category_and_city = UserEntity.in(:user_category_id =>@cate).where( :is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc').group_by { |t| t.api_id }# | UserEntity.in(:user_category_id =>@cate).where( :is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc').group_by { |t| t.api_id }
#         @user_entities_with_only_city = UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by(:created_at => 'desc').group_by { |t| t.api_id } #| UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by(:created_at => 'desc').group_by { |t| t.api_id }
#         @user_entities_with_only_sub_category = UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc').group_by { |t| t.api_id }# | UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc').group_by { |t| t.api_id }
#         @user_entity_with_friends = UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).order_by(:created_at => 'desc').group_by { |t| t.api_id }# | UserEntity.in(:user_category_id =>@cate).where(:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).order_by(:created_at => 'desc').group_by { |t| t.api_id }
         if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
            @user_entity_with_friends.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                           @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end


                @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]}
                 if !@final_data.blank?
                    format.json {render :json => @final_data}
                 else
                    format.json {render :json => {:message => "Search not found"} }
                 end
             elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_with_sub_category_and_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else

                      @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end

          @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end

                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
                @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]}
                 if !@final_data.blank?
                    format.json {render :json => @final_data}
                 else
                    format.json {render :json => {:message => "Search not found"} }
                 end
            else
               if @user_entities_friends_all.present?
                    @user_entities_friends_all.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                       @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end

            @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
             elsif @user_entities_with_sub_category_and_city.present?
                    @user_entities_with_sub_category_and_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                         @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
                @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
             elsif @user_entities_with_friends_and_city_or_sub_category.present?
                      @user_entities_with_friends_and_city_or_sub_category.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                         we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                        @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
                @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
             elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                             @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                        @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
             elsif @user_entities_with_only_city.present?
                   @user_entities_with_only_city.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                          we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                     @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
             elsif @user_entities_with_only_sub_category.present?
                    @user_entities_with_only_sub_category.each do | (key, value) |
                   value.each do |user_entity|
                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
                      @user_category.each do |cat|
                        if user_entity.api_id.nil?
                           ue = user_entity.id
                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                              @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                       else
                         average = user_entity.rating_count
                       end
                       @user = User.where(:id => user_entity.user_id)
                       @user.each do |user|
                         we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
                          @entity_search << we
                       end
                     else
                    @poster << key
                      end
                      @posters << user_entity.id
                    end
                  end
               end
               @user_entiy_for_api = UserEntity.in(:api_id => @poster, :id => @posters).uniq{|p| p.api_id}
               @user_entiy_for_api.each do |user_entity|
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_active => "true").last
                   if @post.present?
                      if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:created_at => user_entity.created_at,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   else
                     if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>user_entity.id )
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
                           else
                               average = user_entity.rating_count
                           end

                           @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                              we = entity_search.merge(:created_at => user_entity.created_at,:api_id => user_entity.api_id,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
             end
             @final_data = @entity_search.sort{|a,b| [a[:user_id]] <=> [b[:user_id]] && [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["created_at"]}
              if !@final_data.blank?
                format.json {render :json => @final_data}
              else
                format.json {render :json => {:message =>  "search not found"}}
              end
          end

            elsif @sort_setting.sort_by == "All"
@rating = Array.new
  @category_relations = Array.new
    @user_relations = UserCategoryRelation.where(:user_id => params[:user_id], :user_category_id => params[:user_category_id]).paginate(:page => params[:page],:per_page => 6)
    @user_relations.each do |user_relation|
      @category_relations << user_relation.friend_user_id
    end
     @category_relations.push(params[:user_id])
    @category_relations.each do |user_re|
      @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
      @user_category_id.each do |cat|
        @user_entity = UserEntity.where(:user_category_id => cat.id).uniq {|p|  p.entity_name}
        @user_entity.each do |user_entity|
          ue = user_entity.id
          @ratings = Rating.where(:user_entity_id =>  ue.to_s )
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
            we = entity_search.merge(:api_id => user_entity.api_id,:xcody => user_entity.xcody,:ycody => user_entity.ycody,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:user_id => user.id, :profile_picture => user.profile_picture_url, :user_name => user.first_name, :entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image, :entity_id => user_entity.id, :master_category_id => cat.master_category_id ,:rating_count => average)
            @entity_search << we
          end
        end
      end
    end
    if !@entity_search.blank?
   format.json {render :json => @entity_search}
else
   format.json {render :json => {:message => "There is no data"}}
end
           end
       
      elsif params[:search] == "trends"
        if @sort_setting.sort_by == "Rating"
       user_category = UserCategory.where(:master_category_id => params[:master_category_id])#.uniq{|p| p.user_id && p.master_category_id}
       user_category.each do |category|
          @user_relations = UserCategoryRelation.where(:user_category_id => category.id).uniq {|p|  p.user_id}
          @user_relations.each do |user_relation|
            cate = user_relation.user_category_id
             @user_entities_rat_all = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p|  p.entity_name}
             @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p|  p.entity_name}
              @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).order_by(:rating_count => "desc").uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).order_by(:rating_count => "desc").uniq{|p| p.entity_name}
              @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count => "desc").uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count => "desc").uniq{|p|  p.entity_name}
              @user_entities_with_only_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by(:rating_count => "desc").uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by(:rating_count => "desc").uniq{|p| p.entity_name}
              @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count => "desc").uniq{|p|  p.entity_name}
              @user_entity_with_rating = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).order_by(:rating_count => "desc").uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).order_by(:rating_count => "desc").uniq{|p| p.entity_name}

              if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_rating.each do |with_rating|
               ue = with_rating.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (with_rating.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if with_rating.rating_count == "0"
                      average = "0"
                    else
                      @rating << (with_rating.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => with_rating.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_rating.api_id,:caputredDeviceOrientation => with_rating.caputredDeviceOrientation,:ycody => with_rating.ycody,:xcody => with_rating.xcody,:is => "Rating",:user_entity_id => with_rating.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_rating.address, :comment => with_rating.comment, :entity_image => with_rating.entity_image, :entity_name => with_rating.entity_name,  :rating_count => average.to_s, :sub_category => with_rating.sub_category, :lat => with_rating.lat , :longitude => with_rating.longitude, :user_category_id =>  with_rating.user_category_id)
                 @entity_search << es
               end
             end
elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:api_id => rating_all.api_id,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:is => "Rating",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end
              else
              if @user_entities_rat_all.present?
             @user_entities_rat_all.each do |user_entity|
                        ue = user_entity.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
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
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => average.to_s, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_and_city.present?
             @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                   ue = sub_category_and_city.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (sub_category_and_city.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if sub_category_and_city.rating_count == "0"
                      average = "0"
                    else
                      @rating << (sub_category_and_city.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
                 @users = User.where(:id => sub_category_and_city.user_id)
                 @users.each do |users|
                   es = entity_search.merge(:api_id => sub_category_and_city.api_id,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:is => "Rating",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => average.to_s, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                   @entity_search << es
               end
             end
           elsif @user_entities_with_rat_and_city_or_sub_category.present?
             @user_entities_with_rat_and_city_or_sub_category.each do |city_or_sub_category_with_rat|
               ue = city_or_sub_category_with_rat.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (city_or_sub_category_with_rat.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if city_or_sub_category_with_rat.rating_count == "0"
                      average = "0"
                    else
                      @rating << (city_or_sub_category_with_rat.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => city_or_sub_category_with_rat.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => city_or_sub_category_with_rat.api_id,:caputredDeviceOrientation => city_or_sub_category_with_rat.caputredDeviceOrientation,:ycody => city_or_sub_category_with_rat.ycody,:xcody => city_or_sub_category_with_rat.xcody,:is => "Rating",:user_entity_id => city_or_sub_category_with_rat.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city_or_sub_category_with_rat.address, :comment => city_or_sub_category_with_rat.comment, :entity_image => city_or_sub_category_with_rat.entity_image, :entity_name => city_or_sub_category_with_rat.entity_name,  :rating_count => average.to_s, :sub_category => city_or_sub_category_with_rat.sub_category, :lat => city_or_sub_category_with_rat.lat , :longitude => city_or_sub_category_with_rat.longitude, :user_category_id =>  city_or_sub_category_with_rat.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_or_city.present?
             @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
               ue = sub_category_or_city.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (sub_category_or_city.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if sub_category_or_city.rating_count == "0"
                      average = "0"
                    else
                      @rating << (sub_category_or_city.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => sub_category_or_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => sub_category_or_city.api_id,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:is => "Rating",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => average.to_s, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_city.present?
             @user_entities_with_only_city.each do |with_city|
               ue = with_city.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (with_city.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if with_city.rating_count == "0"
                      average = "0"
                    else
                      @rating << (with_city.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => with_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_city.api_id,:caputredDeviceOrientation => with_city.caputredDeviceOrientation,:ycody => with_city.ycody,:xcody => with_city.xcody,:is => "Rating",:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => average.to_s, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_sub_category.present?
             @user_entities_with_only_sub_category.each do |with_sub_category|
               ue = with_sub_category.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (with_sub_category.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if with_sub_category.rating_count == "0"
                      average = "0"
                    else
                      @rating << (with_sub_category.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => with_sub_category.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_sub_category.api_id,:caputredDeviceOrientation => with_sub_category.caputredDeviceOrientation,:ycody => with_sub_category.ycody,:xcody => with_sub_category.xcody,:is => "Rating",:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => average.to_s, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id)
                 @entity_search << es
               end
             end
           end

              end
          end
       end
         @entity_search.sort_by { |k| k["rating_count"]}
             if !@entity_search.blank?
                format.json {render :json => @entity_search}
              else
                format.json {render :json => {:message =>  "search not found"}}
              end

        elsif @sort_setting.sort_by == "Proximity"
          center = Geocoder.coordinates(params[:address])
       user_category = UserCategory.where(:master_category_id => params[:master_category_id])#.uniq{|p| p.user_id && p.master_category_id}
       user_category.each do |category|
         categories_for = category.id
          @user_relations = UserCategoryRelation.where(:user_category_id => categories_for.to_s).uniq {|p|  p.user_id}
          @user_relations.each do |user_relation|
            cate = user_relation.user_category_id

              if @sort_setting.narrow_by_sub_category.empty?
                 @user_entity_with_proxy = UserEntity.near(center,10000000).and.where(:user_category_id => cate.to_s, :entity_name => /.*#{params[:entity_name][:char]}*./i,:is_active => "true").uniq{|p| p.user_id && p.entity_name}
                 @user_entity_with_proxy.each do |proxy|
                   distance = 0
                   distance= Geocoder::Calculations.distance_between(center, [proxy.lat, proxy.longitude])
              ue = proxy.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (proxy.rating_count).to_i
                      @rating << cd
                      total = 0
                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if proxy.rating_count == "0"
                      average = "0"
                    else
                      @rating << (proxy.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
              @users = User.where(:id => proxy.user_id)
              @users.each do |users|
               es = entity_search.merge(:api_id => proxy.api_id,:caputredDeviceOrientation => proxy.caputredDeviceOrientation,:ycody => proxy.ycody,:xcody => proxy.xcody,:distance => distance.to_s, :is => "Proxy",:user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
               @entity_search << es
             end
            end
              else
                @user_entities_with_only_sub_category = UserEntity.near(center,10000000).and.where(:user_category_id => cate.to_s, :is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
                @user_entities_with_only_sub_category.each do |sub_category|
                  distance = 0
                  distance= Geocoder::Calculations.distance_between(center, [sub_category.lat, sub_category.longitude])
              ue = sub_category.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (sub_category.rating_count).to_i
                      @rating << cd
                      total = 0
                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if sub_category.rating_count == "0"
                      average = "0"
                    else
                      @rating << (sub_category.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
             @users = User.where(:id => sub_category.user_id)
              @users.each do |users|
               es = entity_search.merge(:api_id => sub_category.api_id,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:distance => distance.to_s, :is => "Proxy",:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
               @entity_search << es
             end
            end
              end

          end
       end
       @final_data =  @entity_search.sort_by { |k| k["distance"]}
       if !@final_data.blank?
          format.json {render :json => @final_data}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
     elsif @sort_setting.sort_by == "Recent"
        @traids = Array.new
         weliike ={}
         user_category = UserCategory.where(:master_category_id => params[:master_category_id])
         user_category.each do |category|
         @user_relations = UserCategoryRelation.where(:user_category_id => category.id).uniq {|p|  p.user_id}
         @user_relations.each do |user_relation|
          @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_recent_and_city_or_sub_category = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_only_city = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).uniq{|p| p.user_id && p.entity_name}
          @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p| p.user_id && p.entity_name}
          @user_entity_with_recent = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name} | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).order_by(:created_at => "desc").uniq{|p| p.user_id && p.entity_name}
          if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
            @user_entity_with_recent.each do |with_rating|
               ue = with_rating.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (with_rating.rating_count).to_i
                      @rating << cd
                      total = 0
                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                  if with_rating.rating_count == "0"
                      average = "0"
                    else
                      @rating << (with_rating.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => with_rating.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_rating.api_id,:caputredDeviceOrientation => with_rating.caputredDeviceOrientation,:ycody => with_rating.ycody,:xcody => with_rating.xcody,:is => "Recent", :created_at => with_rating.created_at, :user_entity_id => with_rating.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_rating.address, :comment => with_rating.comment, :entity_image => with_rating.entity_image, :entity_name => with_rating.entity_name,  :rating_count => with_rating.rating_count, :sub_category => with_rating.sub_category, :lat => with_rating.lat , :longitude => with_rating.longitude, :user_category_id =>  with_rating.user_category_id)
                 @entity_search << es
               end
             end
           elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
             @user_entities_recent_all.each do |user_entity|
               ue = user_entity.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
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
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Recent", :created_at => user_entity.created_at, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                 @entity_search << es
               end
             end
          else
            if @user_entities_recent_all.present?
             @user_entities_recent_all.each do |user_entity|
               ue = user_entity.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
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
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:caputredDeviceOrientation => user_entity.caputredDeviceOrientation,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Recent", :created_at => user_entity.created_at, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                 @entity_search << es
               end
             end
             @finals = @entity_search.uniq{|p| p[:user_entity_id]}
           elsif @user_entities_with_sub_category_and_city.present?
             @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
               ue = sub_category_and_city.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (sub_category_and_city.rating_count).to_i
                      @rating << cd
                      total = 0
                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                  if sub_category_and_city.rating_count == "0"
                      average = "0"
                    else
                      @rating << (sub_category_and_city.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
                 @users = User.where(:id => sub_category_and_city.user_id)
                 @users.each do |users|
                   es = entity_search.merge(:api_id => sub_category_and_city.api_id,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:is => "Recent", :created_at => sub_category_and_city.created_at, :user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                   @entity_search << es
               end
             end
           elsif @user_entities_with_recent_and_city_or_sub_category.present?
             @user_entities_with_recent_and_city_or_sub_category.each do |city_or_sub_category_with_rat|
               ue = city_or_sub_category_with_rat.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (city_or_sub_category_with_rat.rating_count).to_i
                      @rating << cd
                      total = 0
                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                  if city_or_sub_category_with_rat.rating_count == "0"
                      average = "0"
                    else
                      @rating << (city_or_sub_category_with_rat.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => city_or_sub_category_with_rat.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => city_or_sub_category_with_rat.api_id,:caputredDeviceOrientation => city_or_sub_category_with_rat.caputredDeviceOrientation,:ycody => city_or_sub_category_with_rat.ycody,:xcody => city_or_sub_category_with_rat.xcody,:is => "Recent", :created_at => city_or_sub_category_with_rat.created_at, :user_entity_id => city_or_sub_category_with_rat.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city_or_sub_category_with_rat.address, :comment => city_or_sub_category_with_rat.comment, :entity_image => city_or_sub_category_with_rat.entity_image, :entity_name => city_or_sub_category_with_rat.entity_name,  :rating_count => city_or_sub_category_with_rat.rating_count, :sub_category => city_or_sub_category_with_rat.sub_category, :lat => city_or_sub_category_with_rat.lat , :longitude => city_or_sub_category_with_rat.longitude, :user_category_id =>  city_or_sub_category_with_rat.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_or_city.present?
             @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
               ue = sub_category_or_city.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (sub_category_or_city.rating_count).to_i
                      @rating << cd
                      total = 0
                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                  if sub_category_or_city.rating_count == "0"
                      average = "0"
                    else
                      @rating << (sub_category_or_city.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => sub_category_or_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => sub_category_or_city.api_id,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:is => "Recent", :created_at => sub_category_or_city.created_at, :user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_city.present?
             @user_entities_with_only_city.each do |with_city|
               ue = with_city.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (with_city.rating_count).to_i
                      @rating << cd
                      total = 0
                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                  if with_city.rating_count == "0"
                      average = "0"
                    else
                      @rating << (with_city.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => with_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_city.api_id,:caputredDeviceOrientation => with_city.caputredDeviceOrientation,:ycody => with_city.ycody,:xcody => with_city.xcody,:is => "Recent", :created_at => with_city.created_at, :user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => with_city.rating_count, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_sub_category.present?
             @user_entities_with_only_sub_category.each do |with_sub_category|
               ue = with_sub_category.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (with_sub_category.rating_count).to_i
                      @rating << cd
                      total = 0
                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                  if with_sub_category.rating_count == "0"
                      average = "0"
                    else
                      @rating << (with_sub_category.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
               @users = User.where(:id => with_sub_category.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_sub_category.api_id,:caputredDeviceOrientation => with_sub_category.caputredDeviceOrientation,:ycody => with_sub_category.ycody,:xcody => with_sub_category.xcody,:is => "Recent", :created_at => with_sub_category.created_at, :user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => with_sub_category.rating_count, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id)
                 @entity_search << es
               end
             end
          end
          end


         end
        end

          @finals = @entity_search.uniq{|p| p[:user_entity_id]}
            if !@finals.blank?
              format.json {render :json => @finals.uniq}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
        elsif @sort_setting.sort_by == "Friend"

         user_category = UserCategory.where(:master_category_id => params[:master_category_id])
         user_category.each do |category|
         @user_relations = UserCategoryRelation.where(:user_category_id => category.id).uniq {|p|  p.user_id}
         @user_relations.each do |user_relation|
           @user_entities_friends_all = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category) | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category)
                @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category) | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category)
                @user_entities_with_friends_and_city_or_sub_category = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}) | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category})
                @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}) | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category})
                @user_entities_with_only_city = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city) | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city)
                @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category) | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category)
                @user_entity_with_friends = UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i) | UserEntity.where(:user_category_id => user_relation.user_category_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i)

              if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
                @user_entity_with_friends.each do |with_friends|
                  @user = User.where(:id => with_friends.user_id)
                    @user.each do |users|
                       es = entity_search.merge(:api_id => with_friends.api_id,:caputredDeviceOrientation => with_friends.caputredDeviceOrientation,:ycody => with_friends.ycody,:xcody => with_friends.xcody,:user_entity_id => with_friends.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_friends.address, :comment => with_friends.comment, :entity_image => with_friends.entity_image, :entity_name => with_friends.entity_name,  :rating_count => with_friends.rating_count, :sub_category => with_friends.sub_category, :lat => with_friends.lat , :longitude => with_friends.longitude, :user_category_id =>  with_friends.user_category_id)
                       @entity_search << es
                   end
                 end

              elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
                @user_entities_friends_all.each do |friends_all|
                    @user = User.where(:id => friends_all.user_id)
                    @user.each do |users|
                      es = entity_search.merge(:api_id => friends_all.api_id,:caputredDeviceOrientation => friends_all.caputredDeviceOrientation,:ycody => friends_all.ycody,:xcody => friends_all.xcody,:user_entity_id => friends_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => friends_all.address, :comment => friends_all.comment, :entity_image => friends_all.entity_image, :entity_name => friends_all.entity_name,  :rating_count => friends_all.rating_count, :sub_category => friends_all.sub_category, :lat => friends_all.lat , :longitude => friends_all.longitude, :user_category_id =>  friends_all.user_category_id)
                      @entity_search << es
                   end
                  end
                  @finals = @entity_search.uniq{|p| p[:user_entity_id]}
              else
              if @user_entities_friends_all.present?
                  @user_entities_friends_all.each do |friends_all|
                    @user = User.where(:id => friends_all.user_id)
                    @user.each do |users|
                      es = entity_search.merge(:api_id => friends_all.api_id,:caputredDeviceOrientation => friends_all.caputredDeviceOrientation,:ycody => friends_all.ycody,:xcody => friends_all.xcody,:user_entity_id => friends_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => friends_all.address, :comment => friends_all.comment, :entity_image => friends_all.entity_image, :entity_name => friends_all.entity_name,  :rating_count => friends_all.rating_count, :sub_category => friends_all.sub_category, :lat => friends_all.lat , :longitude => friends_all.longitude, :user_category_id =>  friends_all.user_category_id)
                      @entity_search << es
                   end
                  end
                @finals = @entity_search.uniq{|p| p[:user_entity_id]}
               elsif @user_entities_with_sub_category_and_city.present?
                  @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                    @user = User.where(:id => sub_category_and_city.user_id)
                    @user.each do |users|
                      es = entity_search.merge(:api_id => sub_category_and_city.api_id,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                      @entity_search << es
                   end
                   end
                   @finals = @entity_search.uniq{|p| p[:user_entity_id]}
                 elsif @user_entities_with_friends_and_city_or_sub_category.present?
                     @user_entities_with_friends_and_city_or_sub_category.each do |with_friend_and_city_or_sub_category|
                     @user = User.where(:id => with_friend_and_city_or_sub_category.user_id)
                     @user.each do |users|
                        es = entity_search.merge(:api_id => with_friend_and_city_or_sub_category.api_id,:caputredDeviceOrientation => with_friend_and_city_or_sub_category.caputredDeviceOrientation,:ycody => with_friend_and_city_or_sub_category.ycody,:xcody => with_friend_and_city_or_sub_category.xcody,:user_entity_id => with_friend_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_friend_and_city_or_sub_category.address, :comment => with_friend_and_city_or_sub_category.comment, :entity_image => with_friend_and_city_or_sub_category.entity_image, :entity_name => with_friend_and_city_or_sub_category.entity_name,  :rating_count => with_friend_and_city_or_sub_category.rating_count, :sub_category => with_friend_and_city_or_sub_category.sub_category, :lat => with_friend_and_city_or_sub_category.lat , :longitude => with_friend_and_city_or_sub_category.longitude, :user_category_id =>  with_friend_and_city_or_sub_category.user_category_id)
                        @entity_search << es
                     end
                    end
                    @finals = @entity_search.uniq{|p| p[:user_entity_id]}
                 elsif @user_entities_with_sub_category_or_city.present?
                    @user_entities_with_sub_category_or_city.each do |with_sub_category_or_city|
                        @user = User.where(:id => with_sub_category_or_city.user_id)
                        @user.each do |users|
                           es = entity_search.merge(:api_id => with_sub_category_or_city.api_id,:caputredDeviceOrientation => with_sub_category_or_city.caputredDeviceOrientation,:ycody => with_sub_category_or_city.ycody,:xcody => with_sub_category_or_city.xcody,:user_entity_id => with_sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category_or_city.address, :comment => with_sub_category_or_city.comment, :entity_image => with_sub_category_or_city.entity_image, :entity_name => with_sub_category_or_city.entity_name,  :rating_count => with_sub_category_or_city.rating_count, :sub_category => with_sub_category_or_city.sub_category, :lat => with_sub_category_or_city.lat , :longitude => with_sub_category_or_city.longitude, :user_category_id =>  with_sub_category_or_city.user_category_id)
                           @entity_search << es
                        end
                    end
                    @finals = @entity_search.uniq{|p| p[:user_entity_id]}
                  elsif @user_entities_with_only_city.present?
                    @user_entities_with_only_city.each do |with_city|
                      @user = User.where(:id => with_city.user_id)
                      @user.each do |users|
                         es = entity_search.merge(:api_id => with_city.api_id,:caputredDeviceOrientation => with_city.caputredDeviceOrientation,:ycody => with_city.ycody,:xcody => with_city.xcody,:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => with_city.rating_count, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id)
                         @entity_search << es
                      end
                    end
                    @finals = @entity_search.uniq{|p| p[:user_entity_id]}
                  elsif @user_entities_with_only_sub_category.present?
                    @user_entities_with_only_sub_category.each do |with_sub_category|
                      @user = User.where(:id => with_sub_category.user_id)
                      @user.each do |users|
                         es = entity_search.merge(:api_id => with_sub_category.api_id,:caputredDeviceOrientation => with_sub_category.caputredDeviceOrientation,:ycody => with_sub_category.ycody,:xcody => with_sub_category.xcody,:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => with_sub_category.rating_count, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id)
                         @entity_search << es
                      end
                    end
                 end

              end


            end
          end
             @finals = @entity_search.uniq{|p| p[:user_entity_id]}
            if !@finals.blank?
              format.json {render :json => @finals.uniq}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
             end
      elsif params[:search] == "friend"
       if @sort_setting.sort_by == "Rating"
        @user_relations = Relatoinship.where(:user_id => @sort_setting.user_id,:is_active => "true")
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         @user_category_ids = UserCategory.where(:master_category_id => params[:master_category_id],:is_active => "true")
         @user_category_ids.each do |cat|
           @user_Cate_re = UserCategoryRelation.where(:user_id => @sort_setting.user_id,:user_category_id => cat.id, :is_active => "true")
         @user_Cate_re.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         end

         @category_relations.uniq
            @category_relations.each do |user_re|
            @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
            @user_category_id.each do |cat|
               cate = cat.id
               @user_entities_rat_all = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name}
               @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name}
               @user_entities_with_only_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entity_with_rating = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}

            if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_rating.each do |ratings|
                            @user = User.where(:id => ratings.user_id)
                            @user.each do |users|
                               we = entity_search.merge(:api_id => ratings.api_id,:caputredDeviceOrientation => ratings.caputredDeviceOrientation,:ycody => ratings.ycody,:xcody => with_sub_category.xcody,:is => "Rating",:user_entity_id => ratings.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => ratings.address, :comment => ratings.comment, :entity_image => ratings.entity_image, :entity_name => ratings.entity_name.downcase,  :rating_count => ratings.rating_count, :sub_category => ratings.sub_category, :lat => ratings.lat , :longitude => ratings.longitude, :user_category_id =>  ratings.user_category_id)
                               @entity_search << we
                            end
                        end

            elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:api_id => rating_all.api_id,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:is => "Rating",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end

            else
              if @user_entities_rat_all.present?
                  @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:api_id => rating_all.api_id,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:is => "Rating",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end
               elsif @user_entities_with_sub_category_and_city.present?
                     @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                        ue = sub_category_and_city.id
                        @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                        @user = User.where(:id => sub_category_and_city.user_id)
                        @user.each do |users|
                           we = entity_search.merge(:api_id => sub_category_and_city.api_id,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:is => "Rating",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name.downcase,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                           @entity_search << we
                        end
                      end
                elsif @user_entities_with_rat_and_city_or_sub_category.present?
                      @user_entities_with_rat_and_city_or_sub_category.each do |rat_and_city_or_sub_category|
                         @user = User.where(:id => rat_and_city_or_sub_category.user_id)
                         @user.each do |users|
                             we = entity_search.merge(:api_id => rat_and_city_or_sub_category.api_id,:caputredDeviceOrientation => rat_and_city_or_sub_category.caputredDeviceOrientation,:ycody => rat_and_city_or_sub_category.ycody,:xcody => rat_and_city_or_sub_category.xcody,:is => "Rating",:user_entity_id => rat_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rat_and_city_or_sub_category.address, :comment => rat_and_city_or_sub_category.comment, :entity_image => rat_and_city_or_sub_category.entity_image, :entity_name => rat_and_city_or_sub_category.entity_name.downcase,  :rating_count => rat_and_city_or_sub_category.rating_count, :sub_category => rat_and_city_or_sub_category.sub_category, :lat => rat_and_city_or_sub_category.lat , :longitude => rat_and_city_or_sub_category.longitude, :user_category_id =>  rat_and_city_or_sub_category.user_category_id)
                             @entity_search << we
                         end
                      end
                 elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                         @user = User.where(:id => sub_category_or_city.user_id)
                         @user.each do |users|
                            we = entity_search.merge(:api_id => sub_category_or_city.api_id,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:is => "Rating",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                            @entity_search << we
                         end
                       end
                 elsif @user_entities_with_only_city.present?
                       @user_entities_with_only_city.each do |city|
                           @user = User.where(:id => city.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:api_id => city.api_id,:caputredDeviceOrientation => city.caputredDeviceOrientation,:ycody => city.ycody,:xcody => city.xcody,:is => "Rating",:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                              @entity_search << we
                           end
                        end
                  elsif @user_entities_with_only_sub_category.present?
                        @user_entities_with_only_sub_category.each do |sub_category|
                           @user = User.where(:id => sub_category.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:api_id => sub_category.api_id,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:is => "Rating",:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                              @entity_search << we
                           end
                        end
                     end
            end

                  end
              end
              @final_data =  @entity_search.sort_by { |k| k["rating_count"]}
                        if !@final_data.blank?
                           format.json {render :json => @final_data}
                        else
                           format.json {render :json => {:message => "Search not found"} }
                        end

       elsif @sort_setting.sort_by == "Recent"
           @user_relations = Relatoinship.where(:user_id => @sort_setting.user_id,:is_active => "true")
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         @user_category_ids = UserCategory.where(:master_category_id => params[:master_category_id],:is_active => "true")
         @user_category_ids.each do |cat|
           @user_Cate_re = UserCategoryRelation.where(:user_id => @sort_setting.user_id,:user_category_id => cat.id, :is_active => "true")
         @user_Cate_re.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         end

         @category_relations.uniq
            @category_relations.each do |user_re|
            @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
            @user_category_id.each do |cat|
               cate = cat.id
               @user_entities_rat_all = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:created_at,:desc]).uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:created_at,:desc]).uniq{|p|  p.entity_name}
               @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:created_at,:desc]).uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:created_at,:desc]).uniq{|p|  p.entity_name}
               @user_entities_with_only_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by([:created_at,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by([:created_at,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.entity_name}
               @user_entity_with_rating = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).order_by([:created_at,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).order_by([:created_at,:desc]).uniq{|p| p.entity_name}

            if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_rating.each do |ratings|
                            @user = User.where(:id => ratings.user_id)
                            @user.each do |users|
                               we = entity_search.merge(:api_id => ratings.api_id,:caputredDeviceOrientation => ratings.caputredDeviceOrientation,:ycody => ratings.ycody,:xcody => ratings.xcody,:is => "Recent",:user_entity_id => ratings.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => ratings.address, :comment => ratings.comment, :entity_image => ratings.entity_image, :entity_name => ratings.entity_name.downcase,  :rating_count => ratings.rating_count, :sub_category => ratings.sub_category, :lat => ratings.lat , :longitude => ratings.longitude, :user_category_id =>  ratings.user_category_id)
                               @entity_search << we
                            end
                        end

            elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:api_id => rating_all.api_id,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:is => "Recent",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end

            else
              if @user_entities_rat_all.present?
                  @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:api_id => rating_all.api_id,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:is => "Recent",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end
               elsif @user_entities_with_sub_category_and_city.present?
                     @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                        ue = sub_category_and_city.id
                        @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                        @user = User.where(:id => sub_category_and_city.user_id)
                        @user.each do |users|
                           we = entity_search.merge(:api_id => sub_category_and_city.api_id,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:is => "Recent",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name.downcase,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                           @entity_search << we
                        end
                      end
                elsif @user_entities_with_rat_and_city_or_sub_category.present?
                      @user_entities_with_rat_and_city_or_sub_category.each do |rat_and_city_or_sub_category|
                         @user = User.where(:id => rat_and_city_or_sub_category.user_id)
                         @user.each do |users|
                             we = entity_search.merge(:api_id => rat_and_city_or_sub_category.api_id,:caputredDeviceOrientation => rat_and_city_or_sub_category.caputredDeviceOrientation,:ycody => rat_and_city_or_sub_category.ycody,:xcody => rat_and_city_or_sub_category.xcody,:is => "Recent",:user_entity_id => rat_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rat_and_city_or_sub_category.address, :comment => rat_and_city_or_sub_category.comment, :entity_image => rat_and_city_or_sub_category.entity_image, :entity_name => rat_and_city_or_sub_category.entity_name.downcase,  :rating_count => rat_and_city_or_sub_category.rating_count, :sub_category => rat_and_city_or_sub_category.sub_category, :lat => rat_and_city_or_sub_category.lat , :longitude => rat_and_city_or_sub_category.longitude, :user_category_id =>  rat_and_city_or_sub_category.user_category_id)
                             @entity_search << we
                         end
                      end
                 elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                         @user = User.where(:id => sub_category_or_city.user_id)
                         @user.each do |users|
                            we = entity_search.merge(:api_id => sub_category_or_city.api_id,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:is => "Recent",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                            @entity_search << we
                         end
                       end
                 elsif @user_entities_with_only_city.present?
                       @user_entities_with_only_city.each do |city|
                           @user = User.where(:id => city.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:api_id => city.api_id,:caputredDeviceOrientation => city.caputredDeviceOrientation,:ycody => city.ycody,:xcody => city.xcody,:is => "Recent",:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                              @entity_search << we
                           end
                        end
                  elsif @user_entities_with_only_sub_category.present?
                        @user_entities_with_only_sub_category.each do |sub_category|
                           @user = User.where(:id => sub_category.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:api_id => sub_category.api_id,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:is => "Recent",:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                              @entity_search << we
                           end
                        end
                     end
            end

                  end
              end
              @final_data =  @entity_search.sort_by { |k| k["created_at"]}
                        if !@final_data.blank?
                           format.json {render :json => @final_data}
                        else
                           format.json {render :json => {:message => "Search not found"} }
                        end

         elsif @sort_setting.sort_by == "Proximity"
                  center = Geocoder.coordinates(params[:address])
                  @category_relations = Array.new
                  cd = @sort_setting.user_id
                  @user_relations = Relatoinship.where(:user_id => @sort_setting.user_id,:is_active => "true")
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         @user_category_ids = UserCategory.where(:master_category_id => params[:master_category_id],:is_active => "true")
         @user_category_ids.each do |cat|
           @user_Cate_re = UserCategoryRelation.where(:user_id => @sort_setting.user_id,:user_category_id => cat.id, :is_active => "true")
         @user_Cate_re.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         end

         @category_relations.uniq
            @category_relations.each do |user_re|
            @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
            @user_category_id.each do |cat|
                           cate = cat.id
                           user = cat.user_id
                           if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
                              @user_entity_with_proxy = UserEntity.near(center,10000000).and.where(:user_category_id => cat.id, :user_id => cat.user_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).uniq{|p| p.entity_name} | UserEntity.near(center,10000000).and.where(:user_category_id => cat.id, :user_id => cat.user_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).uniq{|p| p.entity_name}
                              @user_entity_with_proxy.each do |proxy|
                                distance = 0
                                distance= Geocoder::Calculations.distance_between(center, [proxy.lat, proxy.longitude])
                                @users = User.where(:id => proxy.user_id)
                                @users.each do |users|
                                es = entity_search.merge(:api_id => proxy.api_id,:caputredDeviceOrientation => proxy.caputredDeviceOrientation,:ycody => proxy.ycody,:xcody => proxy.xcody,:distance => distance.to_s, :is => "Proxy",:user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
                                @entity_search << es
                            end
                          end

                           else

                            @user_entities_proxy_all = UserEntity.near(center,10000000).and.where(:user_category_id => cat.id, :user_id => cat.user_id,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p|  p.entity_name} | UserEntity.near(center,10000000).and.where(:user_category_id => cat.id, :user_id => cat.user_id,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p|  p.entity_name}
                            @user_entities_proxy_all.each do |pro|
                              distance = 0
                              distance= Geocoder::Calculations.distance_between(center, [pro.lat, pro.longitude])
                                 @users = User.where(:id => pro.user_id)
                                    @users.each do |users|
                                        es = entity_search.merge(:api_id => pro.api_id,:caputredDeviceOrientation => pro.caputredDeviceOrientation,:ycody => pro.ycody,:xcody => pro.xcody,:distance => distance.to_s, :is => "Proxy",:user_entity_id => pro.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => pro.address, :comment => pro.comment, :entity_image => pro.entity_image, :entity_name => pro.entity_name,  :rating_count => pro.rating_count, :sub_category => pro.sub_category, :lat => pro.lat , :longitude => pro.longitude, :user_category_id =>  pro.user_category_id)
                                        @entity_search << es
                                    end
                              end


                           end
                      end
                    end
                    @final_data =  @entity_search.sort_by { |k| k["distance"]}
              if !@final_data.blank?
                  format.json {render :json => @final_data}
              else
                  format.json {render :json => {:message => "Search not found"} }
              end
                       elsif @sort_setting.sort_by == "Friend"
         @user_relations = Relatoinship.where(:user_id => @sort_setting.user_id,:is_active => "true")
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         @user_category_ids = UserCategory.where(:master_category_id => params[:master_category_id],:is_active => "true")
         @user_category_ids.each do |cat|
           @user_Cate_re = UserCategoryRelation.where(:user_id => @sort_setting.user_id,:user_category_id => cat.id, :is_active => "true")
         @user_Cate_re.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         end

         @category_relations.uniq
            @category_relations.each do |user_re|
            @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
            @user_category_id.each do |cat|
               cate = cat.id
               @user_entities_rat_all = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name}
               @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name} |  UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name}
               @user_entities_with_only_city = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entity_with_rating = UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :entity_name => /.*#{params[:entity_name][:char]}*./i).order_by([:rating_count,:desc]).uniq{|p| p.entity_name} | UserEntity.where(:user_category_id => cate.to_s,:is_active => "true", :sub_category => /.*#{params[:entity_name][:char]}*./i).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}

            if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_rating.each do |ratings|
                            @user = User.where(:id => ratings.user_id)
                            @user.each do |users|
                               we = entity_search.merge(:api_id => ratings.api_id,:caputredDeviceOrientation => ratings.caputredDeviceOrientation,:ycody => ratings.ycody,:xcody => ratings.xcody,:user_entity_id => ratings.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => ratings.address, :comment => ratings.comment, :entity_image => ratings.entity_image, :entity_name => ratings.entity_name.downcase,  :rating_count => ratings.rating_count, :sub_category => ratings.sub_category, :lat => ratings.lat , :longitude => ratings.longitude, :user_category_id =>  ratings.user_category_id)
                               @entity_search << we
                            end
                        end

            elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:api_id => rating_all.api_id,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end

            else
              if @user_entities_rat_all.present?
                  @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:api_id => rating_all.api_id,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end
               elsif @user_entities_with_sub_category_and_city.present?
                     @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                        ue = sub_category_and_city.id
                        @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                        @user = User.where(:id => sub_category_and_city.user_id)
                        @user.each do |users|
                           we = entity_search.merge(:api_id => sub_category_and_city.api_id,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name.downcase,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                           @entity_search << we
                        end
                      end
                elsif @user_entities_with_rat_and_city_or_sub_category.present?
                      @user_entities_with_rat_and_city_or_sub_category.each do |rat_and_city_or_sub_category|
                         @user = User.where(:id => rat_and_city_or_sub_category.user_id)
                         @user.each do |users|
                             we = entity_search.merge(:api_id => rat_and_city_or_sub_category.api_id,:caputredDeviceOrientation => rat_and_city_or_sub_category.caputredDeviceOrientation,:ycody => rat_and_city_or_sub_category.ycody,:xcody => rat_and_city_or_sub_category.xcody,:user_entity_id => rat_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rat_and_city_or_sub_category.address, :comment => rat_and_city_or_sub_category.comment, :entity_image => rat_and_city_or_sub_category.entity_image, :entity_name => rat_and_city_or_sub_category.entity_name.downcase,  :rating_count => rat_and_city_or_sub_category.rating_count, :sub_category => rat_and_city_or_sub_category.sub_category, :lat => rat_and_city_or_sub_category.lat , :longitude => rat_and_city_or_sub_category.longitude, :user_category_id =>  rat_and_city_or_sub_category.user_category_id)
                             @entity_search << we
                         end
                      end
                 elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                         @user = User.where(:id => sub_category_or_city.user_id)
                         @user.each do |users|
                            we = entity_search.merge(:api_id => sub_category_or_city.api_id,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                            @entity_search << we
                         end
                       end
                 elsif @user_entities_with_only_city.present?
                       @user_entities_with_only_city.each do |city|
                           @user = User.where(:id => city.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:api_id => city.api_id,:caputredDeviceOrientation => city.caputredDeviceOrientation,:ycody => city.ycody,:xcody => city.xcody,:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                              @entity_search << we
                           end
                        end
                  elsif @user_entities_with_only_sub_category.present?
                        @user_entities_with_only_sub_category.each do |sub_category|
                           @user = User.where(:id => sub_category.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:api_id => sub_category.api_id,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                              @entity_search << we
                           end
                        end
                     end
            end

                  end
              end
              @final_data =  @entity_search.sort_by { |k| k["rating_count"]}
                        if !@final_data.blank?
                           format.json {render :json => @final_data}
                        else
                           format.json {render :json => {:message => "Search not found"} }
                        end

      end
    end
  end
 end
end

end
# curl -X POST -d "user_id=518797b1b554cfd09a000001&user_category_id=518797bbb554cfd09a000002&search=friend&master_category_id=518737f1b554cfd51d000002&entity_name[char]=re" http://ec2-54-225-243-66.compute-1.amazonaws.com/search/search_all.json
