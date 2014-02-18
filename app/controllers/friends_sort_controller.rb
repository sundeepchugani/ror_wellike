class FriendsSortController < ApplicationController
   def friend_sort
    entity_search = {}
    @entity_search = Array.new
    @category_relations = Array.new
    @rating = Array.new
    cate = Array.new
    @sort_setting = EntitySetting.where(:user_id => params[:user_id]).first
    respond_to  do |format|
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
               cate << cat.id
                 end
              end
               @user_entities_rat_all = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.id}
               @user_entities_with_sub_category_and_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.id}
               @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.id}
               @user_entities_with_sub_category_or_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.id}
               @user_entities_with_only_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc]).uniq{|p| p.id}
               @user_entities_with_only_sub_category = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.id}
               @user_entity_with_rating = UserEntity.where(:is_public => "true").in(:user_category_id => cate).order_by([:rating_count,:desc]).uniq{|p| p.id}
if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_rating.each do |ratings|
                            @user = User.where(:id => ratings.user_id)
                            @user.each do |users|
                               we = entity_search.merge(:is_active => ratings.is_active,:caputredDeviceOrientation => ratings.caputredDeviceOrientation,:ycody => ratings.ycody,:xcody => ratings.xcody,:api_id => ratings.api_id,:is => "Rating",:user_entity_id => ratings.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => ratings.address, :comment => ratings.comment, :entity_image => ratings.entity_image, :entity_name => ratings.entity_name.downcase,  :rating_count => ratings.rating_count, :sub_category => ratings.sub_category, :lat => ratings.lat , :longitude => ratings.longitude, :user_category_id =>  ratings.user_category_id)
                               @entity_search << we
                            end
                        end

            elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is_active => rating_all.is_active,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:api_id => rating_all.api_id,:is => "Rating",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end

            else
              if @user_entities_rat_all.present?
                  @user_entities_rat_all.each do |sub_category|
                    @user = User.where(:id => sub_category.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is_active => sub_category.is_active,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:api_id => sub_category.api_id,:is => "Rating",:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                       @entity_search << we
                    end
                   end
               elsif @user_entities_with_sub_category_and_city.present?
                     @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                        ue = sub_category_and_city.id
                        @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                        @user = User.where(:id => sub_category_and_city.user_id)
                        @user.each do |users|
                           we = entity_search.merge(:is_active => sub_category_and_city.is_active,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:api_id => sub_category_and_city.api_id,:is => "Rating",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name.downcase,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                           @entity_search << we
                        end
                      end
                elsif @user_entities_with_rat_and_city_or_sub_category.present?
                      @user_entities_with_rat_and_city_or_sub_category.each do |rat_and_city_or_sub_category|
                         @user = User.where(:id => rat_and_city_or_sub_category.user_id)
                         @user.each do |users|
                             we = entity_search.merge(:is_active => rat_and_city_or_sub_category.is_active,:caputredDeviceOrientation => rat_and_city_or_sub_category.caputredDeviceOrientation,:ycody => rat_and_city_or_sub_category.ycody,:xcody => rat_and_city_or_sub_category.xcody,:api_id => rat_and_city_or_sub_category.api_id,:is => "Rating",:user_entity_id => rat_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rat_and_city_or_sub_category.address, :comment => rat_and_city_or_sub_category.comment, :entity_image => rat_and_city_or_sub_category.entity_image, :entity_name => rat_and_city_or_sub_category.entity_name.downcase,  :rating_count => rat_and_city_or_sub_category.rating_count, :sub_category => rat_and_city_or_sub_category.sub_category, :lat => rat_and_city_or_sub_category.lat , :longitude => rat_and_city_or_sub_category.longitude, :user_category_id =>  rat_and_city_or_sub_category.user_category_id)
                             @entity_search << we
                         end
                      end
                 elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                         @user = User.where(:id => sub_category_or_city.user_id)
                         @user.each do |users|
                            we = entity_search.merge(:is_active => sub_category_or_city.is_active,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:api_id => sub_category_or_city.api_id,:is => "Rating",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                            @entity_search << we
                         end
                       end
                 elsif @user_entities_with_only_city.present?
                       @user_entities_with_only_city.each do |city|
                           @user = User.where(:id => city.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:is_active => city.is_active,:caputredDeviceOrientation => city.caputredDeviceOrientation,:ycody => city.ycody,:xcody => city.xcody,:api_id => city.api_id,:is => "Rating",:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                              @entity_search << we
                           end
                        end
                  elsif @user_entities_with_only_sub_category.present?
                        @user_entities_with_only_sub_category.each do |sub_category|
                           @user = User.where(:id => sub_category.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:is_active => sub_category.is_active,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:api_id => sub_category.api_id,:is => "Rating",:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                              @entity_search << we
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

               cate <<  cat.id
               end
               end
               @user_entities_rat_all = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.id}
               @user_entities_with_sub_category_and_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.id}
               @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:created_at,:desc]).uniq{|p|  p.id}
               @user_entities_with_sub_category_or_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:created_at,:desc]).uniq{|p|  p.id}
               @user_entities_with_only_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city).order_by([:created_at,:desc]).uniq{|p| p.id}
               @user_entities_with_only_sub_category = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.id}
               @user_entity_with_rating = UserEntity.in(:user_category_id => cate).where(:is_public => "true").order_by([:created_at,:desc]).uniq{|p| p.id && p.entity_name }
