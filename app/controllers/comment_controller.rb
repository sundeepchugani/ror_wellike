class CommentController < ApplicationController
  def post_comment
    @comment = Comment.new
    @rating = Rating.new
    @post = Post.where(:id => params[:post_id], :user_id => params[:user_id]).first
    respond_to do |format|
        @comment.update_attributes(:self_user_id => params[:self_user_id],:post_id => @post.id,:user_id => params[:user_id], :all_tag => params[:all_tag], :all_user_name_tag => params[:all_user_name_tag], :is_new_comment=> "1",:is_active => "1",:comment_text => params[:comment_text])
         if @comment.save
            coments =  params[:comment_text].split(" ")
    coments.each do |com|
      if com.include? "#"
        @tag = Tag.create
        co   = com.slice(1..-1)
        @tag.update_attributes(:tag_name => co, :comment_id => @comment.id, :post_id => params[:post_id])
        @tag.save
      else

      end
    end
         if params[:rating_count]
             @rating.update_attributes(:comment_id => @comment.id,:self_user_id => params[:self_user_id],:user_id => params[:user_id], :post_id => @post.id,  :rating_count => params[:rating_count])
             @rating.save
         end
         format.json {render :json => {:message => "comment_successfully"}}
         else
           format.json {render :json => {:error => "error during comment"}}
         end
      end
   end


  def entity_commentx
    @comment = Comment.new
    @rating = Rating.new
    @entity = UserEntity.where(:id => params[:user_entity_id], :user_id => params[:user_id]).first
    cat_id = @entity.user_category_id
    tad = params[:rating_count] == ""
    respond_to do |format|
       format.json {render :json =>tad}
    end
  end

  def entity_comment
    @comment = Comment.new
    @rating = Rating.new
    @entity = UserEntity.where(:id => params[:user_entity_id], :user_id => params[:user_id]).first
    cat_id = @entity.user_category_id
    respond_to do |format|
   
    @cat = UserCategory.where(:id => cat_id.to_s).first
    @comment.update_attributes(:self_user_id => params[:self_user_id],:user_entity_id =>@entity.id, :user_id => @entity.user_id, :all_tag => params[:all_tag], :all_user_name_tag => params[:all_user_name_tag], :is_new_comment=> "1",:is_active => "1",:comment_text => params[:comment_text])
      if @comment.save
        if (params[:rating_count]).nil? #&& params[:rating_count] != "0"
         else
          if @comment.self_user_id == @entity.user_id
             @rating.update_attributes(:comment_id =>@comment.id, :self_user_id => params[:self_user_id],:user_id => params[:user_id], :user_entity_id => params[:user_entity_id], :rating_count => params[:rating_count])
           @rating.save
          else
           @rating.update_attributes(:comment_id =>@comment.id, :self_user_id => params[:self_user_id],:user_id => params[:user_id], :user_entity_id => params[:user_entity_id], :rating_count => params[:rating_count])
           @rating.save
           
             @entities = UserEntity.where(:user_id => params[:self_user_id], :other_entity_id => @entity.id).first
             if @entities.present?
               @entities.update_attributes(:is_active => "1", :is_public => "1", :is_liike => "1")
               @entities.save
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
               @cat_user = UserCategory.where(:user_id => params[:self_user_id] , :master_category_id => @user_category.master_category_id, :is_active => "true" ).first
               if @cat_user.present?
                  @user_entity_create = UserEntity.new
                  @user_entity_create.update_attributes(:api_id => @entity.api_id,:entity_name => @entity.entity_name,:user_category_id => @cat_user.id, :user_id => params[:self_user_id], :is_active => "1", :is_public => "1" , :entity_image => @entity.entity_image, :entity_image_url => @entity.entity_image_url, :comment => @comment.comment_text, :address => @entity.address, :lat => @entity.lat, :longitude => @entity.longitude, :rating_count => @rating.rating_count, :sub_category => @entity.sub_category, :other_entity_id => @entity.id)
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
                  @user_category_create.update_attributes(:user_id => params[:self_user_id],:master_category_id => @cat.master_category_id, :is_active => "1" )
                  @user_entity_create = UserEntity.new
                  @user_entity_create.update_attributes(:api_id => @entity.api_id,:user_id => @user_category_create.user_id,:entity_name => @entity.entity_name,:user_category_id => @user_category_create.id, :is_active => "1", :is_public => "1" , :entity_image => @entity.entity_image, :entity_image_url => @entity.entity_image_url, :comment => @comment.comment_text, :address => @entity.address, :lat => @entity.lat, :longitude => @entity.longitude, :rating_count => @rating.rating_count, :sub_category => @entity.sub_category, :other_entity_id => @entity.id)
                  @user_category_create.save
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
               end
              end
              end
        
        end
          cd = !@entity.api_id.nil?
          format.json {render :json => {:message => "Comment Succesfully"}}
      else
        format.json {render :json => {:error => "Error During Comment"}}
        end
    
