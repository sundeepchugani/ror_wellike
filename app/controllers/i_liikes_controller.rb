class ILiikesController < ApplicationController
  def i_liike_sort
    @entity_search = Array.new
    entity_search = {}
    @rating = Array.new
    @sort_setting = EntitySetting.where(:user_id => params[:user_id]).first
    respond_to do |format|
      if @sort_setting.present?
        if @sort_setting.sort_by == "Rating"
          @user_entities_rat_all = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count.desc)#.uniq{|p| p.user_id }
          @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count.desc)#.uniq{|p| p.user_id }
          @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count.desc)#.uniq{|p| p.user_id}
          @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count.desc)#.uniq{|p| p.user_id }
          @user_entities_with_only_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_city).order_by(:rating_count.desc)#.uniq{|p| p.user_id }
          @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count.desc)#.uniq{|p| p.user_id}
          @user_entity_with_rating = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").order_by(:rating_count.desc)#.uniq{|p| p.user_id && p.entity_name}

          if @sort_setting.narrow_by_city.empty? && @sort_setting.narrow_by_sub_category.empty?
              @user_entity_with_rating.each do |with_rating|
               @users = User.where(:id => with_rating.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_rating.api_id,:ycody => with_rating.ycody,:xcody => with_rating.xcody,:is => "Rating",:user_entity_id => with_rating.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_rating.address, :comment => with_rating.comment, :entity_image => with_rating.entity_image, :entity_name => with_rating.entity_name,  :rating_count => with_rating.rating_count, :sub_category => with_rating.sub_category, :lat => with_rating.lat , :longitude => with_rating.longitude, :user_category_id =>  with_rating.user_category_id,:city=> with_rating.city)
                 @entity_search << es
               end
             end
          elsif @sort_setting.narrow_by_city.present? && @sort_setting.narrow_by_sub_category.present?
            @user_entities_rat_all.each do |user_entity|
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id,:city=> user_entity.city)
                 @entity_search << es
               end
             end
          else
          if @user_entities_rat_all.present?
             @user_entities_rat_all.each do |user_entity|
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id,:city=> user_entity.city)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_and_city.present?
             @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                ue = sub_category_and_city.id
                 @users = User.where(:id => sub_category_and_city.user_id)
                 @users.each do |users|
                   es = entity_search.merge(:api_id => sub_category_and_city.api_id,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:is => "Rating",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id,:city=> sub_category_and_city.city)
                   @entity_search << es
               end
             end
           elsif @user_entities_with_rat_and_city_or_sub_category.present?
             @user_entities_with_rat_and_city_or_sub_category.each do |city_or_sub_category_with_rat|
                               ue = city_or_sub_category_with_rat.id
                          @users = User.where(:id => city_or_sub_category_with_rat.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => city_or_sub_category_with_rat.api_id,:ycody => city_or_sub_category_with_rat.ycody,:xcody => city_or_sub_category_with_rat.xcody,:is => "Rating",:user_entity_id => city_or_sub_category_with_rat.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city_or_sub_category_with_rat.address, :comment => city_or_sub_category_with_rat.comment, :entity_image => city_or_sub_category_with_rat.entity_image, :entity_name => city_or_sub_category_with_rat.entity_name,  :rating_count => city_or_sub_category_with_rat.rating_count, :sub_category => city_or_sub_category_with_rat.sub_category, :lat => city_or_sub_category_with_rat.lat , :longitude => city_or_sub_category_with_rat.longitude, :user_category_id =>  city_or_sub_category_with_rat.user_category_id,:city=> city_or_sub_category_with_rat.city)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_or_city.present?
             @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
              @users = User.where(:id => sub_category_or_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => sub_category_or_city.api_id,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:is => "Rating",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id,:city=> sub_category_or_city.city)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_city.present?
             @user_entities_with_only_city.each do |with_city|
               ue = with_city.id
               @users = User.where(:id => with_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_city.api_id,:ycody => with_city.ycody,:xcody => with_city.xcody,:is => "Rating",:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => with_city.rating_count, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_sub_category.present?
             @user_entities_with_only_sub_category.each do |with_sub_category|
               @users = User.where(:id => with_sub_category.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_sub_category.api_id,:ycody => with_sub_category.ycody,:xcody => with_sub_category.xcody,:is => "Rating",:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => with_sub_category.rating_count, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id,:city=> with_sub_category.city)
                 @entity_search << es
               end
             end
           end
          end

         @recent_entity =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["rating_count"]}
             if !@recent_entity.blank?
                 format.json {render :json => @recent_entity}
               else
                 format.json {render :json => {:message => "Search not found"} }
             end
      elsif @sort_setting.sort_by == "Recent"
          @user_entities_recent_all = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc")#.uniq{|p| p.user_id }
          @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category)#.uniq{|p| p.user_id }
          @user_entities_with_recent_and_city_or_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:created_at => "desc")#.uniq{|p| p.user_id }
          @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category})#.uniq{|p| p.user_id }
          @user_entities_with_only_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:city => @sort_setting.narrow_by_city)#.uniq{|p| p.user_id }
          @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:sub_category => @sort_setting.narrow_by_sub_category)#.uniq{|p| p.user_id }
          @user_entity_with_recent = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").order_by(:created_at => "desc")#.uniq{|p| p.user_id }
          if @sort_setting.narrow_by_city.empty? && @sort_setting.narrow_by_sub_category.empty?
            @user_entity_with_recent.each do |with_rating|
               ue = with_rating.id