if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_rating.each do |ratings|
                            @user = User.where(:id => ratings.user_id)
                            @user.each do |users|
                               we = entity_search.merge(:is_active => ratings.is_active,:created_at =>ratings.created_at,:caputredDeviceOrientation => ratings.caputredDeviceOrientation,:ycody => ratings.ycody,:xcody => ratings.xcody,:api_id => ratings.api_id,:is => "Recent",:user_entity_id => ratings.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => ratings.address, :comment => ratings.comment, :entity_image => ratings.entity_image, :entity_name => ratings.entity_name.downcase,  :rating_count => ratings.rating_count, :sub_category => ratings.sub_category, :lat => ratings.lat , :longitude => ratings.longitude, :user_category_id =>  ratings.user_category_id)
                               @entity_search << we
                            end
                        end

            elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is_active => rating_all.is_active,:created_at =>rating_all.created_at,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:api_id => rating_all.api_id,:is => "Recent",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end

            else
              if @user_entities_rat_all.present?
                  @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is_active => rating_all.is_active,:created_at =>rating_all.created_at,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:api_id => rating_all.api_id,:is => "Recent",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end
               elsif @user_entities_with_sub_category_and_city.present?
                     @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                        ue = sub_category_and_city.id
                        @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                        @user = User.where(:id => sub_category_and_city.user_id)
                        @user.each do |users|
                           we = entity_search.merge(:is_active => sub_category_and_city.is_active,:created_at =>sub_category_and_city.created_at,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:api_id => sub_category_and_city.api_id,:is => "Recent",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name.downcase,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                           @entity_search << we
                        end
                      end
                elsif @user_entities_with_rat_and_city_or_sub_category.present?
                      @user_entities_with_rat_and_city_or_sub_category.each do |rat_and_city_or_sub_category|
                         @user = User.where(:id => rat_and_city_or_sub_category.user_id)
                         @user.each do |users|
                             we = entity_search.merge(:is_active => rat_and_city_or_sub_category.is_active,:created_at =>rat_and_city_or_sub_category.created_at,:caputredDeviceOrientation => rat_and_city_or_sub_category.caputredDeviceOrientation,:ycody => rat_and_city_or_sub_category.ycody,:xcody => rat_and_city_or_sub_category.xcody,:api_id => rat_and_city_or_sub_category.api_id,:is => "Recent",:user_entity_id => rat_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rat_and_city_or_sub_category.address, :comment => rat_and_city_or_sub_category.comment, :entity_image => rat_and_city_or_sub_category.entity_image, :entity_name => rat_and_city_or_sub_category.entity_name.downcase,  :rating_count => rat_and_city_or_sub_category.rating_count, :sub_category => rat_and_city_or_sub_category.sub_category, :lat => rat_and_city_or_sub_category.lat , :longitude => rat_and_city_or_sub_category.longitude, :user_category_id =>  rat_and_city_or_sub_category.user_category_id)
                             @entity_search << we
                         end
                      end
                 elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                         @user = User.where(:id => sub_category_or_city.user_id)
                         @user.each do |users|
                            we = entity_search.merge(:is_active => sub_category_or_city.is_active,:created_at =>sub_category_or_city.created_at,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:api_id => sub_category_or_city.api_id,:is => "Recent",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                            @entity_search << we
                         end
                       end
                 elsif @user_entities_with_only_city.present?
                       @user_entities_with_only_city.each do |city|
                           @user = User.where(:id => city.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:is_active => city.is_active,:created_at =>city.created_at,:caputredDeviceOrientation => city.caputredDeviceOrientation,:ycody => city.ycody,:xcody => city.xcody,:api_id => city.api_id,:is => "Recent",:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                              @entity_search << we
                           end
                        end
                  elsif @user_entities_with_only_sub_category.present?
                        @user_entities_with_only_sub_category.each do |sub_category|
                           @user = User.where(:id => sub_category.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:is_active => sub_category.is_active,:created_at =>sub_category.created_at,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:api_id => sub_category.api_id,:is => "Recent",:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                              @entity_search << we
                           end
                        end
                     end
            end
 @final_data = @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]} && @entity_search.sort_by { |k| k["created_at"]}
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
                           cate << cat.id
                           user = cat.user_id

              end
                    end
                           if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
                              @user_entity_with_proxy = UserEntity.near(center,10000000).and.where(:is_public => "true").in(:user_category_id => cate).uniq{|p| p.id}
                              @user_entity_with_proxy.each do |proxy|
                                distance = 0
                                distance= Geocoder::Calculations.distance_between(center, [proxy.lat, proxy.longitude])
                                @users = User.where(:id => proxy.user_id)
                                @users.each do |users|
                                es = entity_search.merge(:is_active => proxy.is_active, :caputredDeviceOrientation => proxy.caputredDeviceOrientation,:ycody => proxy.ycody,:xcody => proxy.xcody,:api_id => proxy.api_id,:distance => distance.to_s, :is => "Proxy",:user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
                                @entity_search << es
                            end
                          end

                           else

                            @user_entities_proxy_all = UserEntity.near(center,10000000).and.where(:is_public => "true").in(:user_category_id => cate,:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p|  p.id}
                            @user_entities_proxy_all.each do |pro|
                              distance = 0
                              distance= Geocoder::Calculations.distance_between(center, [pro.lat, pro.longitude])
                                 @users = User.where(:id => pro.user_id)
                                    @users.each do |users|
                                        es = entity_search.merge(:is_active => pro.is_active, :caputredDeviceOrientation => pro.caputredDeviceOrientation,:ycody => pro.ycody,:xcody => pro.xcody,:api_id => pro.api_id,:distance => distance.to_s, :is => "Proxy",:user_entity_id => pro.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => pro.address, :comment => pro.comment, :entity_image => pro.entity_image, :entity_name => pro.entity_name,  :rating_count => pro.rating_count, :sub_category => pro.sub_category, :lat => pro.lat , :longitude => pro.longitude, :user_category_id =>  pro.user_category_id)
                                        @entity_search << es
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
               cate << cat.id
               end
              end
               @user_entities_rat_all = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.id}
               @user_entities_with_sub_category_and_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.id}
               @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.id}
               @user_entities_with_sub_category_or_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.id}
               @user_entities_with_only_city = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc]).uniq{|p| p.id}
               @user_entities_with_only_sub_category = UserEntity.where(:is_public => "true").in(:user_category_id => cate,:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.id}
               @user_entity_with_rating = UserEntity.where(:is_public => "true").in(:user_category_id => cate).order_by([:rating_count,:desc]).uniq{|p| p.id}