coments =  params[:comment_text].split(" ")
    coments.each do |com|
      if com.include? "#"
        @tag = Tag.create
        co   = com.slice(1..-1)
        @tag.update_attributes(:tag_name => co, :comment_id => @comment.id, :user_entity_id => params[:user_entity_id])
        @tag.save
      else
      end
    end
    end
  end


 def all_entity_comments
   @comments = Array.new
   coome = {}
   @en_po = Array.new
   @entity_info = Array.new
   @entity_user =  UserEntity.where(:id => params[:user_entity_id], :user_id => params[:user_id]).first
   @comment = Comment.where(:user_entity_id => @entity_user.id ).order_by(:created_at => "desc")
     @comment.each do |comm|
       start_time =  comm.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
       cd1 =  Comment.comment_text(comm.comment_text, params[:user_id],comm.user_entity_id)
       cd2 = cd1.join(" ")
        coomes = coome.merge(:time => @times,:comment_text => cd2,:created_time => comm.created_at)
        @ratings = Rating.where(:comment_id =>  comm.id )
        @ratings.each do |ratings|
           coomes = coomes.merge(:rating_count => ratings.rating_count)
        end
       @user = User.where(:id => comm.self_user_id)
       @user.each do |user|
         coomes = coomes.merge(:user_id => user.id , :user_name => user.first_name,:profile_picture => user.profile_picture_url)
         @comments << coomes
       end
     end
    respond_to do |format|
        format.json {render :json=> @comments}
    end
 end

 
def suggested_friends_name
  friend_name ={}
  @friend_names = Array.new
  @user_relation = UserCategoryRelation.where(:user_id => params[:user_id])
  @user_relation.each do |friend|
    @friend_name = User.where(:id => friend.user_id, :first_name => /.*#{params[:first_name][:char]}*./i)
    @friend_name.each do |name|
      fr_name = friend_name.merge(:user_name => name.first_name, :friend_user_id => name.id)
      @friend_names << fr_name
    end
  end
  respond_to do |format|
    format.json {render  :json  => @friend_names}
  end
end

 def comments_for_test
 
  respond_to do |format|
    format.json {render  :json  => @user_entity_with_recent}
  end
 end

def all_post_comments
     post_info = {}
   @post_info = Array.new
      @comments_post = Comment.where(:post_id => params[:post_id]).order_by(:created_at => "desc")
      @comments_post.each do |post_comments|
        start_time =  post_comments.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
         post_info_comment = post_info.merge(:time => @times,:comment_text => post_comments.comment_text, :created_time => post_comments.created_at)
         @rating_post = Rating.where(:comment_id => post_comments.id)
         @rating_post.each do |rat_post|
            post_info_comment = post_info_comment.merge(:rating_count => rat_post.rating_count)
         end
         @comment_user = User.where(:id =>post_comments.self_user_id )
         @comment_user.each do |user|
            post_info_comment = post_info_comment.merge(:user_name => user.first_name,:profile_picture => user.profile_picture_url)
            @post_info << post_info_comment
         end
      end
       respond_to do |format|
        format.json {render :json=> @post_info}
       end
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
