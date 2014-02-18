class Rating
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :post
  belongs_to :user_entities
  
  field :user_id, :type => String
  field :self_user_id, :type => String
  field :post_id, :type => String
  field :user_entity_id => String
  field :rating_count, :type => Integer
  field :comment_id, :type => String

  def  self.average_rating_count(user_entity_id,rating_count)
     @ratings = Rating.where(:user_entity_id => user_entity_id )
     if @ratings.present?
        @ratings.each do |rat|
            @rating << rat.rating_count
        end
        cd = (rating_count).to_i
        @rating << cd
        total = 0
        @rating.each do |item|
           total += item
        end
        average = total / @rating.length
      else
          if rating_count == "0"
             average = "0"
          else
             @rating << (rating_count).to_i
             total = 0
             average = 0
             @rating.each do |item|
                total += item
             end
             average = total / @rating.length
          end
     end
  end



#  each do | (key, value) |
#                   value.each do |user_entity|
#                   @user_category = UserCategory.where(:id => user_entity.user_category_id)
#                      @user_category.each do |cat|
#                        if user_entity.api_id.nil?
#                           ue = user_entity.id
#                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
#                             @ratings = Rating.where(:user_entity_id =>user_entity.id )
#                             if @ratings.present?
#                                @ratings.each do |rat|
#                                    @rating << rat.rating_count
#                                end
#                                cd = (user_entity.rating_count).to_i
#                                @rating << cd
#                                total = 0
#                                @rating.each do |item|
#                                   total += item
#                                end
#                                average = total / @rating.length
#                              else
#                                  if user_entity.rating_count == "0"
#                                     average = "0"
#                                  else
#                                     @rating << (user_entity.rating_count).to_i
#                                     total = 0
#                                     average = 0
#                                     @rating.each do |item|
#                                        total += item
#                                     end
#                                     average = total / @rating.length
#                                  end
#                             end
#                       else
#                         average = user_entity.rating_count
#                       end
#                       @user = User.where(:id => user_entity.user_id)
#                       @user.each do |user|
#                          we = entity_search.merge(:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
#                          @entity_search << we
#                       end
#                     else
#                        @post = Post.where(:user_entity_id => user_entity.id).uniq {|p| p.user_entity_id }.last#.order_by(:created_at => "desc")
#                        if @post.present?
#                           ue = user_entity.id
#                           if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
#                             @ratings = Rating.where(:user_entity_id =>user_entity.id )
#                             if @ratings.present?
#                                @ratings.each do |rat|
#                                    @rating << rat.rating_count
#                                end
#                                cd = (user_entity.rating_count).to_i
#                                @rating << cd
#                                total = 0
#                                @rating.each do |item|
#                                   total += item
#                                end
#                                average = total / @rating.length
#                              else
#                                  if user_entity.rating_count == "0"
#                                     average = "0"
#                                  else
#                                     @rating << (user_entity.rating_count).to_i
#                                     total = 0
#                                     average = 0
#                                     @rating.each do |item|
#                                        total += item
#                                     end
#                                     average = total / @rating.length
#                                  end
#                             end
#                           else
#                              average = user_entity.rating_count
#                          end
#                          @user = User.where(:id => user_entity.user_id)
#                          @user.each do |user|
#                             we = entity_search.merge(:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
#                             @entity_search << we
#                          end
#                      else
#                          ue = user_entity.id
#                          if user_entity.user_id == params[:user_id] && user_entity.rating_count.nil?
#                             @ratings = Rating.where(:user_entity_id =>user_entity.id )
#                             if @ratings.present?
#                                @ratings.each do |rat|
#                                    @rating << rat.rating_count
#                                end
#                                cd = (user_entity.rating_count).to_i
#                                @rating << cd
#                                total = 0
#                                @rating.each do |item|
#                                   total += item
#                                end
#                                average = total / @rating.length
#                              else
#                                  if user_entity.rating_count == "0"
#                                     average = "0"
#                                  else
#                                     @rating << (user_entity.rating_count).to_i
#                                     total = 0
#                                     average = 0
#                                     @rating.each do |item|
#                                        total += item
#                                     end
#                                     average = total / @rating.length
#                                  end
#                             end
#                           else
#                               average = user_entity.rating_count
#                           end
#                           @user = User.where(:id => user_entity.user_id)
#                           @user.each do |user|
#                              we = entity_search.merge(:api_id => user_entity.api_id,:is => "Rating",:user_entity_id => user_entity.id ,:user_id => user.id, :profile_picture => user.profile_picture_url, :first_name => user.first_name,:address => user_entity.address, :comment => user_entity.comment, :entity_image => user_entity.entity_image, :entity_name => user_entity.entity_name.downcase,  :rating_count => average, :sub_category => user_entity.sub_category, :lat => user_entity.lat , :longitude => user_entity.longitude, :user_category_id =>  user_entity.user_category_id, :master_category_id => cat.master_category_id)
#                              @entity_search << we
#                           end
#                        end
#                      end
#                    end
#                  end
#               end

end