#                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
#                   if @ratings.present?
#                       @ratings.each do |rat|
#                         @rating << rat.rating_count
#                       end
#                      cd = (with_rating.rating_count).to_i
#                      @rating << cd
#                      total = 0
#
#                    @rating.each do |item|
#
#                       total += item
#
#                    end
#                    average = total / @rating.length
#                  else
#                    if with_rating.rating_count == "0"
#                      average = "0"
#                    else
#                      @rating << (with_rating.rating_count).to_i
#                      total = 0
#                      average = 0
#                      @rating.each do |item|
#                       total += item
#                    end
#                    average = total / @rating.length
#                    end
#                 end
               @users = User.where(:id => with_rating.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_rating.api_id,:city=> with_rating.city,:ycody => with_rating.ycody,:xcody => with_rating.xcody,:is => "Recent",:user_entity_id => with_rating.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_rating.address, :comment => with_rating.comment, :entity_image => with_rating.entity_image, :entity_name => with_rating.entity_name,  :rating_count => with_rating.rating_count, :sub_category => with_rating.sub_category, :lat => with_rating.lat , :longitude => with_rating.longitude, :user_category_id =>  with_rating.user_category_id, :created_at => with_rating.created_at)
                 @entity_search << es
               end
             end
          elsif @sort_setting.narrow_by_city.present? && @sort_setting.narrow_by_sub_category.present?
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
                 es = entity_search.merge(:api_id => user_entity.api_id,:city=> user_entity.city,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :created_at => user_entity.created_at)
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
                 es = entity_search.merge(:api_id => user_entity.api_id,:city=> user_entity.city,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :created_at => user_entity.created_at)
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
                   es = entity_search.merge(:api_id => sub_category_and_city.api_id,:city=> sub_category_and_city.city,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:is => "Recent",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id, :created_at => sub_category_and_city.created_at)
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
                 es = entity_search.merge(:api_id => city_or_sub_category_with_rat.api_id,:city=> city_or_sub_category_with_rat.city,:ycody => city_or_sub_category_with_rat.ycody,:xcody => city_or_sub_category_with_rat.xcody,:is => "Recent",:user_entity_id => city_or_sub_category_with_rat.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city_or_sub_category_with_rat.address, :comment => city_or_sub_category_with_rat.comment, :entity_image => city_or_sub_category_with_rat.entity_image, :entity_name => city_or_sub_category_with_rat.entity_name,  :rating_count => city_or_sub_category_with_rat.rating_count, :sub_category => city_or_sub_category_with_rat.sub_category, :lat => city_or_sub_category_with_rat.lat , :longitude => city_or_sub_category_with_rat.longitude, :user_category_id =>  city_or_sub_category_with_rat.user_category_id, :created_at => city_or_sub_category_with_rat.created_at)
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
                 es = entity_search.merge(:api_id => sub_category_or_city.api_id,:city=> sub_category_or_city.city,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:is => "Recent",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id, :created_at => sub_category_or_city.created_at)
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
                 es = entity_search.merge(:api_id => with_city.api_id,:city=> with_city.city,:ycody => with_city.ycody,:xcody => with_city.xcody,:is => "Recent",:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => with_city.rating_count, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id, :created_at => with_city.created_at)
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
                 es = entity_search.merge(:api_id => with_sub_category.api_id,:city=> with_sub_category.city,:ycody => with_sub_category.ycody,:xcody => with_sub_category.xcody,:is => "Recent",:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => with_sub_category.rating_count, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id, :created_at => with_sub_category.created_at)
                 @entity_search << es
               end
             end
          end
          end

          arrays = @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["created_at"]}
          if !arrays.blank?
            format.json {render :json => arrays}
          else
            format.json {render :json => {:message => "Search not found"} }
          end
 
        elsif @sort_setting.sort_by == "Proximity"
          center = Geocoder.coordinates(params[:address])
          @user_entities_with_only_sub_category = UserEntity.near(center,10000000).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true").in(:sub_category => @sort_setting.narrow_by_sub_category)#.uniq{|p| p.user_id }
          @user_entity_with_proxy = UserEntity.near(center,10000000).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_public => "true")#.uniq{|p| p.user_id }
         if @sort_setting.narrow_by_sub_category.empty?
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
               es = entity_search.merge( :api_id => proxy.api_id,:city=> proxy.city,:ycody => proxy.ycody,:xcody => proxy.xcody,:distance => distance.to_s, :is => "Proxy",:coordinates => proxy.coordinates,:user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
               @entity_search << es
             end
            end
         else
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
               es = entity_search.merge(:api_id => sub_category.api_id, :city=> sub_category.city,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:distance => distance.to_s ,:is => "Proxy",:coordinates => sub_category.coordinates,:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
               @entity_search << es
             end
            end
         end
         @final_data = @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["distance"]}
        # @final_data =  @entity_search.sort_by { |k| k["distance"]}
          if !@final_data.blank?
             format.json {render :json => @final_data}
          else
             format.json {render :json => {:message => "Search not found"} }
          end
          elsif @sort_setting.sort_by == "Friend"
              format.json {render :json => {:message => "ILiike not contain friends entity"}}
          end
        end
      end
    end


  def i_liike_sort_other
    @entity_search = Array.new
    entity_search = {}
    @rating = Array.new
    @sort_setting = EntitySetting.where(:user_id => params[:user_id]).first
    respond_to do |format|
      if @sort_setting.present?
        if @sort_setting.sort_by == "Rating"
          @user_entities_rat_all = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count.desc)#.uniq{|p| p.user_id }
          @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count.desc)#.uniq{|p| p.user_id }
          @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count.desc)#.uniq{|p| p.user_id}
          @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:rating_count.desc)#.uniq{|p| p.user_id }
          @user_entities_with_only_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_city).order_by(:rating_count.desc)#.uniq{|p| p.user_id }
          @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:rating_count.desc)#.uniq{|p| p.user_id}
          @user_entity_with_rating = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").order_by(:rating_count.desc)#.uniq{|p| p.user_id && p.entity_name}

          if @sort_setting.narrow_by_city.empty? && @sort_setting.narrow_by_sub_category.empty?
              @user_entity_with_rating.each do |with_rating|
                if with_rating.user_id == params[:user_id] && with_rating.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>with_rating.id )
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
                           else
                               average = with_rating.rating_count
                           end
               @users = User.where(:id => with_rating.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_rating.api_id,:ycody => with_rating.ycody,:xcody => with_rating.xcody,:is => "Rating",:user_entity_id => with_rating.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_rating.address, :comment => with_rating.comment, :entity_image => with_rating.entity_image, :entity_name => with_rating.entity_name,  :rating_count => average, :sub_category => with_rating.sub_category, :lat => with_rating.lat , :longitude => with_rating.longitude, :user_category_id =>  with_rating.user_category_id,:city=> with_rating.city)
                 @entity_search << es
               end
             end
          elsif @sort_setting.narrow_by_city.present? && @sort_setting.narrow_by_sub_category.present?
            @user_entities_rat_all.each do |user_entity|
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
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id,:city=> user_entity.city)
                 @entity_search << es
               end
             end
          else
          if @user_entities_rat_all.present?
             @user_entities_rat_all.each do |user_entity|
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
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id,:city=> user_entity.city)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_and_city.present?
             @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
               if sub_category_and_city.user_id == params[:user_id] && sub_category_and_city.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>sub_category_and_city.id )
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
                           else
                               average = sub_category_and_city.rating_count
                           end
                ue = sub_category_and_city.id
                 @users = User.where(:id => sub_category_and_city.user_id)
                 @users.each do |users|
                   es = entity_search.merge(:api_id => sub_category_and_city.api_id,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:is => "Rating",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => average, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id,:city=> sub_category_and_city.city)
                   @entity_search << es
               end
             end
           elsif @user_entities_with_rat_and_city_or_sub_category.present?
             @user_entities_with_rat_and_city_or_sub_category.each do |city_or_sub_category_with_rat|
                               ue = city_or_sub_category_with_rat.id
                               if city_or_sub_category_with_rat.user_id == params[:user_id] && city_or_sub_category_with_rat.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>city_or_sub_category_with_rat.id )
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
                           else
                               average = city_or_sub_category_with_rat.rating_count
                           end
                          @users = User.where(:id => city_or_sub_category_with_rat.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => city_or_sub_category_with_rat.api_id,:ycody => city_or_sub_category_with_rat.ycody,:xcody => city_or_sub_category_with_rat.xcody,:is => "Rating",:user_entity_id => city_or_sub_category_with_rat.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city_or_sub_category_with_rat.address, :comment => city_or_sub_category_with_rat.comment, :entity_image => city_or_sub_category_with_rat.entity_image, :entity_name => city_or_sub_category_with_rat.entity_name,  :rating_count => average, :sub_category => city_or_sub_category_with_rat.sub_category, :lat => city_or_sub_category_with_rat.lat , :longitude => city_or_sub_category_with_rat.longitude, :user_category_id =>  city_or_sub_category_with_rat.user_category_id,:city=> city_or_sub_category_with_rat.city)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_or_city.present?
             @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                      if sub_category_or_city.user_id == params[:user_id] && sub_category_or_city.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>sub_category_or_city.id )
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
                           else
                               average = sub_category_or_city.rating_count
                           end
              @users = User.where(:id => sub_category_or_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => sub_category_or_city.api_id,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:is => "Rating",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => average, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id,:city=> sub_category_or_city.city)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_city.present?
             @user_entities_with_only_city.each do |with_city|
               if with_city.user_id == params[:user_id] && with_city.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>with_city.id )
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
                           else
                               average = with_city.rating_count
                           end
               ue = with_city.id
               @users = User.where(:id => with_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_city.api_id,:ycody => with_city.ycody,:xcody => with_city.xcody,:is => "Rating",:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => with_city.rating_count, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_sub_category.present?
             @user_entities_with_only_sub_category.each do |with_sub_category|
               if with_sub_category.user_id == params[:user_id] && with_sub_category.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>with_sub_category.id )
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
                           else
                               average = with_sub_category.rating_count
                           end
               @users = User.where(:id => with_sub_category.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_sub_category.api_id,:ycody => with_sub_category.ycody,:xcody => with_sub_category.xcody,:is => "Rating",:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => average, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id,:city=> with_sub_category.city)
                 @entity_search << es
               end
             end
           end
          end

         @recent_entity =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["rating_count"]}
             if !@recent_entity.blank?
                 format.json {render :json => @recent_entity}
               else
                 format.json {render :json => {:message => "Search not found"} }
             end
      elsif @sort_setting.sort_by == "Recent"
          @user_entities_recent_all = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc")#.uniq{|p| p.user_id }
          @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category)#.uniq{|p| p.user_id }
          @user_entities_with_recent_and_city_or_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:created_at => "desc")#.uniq{|p| p.user_id }
          @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category})#.uniq{|p| p.user_id }
          @user_entities_with_only_city = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:city => @sort_setting.narrow_by_city)#.uniq{|p| p.user_id }
          @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:sub_category => @sort_setting.narrow_by_sub_category)#.uniq{|p| p.user_id }
          @user_entity_with_recent = UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").order_by(:created_at => "desc")#.uniq{|p| p.user_id }
          if @sort_setting.narrow_by_city.empty? && @sort_setting.narrow_by_sub_category.empty?
            @user_entity_with_recent.each do |with_rating|
               ue = with_rating.id
 if with_rating.user_id == params[:user_id] && with_rating.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>with_rating.id )
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
                           else
                               average = with_rating.rating_count
                           end
               @users = User.where(:id => with_rating.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_rating.api_id,:city=> with_rating.city,:ycody => with_rating.ycody,:xcody => with_rating.xcody,:is => "Recent",:user_entity_id => with_rating.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_rating.address, :comment => with_rating.comment, :entity_image => with_rating.entity_image, :entity_name => with_rating.entity_name,  :rating_count => average, :sub_category => with_rating.sub_category, :lat => with_rating.lat , :longitude => with_rating.longitude, :user_category_id =>  with_rating.user_category_id, :created_at => with_rating.created_at)
                 @entity_search << es
               end
             end
          elsif @sort_setting.narrow_by_city.present? && @sort_setting.narrow_by_sub_category.present?
                @user_entities_recent_all.each do |user_entity|
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
               end
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:city=> user_entity.city,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count =>average , :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :created_at => user_entity.created_at)
                 @entity_search << es
               end
             end
          else
            if @user_entities_recent_all.present?
             @user_entities_recent_all.each do |user_entity|
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
               end
               @users = User.where(:id => user_entity.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => user_entity.api_id,:city=> user_entity.city,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :created_at => user_entity.created_at)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_and_city.present?
             @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
               ue = sub_category_and_city.id
                 if sub_category_and_city.user_id == params[:user_id] && sub_category_and_city.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>sub_category_and_city.id )
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
               end
                 @users = User.where(:id => sub_category_and_city.user_id)
                 @users.each do |users|
                   es = entity_search.merge(:api_id => sub_category_and_city.api_id,:city=> sub_category_and_city.city,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:is => "Recent",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name,  :rating_count => average, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id, :created_at => sub_category_and_city.created_at)
                   @entity_search << es
               end
             end
           elsif @user_entities_with_recent_and_city_or_sub_category.present?
             @user_entities_with_recent_and_city_or_sub_category.each do |city_or_sub_category_with_rat|
               ue = city_or_sub_category_with_rat.id
                if city_or_sub_category_with_rat.user_id == params[:user_id] && city_or_sub_category_with_rat.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>city_or_sub_category_with_rat.id )
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
               end
               @users = User.where(:id => city_or_sub_category_with_rat.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => city_or_sub_category_with_rat.api_id,:city=> city_or_sub_category_with_rat.city,:ycody => city_or_sub_category_with_rat.ycody,:xcody => city_or_sub_category_with_rat.xcody,:is => "Recent",:user_entity_id => city_or_sub_category_with_rat.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city_or_sub_category_with_rat.address, :comment => city_or_sub_category_with_rat.comment, :entity_image => city_or_sub_category_with_rat.entity_image, :entity_name => city_or_sub_category_with_rat.entity_name,  :rating_count => average, :sub_category => city_or_sub_category_with_rat.sub_category, :lat => city_or_sub_category_with_rat.lat , :longitude => city_or_sub_category_with_rat.longitude, :user_category_id =>  city_or_sub_category_with_rat.user_category_id, :created_at => city_or_sub_category_with_rat.created_at)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_sub_category_or_city.present?
             @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
               ue = sub_category_or_city.id
                  if sub_category_or_city.user_id == params[:user_id] && sub_category_or_city.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>sub_category_or_city.id )
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
               end
               @users = User.where(:id => sub_category_or_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => sub_category_or_city.api_id,:city=> sub_category_or_city.city,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:is => "Recent",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name,  :rating_count => average, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id, :created_at => sub_category_or_city.created_at)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_city.present?
             @user_entities_with_only_city.each do |with_city|
               ue = with_city.id
                 if with_city.user_id == params[:user_id] && with_city.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>with_city.id )
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
               end
               @users = User.where(:id => with_city.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_city.api_id,:city=> with_city.city,:ycody => with_city.ycody,:xcody => with_city.xcody,:is => "Recent",:user_entity_id => with_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_city.address, :comment => with_city.comment, :entity_image => with_city.entity_image, :entity_name => with_city.entity_name,  :rating_count => average, :sub_category => with_city.sub_category, :lat => with_city.lat , :longitude => with_city.longitude, :user_category_id =>  with_city.user_category_id, :created_at => with_city.created_at)
                 @entity_search << es
               end
             end
           elsif @user_entities_with_only_sub_category.present?
             @user_entities_with_only_sub_category.each do |with_sub_category|
               ue = with_sub_category.id
                  if with_sub_category.user_id == params[:user_id] && with_sub_category.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>with_sub_category.id )
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
               end
               @users = User.where(:id => with_sub_category.user_id)
               @users.each do |users|
                 es = entity_search.merge(:api_id => with_sub_category.api_id,:city=> with_sub_category.city,:ycody => with_sub_category.ycody,:xcody => with_sub_category.xcody,:is => "Recent",:user_entity_id => with_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => with_sub_category.address, :comment => with_sub_category.comment, :entity_image => with_sub_category.entity_image, :entity_name => with_sub_category.entity_name,  :rating_count => average, :sub_category => with_sub_category.sub_category, :lat => with_sub_category.lat , :longitude => with_sub_category.longitude, :user_category_id =>  with_sub_category.user_category_id, :created_at => with_sub_category.created_at)
                 @entity_search << es
               end
             end
          end
          end

          arrays = @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["created_at"]}
          if !arrays.blank?
            format.json {render :json => arrays}
          else
            format.json {render :json => {:message => "Search not found"} }
          end

        elsif @sort_setting.sort_by == "Proximity"
          center = Geocoder.coordinates(params[:address])
          @user_entities_with_only_sub_category = UserEntity.near(center,10000000).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true").in(:sub_category => @sort_setting.narrow_by_sub_category)#.uniq{|p| p.user_id }
          @user_entity_with_proxy = UserEntity.near(center,10000000).and.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id],:is_active => "true")#.uniq{|p| p.user_id }
         if @sort_setting.narrow_by_sub_category.empty?
           @user_entity_with_proxy.each do |proxy|
             distance = 0
             distance= Geocoder::Calculations.distance_between(center, [proxy.lat, proxy.longitude])
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
               end
              @users = User.where(:id => proxy.user_id)
              @users.each do |users|
                es = entity_search.merge( :api_id => proxy.api_id,:city=> proxy.city,:ycody => proxy.ycody,:xcody => proxy.xcody,:distance => distance.to_s, :is => "Proxy",:coordinates => proxy.coordinates,:user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => average, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
               @entity_search << es
             end
            end
         else
            @user_entities_with_only_sub_category.each do |sub_category|
              distance = 0
              distance= Geocoder::Calculations.distance_between(center, [sub_category.lat, sub_category.longitude])
              ue = sub_category.id
                 if sub_category.user_id == params[:user_id] && sub_category.rating_count.nil?
                            @ratings = Rating.where(:user_entity_id =>sub_category.id )
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
               end
             @users = User.where(:id => sub_category.user_id)
              @users.each do |users|
                es = entity_search.merge(:api_id => sub_category.api_id, :city=> sub_category.city,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:distance => distance.to_s ,:is => "Proxy",:coordinates => sub_category.coordinates,:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name,  :rating_count => average, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
               @entity_search << es
             end
            end
         end
         @final_data = @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["distance"]}
        # @final_data =  @entity_search.sort_by { |k| k["distance"]}
          if !@final_data.blank?
             format.json {render :json => @final_data}
          else
             format.json {render :json => {:message => "Search not found"} }
          end
          elsif @sort_setting.sort_by == "Friend"
              format.json {render :json => {:message => "ILiike not contain friends entity"}}
          end
        end
      end
    end
end
