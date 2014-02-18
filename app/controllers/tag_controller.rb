class TagController < ApplicationController
  def post_tag
    @post_tag = Tag.new(params[:tag])
    respond_to do |format|
      if @post_tag.save
        format.json {render :json => {:message=> "Successfully Tag"}}
      else
        format.json {render :json => {:message=> "some error during tag"}}
      end
    end
  end

 def all_tag
entities = {}
    @user_tag = Tag.where(:tag_name => params[:tag_name])
    @user_tag.each do |tag|
      @user_entity = UserEntity.where(:id => tag.user_entity_id)
      @user_entity.each do |entity|
#        user_en = entities.merge(:user_entity_id => entity.id, :entity_image => entity.entity_image, :entity_name => entity.entity_name)
@entities << @user_entity
      end
    end
    respond_to do |format|
      format.json {render :json => @entities}
    end

 end


    def weliike
    entity_search = {}
    @entity_search = Array.new
    @category_relations = Array.new
    @rating = Array.new
    @sort_setting = EntitySetting.where(:user_id => params[:user_id]).first
    respond_to  do |format|
      if @sort_setting.sort_by == "Rating"
         @user_relations = UserCategoryRelation.where(:user_id => @sort_setting.user_id, :user_category_id => params[:user_category_id])
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         @category_relations.push(params[:user_id])
         @category_relations.each do |user_re|
            @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
            @user_category_id.each do |cat|
               cate = cat.id
               @user_entities_rat_all = UserEntity.where(:user_category_id => cate.to_s).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => cate.to_s).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_rat_and_city_or_sub_category = UserEntity.where(:user_category_id => cate.to_s).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name}
               @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => cate.to_s).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:rating_count,:desc]).uniq{|p|  p.entity_name}
               @user_entities_with_only_city = UserEntity.where(:user_category_id => cate.to_s).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => cate.to_s).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}
               @user_entity_with_rating = UserEntity.where(:user_category_id => cate.to_s).order_by([:rating_count,:desc]).uniq{|p| p.entity_name}

            if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
              @user_entity_with_rating.each do |ratings|
                            @user = User.where(:id => ratings.user_id)
                            @user.each do |users|
                               we = entity_search.merge(:is => "Rating",:user_entity_id => ratings.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => ratings.address, :comment => ratings.comment, :entity_image => ratings.entity_image, :entity_name => ratings.entity_name.downcase,  :rating_count => ratings.rating_count, :sub_category => ratings.sub_category, :lat => ratings.lat , :longitude => ratings.longitude, :user_category_id =>  ratings.user_category_id)
                               @entity_search << we
                            end
                        end

            elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is => "Rating",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end

            else
              if @user_entities_rat_all.present?
                  @user_entities_rat_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is => "Rating",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end
               elsif @user_entities_with_sub_category_and_city.present?
                     @user_entities_with_sub_category_and_city.each do |sub_category_and_city|
                        ue = sub_category_and_city.id
                        @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                        @user = User.where(:id => sub_category_and_city.user_id)
                        @user.each do |users|
                           we = entity_search.merge(:is => "Rating",:user_entity_id => sub_category_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_and_city.address, :comment => sub_category_and_city.comment, :entity_image => sub_category_and_city.entity_image, :entity_name => sub_category_and_city.entity_name.downcase,  :rating_count => sub_category_and_city.rating_count, :sub_category => sub_category_and_city.sub_category, :lat => sub_category_and_city.lat , :longitude => sub_category_and_city.longitude, :user_category_id =>  sub_category_and_city.user_category_id)
                           @entity_search << we
                        end
                      end
                elsif @user_entities_with_rat_and_city_or_sub_category.present?
                      @user_entities_with_rat_and_city_or_sub_category.each do |rat_and_city_or_sub_category|
                         @user = User.where(:id => rat_and_city_or_sub_category.user_id)
                         @user.each do |users|
                             we = entity_search.merge(:is => "Rating",:user_entity_id => rat_and_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rat_and_city_or_sub_category.address, :comment => rat_and_city_or_sub_category.comment, :entity_image => rat_and_city_or_sub_category.entity_image, :entity_name => rat_and_city_or_sub_category.entity_name.downcase,  :rating_count => rat_and_city_or_sub_category.rating_count, :sub_category => rat_and_city_or_sub_category.sub_category, :lat => rat_and_city_or_sub_category.lat , :longitude => rat_and_city_or_sub_category.longitude, :user_category_id =>  rat_and_city_or_sub_category.user_category_id)
                             @entity_search << we
                         end
                      end
                 elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                         @user = User.where(:id => sub_category_or_city.user_id)
                         @user.each do |users|
                            we = entity_search.merge(:is => "Rating",:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                            @entity_search << we
                         end
                       end
                 elsif @user_entities_with_only_city.present?
                       @user_entities_with_only_city.each do |city|
                           @user = User.where(:id => city.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:is => "Rating",:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                              @entity_search << we
                           end
                        end
                  elsif @user_entities_with_only_sub_category.present?
                        @user_entities_with_only_sub_category.each do |sub_category|
                           @user = User.where(:id => sub_category.user_id)
                           @user.each do |users|
                              we = entity_search.merge(:is => "Rating",:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                              @entity_search << we
                           end
                        end
                     end
            end

                  end
              end
              @final_data = @entity_search.sort{|a,b| [a[:user_id]] <=> [b[:user_id]] && [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["rating_count"]}
             # @final_data =  @entity_search.sort_by { |k| k["rating_count"]}
                        if !@final_data.blank?
                           format.json {render :json => @final_data}
                        else
                           format.json {render :json => {:message => "Search not found"} }
                        end
            elsif @sort_setting.sort_by == "Proximity"
                  center = Geocoder.coordinates(params[:address])
                  @category_relations = Array.new
                  cd = @sort_setting.user_id
                  @user_relations = UserCategoryRelation.where(:user_id => @sort_setting.user_id, :user_category_id => params[:user_category_id], :is_active => "true")
                  @user_relations.each do |user_relation|
                    @category_relations << user_relation.friend_user_id
                  end
                  @category_relations.push(params[:user_id])
                     @category_relations.each do |user_re|
                        @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re).uniq {|p|  p.id}
                        @user_category_id.each do |cat|
                           cate = cat.id
                           user = cat.user_id
                           if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
                              @user_entity_with_proxy = UserEntity.near(center, 10000000).and.where(:user_category_id => cat.id, :user_id => cat.user_id).uniq{|p| p.entity_name}
                              @user_entity_with_proxy.each do |proxy|
                                distance = 0
                                distance= Geocoder::Calculations.distance_between(center, [proxy.lat, proxy.longitude])
                                @users = User.where(:id => proxy.user_id)
                                @users.each do |users|

                                  es = entity_search.merge(:distance => distance.to_s, :is => "Proxy",:coordinates => proxy.coordinates, :user_entity_id => proxy.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => proxy.address, :comment => proxy.comment, :entity_image => proxy.entity_image, :entity_name => proxy.entity_name,  :rating_count => proxy.rating_count, :sub_category => proxy.sub_category, :lat => proxy.lat , :longitude => proxy.longitude, :user_category_id =>  proxy.user_category_id)
                                  @entity_search << es
                                end
                          end

                           else

                            @user_entities_proxy_all = UserEntity.near(center,10000000).and.where(:user_category_id => cat.id, :user_id => cat.user_id).in(:sub_category => @sort_setting.narrow_by_sub_category).uniq{|p|  p.entity_name}
                            @user_entities_proxy_all.each do |pro|
                              distance = 0
                              distance= Geocoder::Calculations.distance_between(center, [pro.lat, pro.longitude])
                                 @users = User.where(:id => pro.user_id)
                                    @users.each do |users|

                                        es = entity_search.merge(:distance => distance.to_s, :is => "Proxy",:coordinates => pro.coordinates, :user_entity_id => pro.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => pro.address, :comment => pro.comment, :entity_image => pro.entity_image, :entity_name => pro.entity_name,  :rating_count => pro.rating_count, :sub_category => pro.sub_category, :lat => pro.lat , :longitude => pro.longitude, :user_category_id =>  pro.user_category_id)
                                        @entity_search << es
                                    end
                              end


                           end
                      end
                    end
                   @final_data = @entity_search.sort{|a,b| [a[:user_id]] <=> [b[:user_id]] && [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity_search.sort_by { |k| k["distance"]}
                #    @final_data =  @entity_search.sort_by { |k| k["distance"]}
                    if !@final_data.blank?
                          format.json {render :json => @final_data}
                       else
                          format.json {render :json => {:message => "Search not found"} }
                       end
              elsif @sort_setting.sort_by == "Recent"
              @category_relations = Array.new
              weliike ={}
              cd = @sort_setting.user_id
              @user_relations = UserCategoryRelation.where(:user_id => @sort_setting.user_id, :user_category_id => params[:user_category_id], :is_active => "true")
              @user_relations.each do |user_relation|
                 @category_relations << user_relation.friend_user_id
              end
              @category_relations.push(params[:user_id])
              @category_relations.each do |user_re|
                @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
                @user_category_id.each do |cat|
                  cat_id = cat.id
                  @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => cat_id.to_s).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p| p.entity_name}
                  @user_entities_with_recent_and_city_or_sub_category = UserEntity.where(:user_category_id => cat_id.to_s).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:created_at,:desc]).uniq{|p| p.entity_name}
                  @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => cat_id.to_s).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by([:created_at,:desc]).uniq{|p|  p.entity_name}
                  @user_entities_with_only_city = UserEntity.where(:user_category_id => cat_id.to_s).in(:city => @sort_setting.narrow_by_city).order_by([:created_at,:desc]).uniq{|p| p.entity_name}
                  @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => cat_id.to_s).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:created_at,:desc]).uniq{|p|  p.entity_name}
                  @user_entity_with_recent = UserEntity.where(:user_category_id => cat_id.to_s).order_by([:created_at,:desc]).uniq{|p| p.entity_name}
                  if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
                    @user_entity_with_recent.each do |recent|
                                   ue = recent.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (recent.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if recent.rating_count == "0"
                      average = "0"
                    else
                      @rating << (recent.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
                      @user = User.where(:id => recent.user_id)
                       @user.each do |users|
                         we = weliike.merge(:is => "Recent",:created_at => recent.created_at, :user_entity_id => recent.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => recent.address, :comment => recent.comment, :entity_image => recent.entity_image, :entity_name => recent.entity_name.downcase,  :rating_count => recent.rating_count, :sub_category => recent.sub_category, :lat => recent.lat , :longitude => recent.longitude, :user_category_id =>  recent.user_category_id)
                         @entity_search << we
                      end
                    end

              elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_with_sub_category_and_city.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = entity_search.merge(:is => "Rating",:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @entity_search << we
                    end
                   end
                  else
              if @user_entities_recent_all.present?
                    @user_entities_recent_all.each do |all_with_ratings|
                     ue = all_with_ratings.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (all_with_ratings.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if all_with_ratings.rating_count == "0"
                      average = "0"
                    else
                      @rating << (all_with_ratings.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
                      @user = User.where(:id => all_with_ratings.user_id)
                      @user.each do |users|
                         we = weliike.merge(:is => "Recent",:created_at => all_with_ratings.created_at, :user_entity_id => all_with_ratings.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => all_with_ratings.address, :comment => all_with_ratings.comment, :entity_image => all_with_ratings.entity_image, :entity_name => all_with_ratings.entity_name.downcase,  :rating_count => all_with_ratings.rating_count, :sub_category => all_with_ratings.sub_category, :lat => all_with_ratings.lat , :longitude => all_with_ratings.longitude, :user_category_id =>  all_with_ratings.user_category_id)
                         @entity_search << we
                      end
                    end
                 elsif @user_entities_with_sub_category_and_city.present?
                    @user_entities_with_sub_category_and_city.each do |sub_cat_and_city|
                        ue = sub_cat_and_city.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (sub_cat_and_city.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if sub_cat_and_city.rating_count == "0"
                      average = "0"
                    else
                      @rating << (sub_cat_and_city.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
                       @user = User.where(:id => sub_cat_and_city.user_id)
                       @user.each do |users|
                         we = weliike.merge(:is => "Recent",:created_at => sub_cat_and_city.created_at, :user_entity_id => sub_cat_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_cat_and_city.address, :comment => sub_cat_and_city.comment, :entity_image => sub_cat_and_city.entity_image, :entity_name => sub_cat_and_city.entity_name.downcase,  :rating_count => sub_cat_and_city.rating_count, :sub_category => sub_cat_and_city.sub_category, :lat => sub_cat_and_city.lat , :longitude => sub_cat_and_city.longitude, :user_category_id =>  sub_cat_and_city.user_category_id)
                         @entity_search << we
                      end
                    end
                 elsif @user_entities_with_recent_and_city_or_sub_category.present?
                    @user_entities_with_recent_and_city_or_sub_category.each do |recent_with_city_or_sub_category|
                           ue = recent_with_city_or_sub_category.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (recent_with_city_or_sub_category.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if recent_with_city_or_sub_category.rating_count == "0"
                      average = "0"
                    else
                      @rating << (recent_with_city_or_sub_category.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
                      @user = User.where(:id => recent_with_city_or_sub_category.user_id)
                       @user.each do |users|
                         we = weliike.merge(:is => "Recent",:created_at => recent_with_city_or_sub_category.created_at, :user_entity_id => recent_with_city_or_sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => recent_with_city_or_sub_category.address, :comment => recent_with_city_or_sub_category.comment, :entity_image => recent_with_city_or_sub_category.entity_image, :entity_name => recent_with_city_or_sub_category.entity_name.downcase,  :rating_count => recent_with_city_or_sub_category.rating_count, :sub_category => recent_with_city_or_sub_category.sub_category, :lat => recent_with_city_or_sub_category.lat , :longitude => recent_with_city_or_sub_category.longitude, :user_category_id =>  recent_with_city_or_sub_category.user_category_id)
                         @entity_search << we
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
                      @user = User.where(:id => sub_category_or_city.user_id)
                       @user.each do |users|
                         we = weliike.merge(:is => "Recent",:created_at => sub_category_or_city.created_at, :user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                         @entity_search << we
                      end
                    end
                  elsif @user_entities_with_only_city.present?
                    @user_entities_with_only_city.each do |city|
                               ue = city.id
                  @ratings = Rating.where(:user_entity_id =>  ue.to_s )
                   if @ratings.present?
                       @ratings.each do |rat|
                         @rating << rat.rating_count
                       end
                      cd = (city.rating_count).to_i
                      @rating << cd
                      total = 0

                    @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                  else
                    if city.rating_count == "0"
                      average = "0"
                    else
                      @rating << (city.rating_count).to_i
                      total = 0
                      average = 0
                      @rating.each do |item|
                       total += item
                    end
                    average = total / @rating.length
                    end
                 end
                      @user = User.where(:id => city.user_id)
                       @user.each do |users|
                         we = weliike.merge(:is => "Recent",:created_at => city.created_at, :user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                         @entity_search << we
                      end
                    end
                   elsif @user_entities_with_only_sub_category.present?
                    @user_entities_with_only_sub_category.each do |sub_category|
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
                      @user = User.where(:id => sub_category.user_id)
                       @user.each do |users|
                         we = weliike.merge(:is => "Recent",:created_at => sub_category.created_at, :user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                         @entity_search << we
                      end
                    end
                  end
                  end


                end
              end
@final_data = @entity_search.sort{|a,b| [a[:entity_name]] <=> [b[:entity_name]] }# && @entity_search.sort_by { |k| k["created_at"]}
       # @entity_search.sort_by { |k| k["created_at"]}
                    if !@final_data.blank?
                format.json {render :json => @final_data}
              else
                format.json {render :json => {:message =>  "search not found"}}
              end

            elsif @sort_setting.sort_by == "Friend"
              @friend = Array.new
              friendsss = {}
              friends = Array.new
              @user_c = UserCategory.where(:id => params[:user_category_id]).first
              @friends = Relatoinship.where(:user_id => @sort_setting.user_id)
              @friends.each do |friend|
                friends << friend.friend_user_id
              end
              friends.each do |fr|
                @categories = UserCategory.where(:master_category_id => params[:master_category_id], :user_id => fr).uniq {|p| p.user_id}
                @categories.each do |cate|
                  cat = cate.id
                  @user_entities_friends_all = UserEntity.where(:user_category_id => cat.to_s).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by(:user_id => fr)
                  @user_entities_with_sub_category_and_city = UserEntity.where(:user_category_id => cat.to_s).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category)
                  @user_entities_with_friends_and_city_or_sub_category = UserEntity.where(:user_category_id => cat.to_s).in(:city => @sort_setting.narrow_by_city || {:sub_category => @sort_setting.narrow_by_sub_category}).order_by(:user_id => fr)
                  @user_entities_with_sub_category_or_city = UserEntity.where(:user_category_id => cat.to_s).in(:city => @sort_setting.narrow_by_sub_category || {:sub_category => @sort_setting.narrow_by_sub_category})
                  @user_entities_with_only_city = UserEntity.where(:user_category_id => cat.to_s).in(:city => @sort_setting.narrow_by_city)
                  @user_entities_with_only_sub_category = UserEntity.where(:user_category_id => cat.to_s).in(:sub_category => @sort_setting.narrow_by_sub_category)
                  @user_entity_with_friends = UserEntity.where(:user_category_id => cat.to_s).order_by(:user_id => fr)

                   if @sort_setting.narrow_by_sub_category.empty? && @sort_setting.narrow_by_city.empty?
                   @user_entity_with_friends.each do |friends|
                      @user = User.where(:id => friends.user_id)
                        @user.each do |users|
                          we = friendsss.merge(:user_entity_id => friends.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => friends.address, :comment => friends.comment, :entity_image => friends.entity_image, :entity_name => friends.entity_name.downcase,  :rating_count => friends.rating_count, :sub_category => friends.sub_category, :lat => friends.lat , :longitude => friends.longitude, :user_category_id =>  friends.user_category_id)
                          @friend << we
                        end
                    end
                    elsif @sort_setting.narrow_by_sub_category.present? && @sort_setting.narrow_by_city.present?
              @user_entities_friends_all.each do |rating_all|
                    @user = User.where(:id => rating_all.user_id)
                    @user.each do |users|
                       we = friendsss.merge(:user_entity_id => rating_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => rating_all.address, :comment => rating_all.comment, :entity_image => rating_all.entity_image, :entity_name => rating_all.entity_name.downcase,  :rating_count => rating_all.rating_count, :sub_category => rating_all.sub_category, :lat => rating_all.lat , :longitude => rating_all.longitude, :user_category_id =>  rating_all.user_category_id)
                       @friend << we
                    end
                   end
                   else
                   if @user_entities_friends_all.present?
                    @user_entities_friends_all.each do |friend_all|

                      @user = User.where(:id => friend_all.user_id)
                       @user.each do |users|
                         we = friendsss.merge(:user_entity_id => friend_all.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => friend_all.address, :comment => friend_all.comment, :entity_image => friend_all.entity_image, :entity_name => friend_all.entity_name.downcase,  :rating_count => friend_all.rating_count, :sub_category => friend_all.sub_category, :lat => friend_all.lat , :longitude => friend_all.longitude, :user_category_id =>  friend_all.user_category_id)
                         @friend << we
                      end
                    end

                  elsif @user_entities_with_sub_category_and_city.present?
                    @user_entities_with_sub_category_and_city.each do |sub_cat_and_city|
                      @user = User.where(:id => sub_cat_and_city.user_id)
                       @user.each do |users|
                         we = friendsss.merge(:user_entity_id => sub_cat_and_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_cat_and_city.address, :comment => sub_cat_and_city.comment, :entity_image => sub_cat_and_city.entity_image, :entity_name => sub_cat_and_city.entity_name.downcase,  :rating_count => sub_cat_and_city.rating_count, :sub_category => sub_cat_and_city.sub_category, :lat => sub_cat_and_city.lat , :longitude => sub_cat_and_city.longitude, :user_category_id =>  sub_cat_and_city.user_category_id)
                         @friend << we
                      end
                    end

                    elsif @user_entities_with_friends_and_city_or_sub_category.present?
                      @user_entities_with_friends_and_city_or_sub_category.each do |friends_with_sub_category_or_city|
                        @user = User.where(:id => friends_with_sub_category_or_city.user_id)
                        @user.each do |users|
                          we = friendsss.merge(:user_entity_id => friends_with_sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => friends_with_sub_category_or_city.address, :comment => friends_with_sub_category_or_city.comment, :entity_image => friends_with_sub_category_or_city.entity_image, :entity_name => friends_with_sub_category_or_city.entity_name.downcase,  :rating_count => friends_with_sub_category_or_city.rating_count, :sub_category => friends_with_sub_category_or_city.sub_category, :lat => friends_with_sub_category_or_city.lat , :longitude => friends_with_sub_category_or_city.longitude, :user_category_id =>  friends_with_sub_category_or_city.user_category_id)
                          @friend << we
                        end
                      end

                    elsif @user_entities_with_sub_category_or_city.present?
                      @user_entities_with_sub_category_or_city.each do |sub_category_or_city|
                        @user = User.where(:id => sub_category_or_city.user_id)
                        @user.each do |users|
                          we = friendsss.merge(:user_entity_id => sub_category_or_city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category_or_city.address, :comment => sub_category_or_city.comment, :entity_image => sub_category_or_city.entity_image, :entity_name => sub_category_or_city.entity_name.downcase,  :rating_count => sub_category_or_city.rating_count, :sub_category => sub_category_or_city.sub_category, :lat => sub_category_or_city.lat , :longitude => sub_category_or_city.longitude, :user_category_id =>  sub_category_or_city.user_category_id)
                          @friend << we
                        end
                      end

                  elsif @user_entities_with_only_city.present?
                    @user_entities_with_only_city.each do |city|
                      @user = User.where(:id => city.user_id)
                        @user.each do |users|
                          we = friendsss.merge(:user_entity_id => city.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => city.address, :comment => city.comment, :entity_image => city.entity_image, :entity_name => city.entity_name.downcase,  :rating_count => city.rating_count, :sub_category => city.sub_category, :lat => city.lat , :longitude => city.longitude, :user_category_id =>  city.user_category_id)
                          @friend << we
                        end
                    end

                  elsif @user_entities_with_only_sub_category.present?
                    @user_entities_with_only_sub_category.each do |sub_category|
                      @user = User.where(:id => sub_category.user_id)
                        @user.each do |users|
                          we = friendsss.merge(:user_entity_id => sub_category.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => sub_category.address, :comment => sub_category.comment, :entity_image => sub_category.entity_image, :entity_name => sub_category.entity_name.downcase,  :rating_count => sub_category.rating_count, :sub_category => sub_category.sub_category, :lat => sub_category.lat , :longitude => sub_category.longitude, :user_category_id =>  sub_category.user_category_id)
                          @friend << we
                        end
                    end
                end

                   end


                end
            end
            @final_data = @friend.sort{|a,b| [a[:user_id]] <=> [b[:user_id]] && [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @friend.sort_by { |k| k["created_at"]}
              if !@final_data.blank?
                format.json {render :json => @final_data}
              else
                format.json {render :json => {:message =>  "search not found"}}
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
                    we = weliike.merge(:user_id => user.id, :profile_picture => user.profile_picture_url, :user_name => user.first_name, :entity_name => user_entity.entity_name, :entity_image => user_entity.entity_image, :entity_id => user_entity.id, :master_category_id => cat.master_category_id ,:rating_count => average)
                    @welike << we
                 end
               end
            end
         end
      end
    end
  end

end
