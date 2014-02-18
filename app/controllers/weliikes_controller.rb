class WeliikesController < ApplicationController
   def weliike_sort
    entity_search = {}
    @entity_search = Array.new
    @category_relations = Array.new
    @rating = Array.new
    @cate = Array.new
    @api_id = Array.new
    @poster = Array.new
    @posters = Array.new
    @api_id_po = Array.new
    @sort_setting = EntitySetting.where(:user_id => params[:user_id]).first
    respond_to  do |format|
      if @sort_setting.sort_by == "Recent"
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
         @user_entities_with_sub_category_and_city = UserEntity.where(:is_public => "true").in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc").group_by { |t| t.api_id }
         @user_entities_with_only_city = UserEntity.where(:is_public => "true").in(:user_category_id => @cate,:city => @sort_setting.narrow_by_city).group_by { |t| t.api_id }
         @user_entities_with_only_sub_category = UserEntity.where(:is_public => "true").in(:user_category_id => @cate,:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => "desc").group_by { |t| t.api_id }
         @user_entity_with_recent = UserEntity.where(:is_public => "true").in(:user_category_id => @cate).order_by(:created_at => "desc").group_by { |t| t.api_id }#.uniq{|p| p.entity_name}
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)#, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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
 @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
       @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]} && @entity_search.sort_by { |k| k["created_at"]}
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:user_entities_with_sub_category_and_city =>"1",:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public =>"true").last
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

               @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
          @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]} && @entity_search.sort_by { |k| k["created_at"]}
       if !@final_data.blank?
          format.json {render :json => @final_data.uniq}
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
                         we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                        @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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
@post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                          @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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
@post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => user_entity.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Recent",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
           end
       @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]} && @entity_search.sort_by { |k| k["created_at"]}
       if !@final_data.blank?
         format.json {render :json =>@final_data.uniq}
         # format.json {render :json =>@final_data}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
         end
elsif @sort_setting.sort_by == "Rating"
         @user_relations = UserCategoryRelation.where(:user_id => @sort_setting.user_id, :user_category_id => params[:user_category_id], :is_active => "true")
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
         @user_entities_with_sub_category_and_city = UserEntity.where(:is_public => "true").in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).group_by { |t| t.api_id }
         @user_entities_with_only_city = UserEntity.where(:is_public => "true").in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc]).group_by { |t| t.api_id }
         @user_entities_with_only_sub_category = UserEntity.where(:is_public => "true").in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).group_by { |t| t.api_id }
         @user_entity_with_recent = UserEntity.where(:is_public => "true").in(:user_category_id => @cate).order_by([:rating_count,:desc]).group_by { |t| t.api_id }#.uniq{|p| p.entity_name}
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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


                           @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                           @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                         we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                            @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                           @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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
 @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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
                          @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                   end
                end
           end
       @final_data =  @entity_search.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]] && [a[:user_id]] <=> [b[:user_id]]}
       if !@final_data.blank?
         format.json {render :json =>@final_data.uniq}
         # format.json {render :json =>@final_data}
       else
          format.json {render :json => {:message => "Search not found"} }
       end
         end
      elsif @sort_setting.sort_by == "Friend"
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
         @user_entities_with_sub_category_and_city = UserEntity.in(:user_category_id =>@cate).where( :is_active => "true").in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc').group_by { |t| t.api_id }
         @user_entities_with_only_city = UserEntity.in(:user_category_id =>@cate).where(:is_active => "true").in(:city => @sort_setting.narrow_by_city).order_by(:created_at => 'desc').group_by { |t| t.api_id }
         @user_entities_with_only_sub_category = UserEntity.in(:user_category_id =>@cate).where(:is_active => "true").in(:sub_category => @sort_setting.narrow_by_sub_category).order_by(:created_at => 'desc').group_by { |t| t.api_id }
         @user_entity_with_friends = UserEntity.in(:user_category_id =>@cate).where(:is_active => "true").order_by(:created_at => 'desc').group_by { |t| t.api_id }
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

               @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                            @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                             @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                              @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                         we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                             @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                              @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                          we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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
   @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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
                         we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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
   @post_user_en = UserEntity.where(:api_id => user_entity.api_id, :user_id => params[:user_id]).first
                          if @post_user_en.present?
                             @user = User.where(:id => @post_user_en.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
                          else
                             @user = User.where(:id => user_entity.user_id)
                           @user.each do |user|
                             we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:created_at => @post.created_at,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => @post.post_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                              @entity_search << we
                           end
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
                              we = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,:xcody => user_entity.xcody,:city => user_entity.city,:api_id => user_entity.api_id,:is => "Friend",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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


      elsif @sort_setting.sort_by == "Proximity"
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
                @user_entity_with_proxy = UserEntity.near(center, 10000000).and.in(:user_category_id => @cate).group_by { |t| t.api_id }
                @user_entities_proxy_all = UserEntity.near(center,10000000).and.in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).group_by { |t| t.api_id }
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

                   es = entity_search.merge(:is_active => proxy.is_active,:ycody => proxy.ycody,:xcody => proxy.xcody,:city => proxy.city,:distance => distance.to_s, :is => "Proxy",:coordinates => proxy.coordinates, :user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                                        es = entity_search.merge(:is_active => user_entity.is_active,:created_at => @post.created_at,:ycody => user_entity.ycody,user_entity => user_entity.xcody,:city => user_entity.city,:distance => distance.to_s, :is => "Proxy",:coordinates => user_entity.coordinates, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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

                                        es = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,user_entity => user_entity.xcody,:city => user_entity.city,:distance => distance.to_s, :is => "Proxy",:coordinates => user_entity.coordinates, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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

                                  es = entity_search.merge(:is_active => proxy.is_active,:ycody => proxy.ycody,:xcody => proxy.xcody,:city => proxy.city,:distance => distance.to_s, :is => "Proxy",:coordinates => proxy.coordinates, :user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
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
                   @post = Post.in(:user_entity_id => @posters).where(:api_id => user_entity.api_id,:is_public => "true").last
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

                                        es = entity_search.merge(:is_active => user_entity.is_active,:created_at => @post.created_at,:ycody => user_entity.ycody,user_entity => user_entity.xcody,:city => user_entity.city,:distance => distance.to_s, :is => "Proxy",:coordinates => user_entity.coordinates, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
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

                                        es = entity_search.merge(:is_active => user_entity.is_active,:ycody => user_entity.ycody,user_entity => user_entity.xcody,:city => user_entity.city,:distance => distance.to_s, :is => "Proxy",:coordinates => user_entity.coordinates, :user_entity_id => user_entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name,  :rating_count => user_entity.rating_count, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id)
                                        @entity_search << es
                                    end
                   end
                end
                           end
                  @final_data = @entity_search.sort{|a,b| [a[:user_id]] <=> [b[:user_id]] && [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["distance"]}
                    @final_data =  @entity_search.sort_by { |k| k["distance"]}
                   if !@final_data.blank?
                          format.json {render :json => @final_data.uniq}
                      else
                         format.json {render :json => {:message => "search not found"} }
                       end
          end
      end
    end

 
    end
