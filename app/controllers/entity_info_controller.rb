class EntityInfoController < ApplicationController
  def details
     @relas = Array.new
    @rating = Array.new
    @detai = Array.new
    @comments =  Array.new
    @posst_info =  Array.new
    detai = {}
     @post_info = Array.new
    post_infos = {}
    @post_other = Array.new
    @post_id = Array.new
    post_info = {}
    post_en = {}
    en_po = {}
    @post_idc = Array.new
    @en_po =  Array.new
    @enq_po =  Array.new
    coome = {}
    @post = Array.new
    @entity_details = UserCategoryRelation.where(:user_id => params[:user_id], :is_active => "true")
    @entity_details.each do |rela|
      @relas << rela.friend_user_id
    end
    respond_to do |format|
      @relas.push(params[:user_id])
    @user_enti = UserEntity.in(:user_id => @relas).where(:api_id => params[:api_id]).last#.order_by(:created_at => "desc")
    @categories = UserCategory.where(:id => @user_enti.user_category_id).first
    @categ = MasterCategory.where(:id =>@categories.master_category_id).first
    @users = User.where(:id => @user_enti.user_id).first
    @comment = Comment.where(:user_entity_id => @user_enti.id ).limit(2).order_by(:created_at => "desc")
    @comment.each do |comm|
       cd1 =  Comment.comment_text(comm.comment_text, @user_enti.user_id,comm.user_entity_id)
       cd2 = cd1.join(" ")
       coomes = coome.merge(:comment_text => cd2,:created_time => comm.created_at)
       @ratingss = Rating.where(:comment_id => comm.id)
       @ratingss.each do |coom|
         coomes = coomes.merge( :comment_rating => coom.rating_count)
       end
       @user = User.where(:id => comm.self_user_id)
       @user.each do |user|
         coomes = coomes.merge(:other_user => "No",:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url, :comment_count => @comment.count)
         @comments << coomes
       end
    end
    if @user_enti.rating_count.nil?
       @ratings = Rating.where(:user_entity_id => @user_enti.id )
       if @ratings.present?
           @ratings.each do |rat|
             @rating << rat.rating_count
           end
           cd = (@user_enti.rating_count).to_i
           @rating << cd
           total = 0
           @rating.each do |item|
             total += item
           end
           average = total / @rating.length
        else
           if @user_enti.rating_count == "0"
              average = "0"
           else
               @rating << (@user_enti.rating_count).to_i
               total = 0
               average = 0
               @rating.each do |item|
                  total += item
               end
               average = total / @rating.length
           end

        end
      else
           average = @user_enti.rating_count
    end
    if @user_enti.comment.nil?
       ent = detai.merge(:other_user => "No",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_enti.api_id,:ycody => @user_enti.ycody,:xcody => @user_enti.xcody,:def => @user_enti.def,  :city => @user_enti.city,:comment_text => @user_enti.comment, :user_entity_id => @user_enti.id, :user_id => @user_enti.user_id,:user_entity_name => @user_enti.entity_name,:user_entity_image => @user_enti.entity_image,:latitute => @user_enti.lat, :longitude => @user_enti.longitude, :information => @user_enti.information, :address => @user_enti.address, :rating_count => average,  :comment =>@comments)
    else
       cd4 =  Comment.comment_text(@user_enti.comment, @user_enti.user_id,@user_enti.id)
       cd5 = cd4.join(" ")
       ent = detai.merge(:other_user => "No",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_enti.api_id,:ycody => @user_enti.ycody,:xcody => @user_enti.xcody,:def => @user_enti.def,  :city => @user_enti.city,:comment_text => cd5, :user_entity_id => @user_enti.id, :user_id => @user_enti.user_id,:user_entity_name => @user_enti.entity_name,:user_entity_image => @user_enti.entity_image,:latitute => @user_enti.lat, :longitude => @user_enti.longitude, :information => @user_enti.information, :address => @user_enti.address, :comment =>@comments, :rating_count => average)
    end
    @detai << ent

      @relas.uniq
      @entity_post = Post.in(:user_id => @relas.uniq).where(:api_id => params[:api_id], :is_active => "true").order_by(:created_at => "desc")
   @entity_post.each do |post|
     @post_id << post.id
     @comments_posts = Comment.in(:post_id =>@post_id).order_by(:created_at => "desc")#.limit(2)

      @comments_posts.each do |post_comments|
        @comment_count_data = Comment.where(:id => post_comments.id)

        cd1 =  Comment.comment_text(post_comments.comment_text, post_comments.user_id,post_comments.user_entity_id)
        cd2 = cd1.join(" ")
        post_info_comment = post_info.merge(:post_id => post_comments.post_id ,:comment_text => cd2, :created_time => post_comments.created_at)
         @rating_post = Rating.where(:comment_id => post_comments.id)
         @rating_post.each do |rat_post|
            post_info_comment = post_info_comment.merge(:rating_count => rat_post.rating_count)
         end
         @comment_user = User.where(:id =>post_comments.self_user_id )
         @comment_user.each do |user|
            post_info_comment = post_info_comment.merge(:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url)
         @post_info << post_info_comment
         end
      end
     cd1 =  Comment.comment_text(post.comment_text, post.user_id,post.user_entity_id)
        cd2 = cd1.join(" ")
      post_en = en_po.merge(:other_user => "No",:ycody => post.ycody,:xcody => post.xcody,:def => @user_enti.def,:comment_text => cd2,:post_id => post.id ,:user_entity_id => post.user_entity_id, :user_id => post.user_id,:user_entity_name => @user_enti.entity_name,:post_image => post.post_image_url,:latitute => post.lat, :longitude => post.longitude, :address => @user_enti.address, :rating_count => post.rating_count.to_s)
      @en_po << post_en
   end

       
    #@en_po.sort_by! { |thing| thing["created_at"] }
   # @results = Kaminari.paginate_array(@en_po).page(params[:page]).per(10)
    format.json {render :json=> {:entity_info => @detai, :post_info => @post_info}   }
    
    end
 end

end