if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_rating.each do |ratings|
                            @user = User.where(:id => ratings.user_id)
                            @user.each do |users|
                               we = entity_search.merge(:is_active => ratings.is_active,:caputredDeviceOrientation => ratings.caputredDeviceOrientation,:ycody => ratings.ycody,:xcody => ratings.xcody,:api_id => ratings.api_id,:user_entity_id => ratings.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => ratings.address, :comment => ratings.comment, :entity_image => ratings.entity_image, :entity_name => ratings.entity_name.downcase,  :rating_count => ratings.rating_count, :sub_category => ratings.sub_category, :lat => ratings.lat , :longitude => ratings.longitude, :user_category_id =>  ratings.user_category_id)
                               @entity_search << we
                            end
                        end

            elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is_active => rating_all.is_active,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:api_id => rating_all.api_id,:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end

            else
              if @user_entities_rat_all.present?
                  @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is_active => rating_all.is_active,:caputredDeviceOrientation => rating_all.caputredDeviceOrientation,:ycody => rating_all.ycody,:xcody => rating_all.xcody,:api_id => rating_all.api_id,:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end
               elsif @user_entities_with_sub_category_and_city.present?
                     @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                        ue = sub_category_and_city.id
                        @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                        @user = User.where(:id => sub_category_and_city.user_id)
                        @user.each do |users|
                           we = entity_search.merge(:is_active => sub_category_and_city.is_active,:caputredDeviceOrientation => sub_category_and_city.caputredDeviceOrientation,:ycody => sub_category_and_city.ycody,:xcody => sub_category_and_city.xcody,:api_id => sub_category_and_city.api_id,:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name.downcase,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                           @entity_search << we
                        end
                      end
                elsif @user_entities_with_rat_and_city_or_sub_category.present?
                      @user_entities_with_rat_and_city_or_sub_category.each do |rat_and_city_or_sub_category|
                         @user = User.where(:id => rat_and_city_or_sub_category.user_id)
                         @user.each do |users|
                             we = entity_search.merge(:is_active => rat_and_city_or_sub_category.is_active,:caputredDeviceOrientation => rat_and_city_or_sub_category.caputredDeviceOrientation,:ycody => rat_and_city_or_sub_category.ycody,:xcody => rat_and_city_or_sub_category.xcody,:api_id => rat_and_city_or_sub_category.api_id,:user_entity_id => rat_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rat_and_city_or_sub_category.address, :comment => rat_and_city_or_sub_category.comment, :entity_image => rat_and_city_or_sub_category.entity_image, :entity_name => rat_and_city_or_sub_category.entity_name.downcase,  :rating_count => rat_and_city_or_sub_category.rating_count, :sub_category => rat_and_city_or_sub_category.sub_category, :lat => rat_and_city_or_sub_category.lat , :longitude => rat_and_city_or_sub_category.longitude, :user_category_id =>  rat_and_city_or_sub_category.user_category_id)
                             @entity_search << we
                         end
                      end
                 elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                         @user = User.where(:id => sub_category_or_city.user_id)
                         @user.each do |users|
                            we = entity_search.merge(:is_active => sub_category_or_city.is_active,:caputredDeviceOrientation => sub_category_or_city.caputredDeviceOrientation,:ycody => sub_category_or_city.ycody,:xcody => sub_category_or_city.xcody,:api_id => sub_category_or_city.api_id,:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                            @entity_search << we
                         end
                       end
                 elsif @user_entities_with_only_city.present?
                       @user_entities_with_only_city.each do |city|
                           @user = User.where(:id => city.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:is_active => city.is_active,:caputredDeviceOrientation => city.caputredDeviceOrientation,:ycody => city.ycody,:xcody => city.xcody,:api_id => city.api_id,:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                              @entity_search << we
                           end
                        end
                  elsif @user_entities_with_only_sub_category.present?
                        @user_entities_with_only_sub_category.each do |sub_category|
                           @user = User.where(:id => sub_category.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:is_active => sub_category.is_active,:caputredDeviceOrientation => sub_category.caputredDeviceOrientation,:ycody => sub_category.ycody,:xcody => sub_category.xcody,:api_id => sub_category.api_id,:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                              @entity_search << we
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

