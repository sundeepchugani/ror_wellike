require 'will_paginate/array'
class UserEntityController < ApplicationController 
  def new
    @user_entity = UserEntity.new
    @master_entity = MasterEntity.all
    @user = User.all
  end
def get_entity_by_user_id_cat_id
    user_entity = {}
    @rating = Array.new
    @entity = Array.new
    respond_to do |format|
      @get_entity_user =  UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id]).order_by([:created_at,:desc]).paginate(:page => params[:page],:per_page => 10).uniq {|p|  p.entity_name}
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
        us = user_entity.merge(:sub_category =>entity.sub_category, :address => entity.address, :city => entity.city, :user_id => user.id, :profile_picture => user.profile_picture_url,:user_name => user.first_name, :user_category_id =>entity.user_category_id, :entity_name => entity.entity_name,:entity_image => entity.entity_image, :user_entity_id =>entity.id, :rating_count => average )
       @entity << us
       end
 end

     format.json {render :json => @entity}
   end
   end

  def create
    location = Array.new
    user_entity = (params[:user_entity_id]).split(",")
    user_entity.each do |entity|
     @user_entity = UserEntity.where(:id => entity)
     @user_entity.each do |entities_us|
         @user_entit = UserEntity.create
        location << entities_us.lat.to_f
        location << entities_us.longitude.to_f
        @user_entit.update_attributes(:artist => entities_us.artist,:caputredDeviceOrientation => entities_us.caputredDeviceOrientation,:xcody =>entities_us.xcody, :ycody => entities_us.ycody,:is_public => "1",:api_id => entities_us.api_id,:city => params[:city], :user_id =>params[:user_id], :user_category_id =>params[:user_category_id]  ,:is_active => "1",:entity_image => entities_us.entity_image, :entity_name => entities_us.entity_name,:information=>entities_us.information, :lat=> entities_us.lat, :longitude => entities_us.longitude , :loc => location, :rating_count => entities_us.rating_count, :sub_category => entities_us.sub_category,:address => entities_us.address)
        @user_entit.save
      end
     end
     respond_to do |format|
       format.json {render :json => {:message => "Add User Entity Successfully"}}
     end
   end

  def save_media
    @category_relations = Array.new
     location = Array.new
     @email_list = (params[:email_list]).split(",")
     cat = {}
     en = {}
     @entitys = Array.new
     @cat = Array.new
     category = params[:master_category_id].split(",")
     respond_to do |format|
       @master_category_check = category.collect { |f| MasterCategory.where(:id  => f).first}.compact
       @master_category_check.each do |master_category_check|
       if params[:api_id] == ""
         @user_categories = UserCategory.where(:user_id => params[:user_id], :master_category_id => params[:master_category_id]).first
         if @user_categories.present?
           @user_categories.update_attributes(:is_active => "1")
           @user_categories.save
            @user_entities_create = UserEntity.create
            if params[:entity_image]
               post_image = (params[:entity_image]).gsub(" ", "+")
               @entity_image = StringIO.new(Base64.decode64(post_image))
               @entity_image.class.class_eval { attr_accessor :original_filename, :content_type }
               @entity_image.original_filename = "entity_image.png"
               @entity_image.content_type = "image/png"
            end
            location << params[:lat].to_f
            location << params[:longitude].to_f
            @user_entities_create.update_attributes(:artist => params[:artist],:caputredDeviceOrientation => params[:caputredDeviceOrientation],:ycody => params[:ycody],:xcody => params[:xcody],:def => params[:def],:position =>params[:position],:coordinates => Geocoder.coordinates(params[:address]), :city => params[:city],:user_id =>@user_categories.user_id, :user_category_id => @user_categories.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => params[:sub_category],:entity_image => @entity_image, :comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1",:entity_image_url => @user_entities_create.entity_image, :is_active => params[:is_active])
            @user_entities_create.save
            if @email_list.present?
               @email_list.each do |email_list|
                  PostMailer.post_mailers(email_list).deliver
               end
            end
            if !(params[:receiver_id]).blank?
               message
            end
            if !(params[:group_id]).blank?
               group_message
            end
            format.json {render :json => @user_entities_create}
         else
            @user_category_create = UserCategory.create
            @user_category_create.update_attributes(:user_id => params[:user_id],:master_category_id => params[:master_category_id], :is_active => "1")
            @user_category_create.save
            @user_entity_create = UserEntity.create
            location << params[:lat].to_f
            location << params[:longitude].to_f
            if params[:entity_image]
              post_image = (params[:entity_image]).gsub(" ", "+")
              @entity_image = StringIO.new(Base64.decode64(post_image))
              @entity_image.class.class_eval { attr_accessor :original_filename, :content_type }
              @entity_image.original_filename = "entity_image.png"
              @entity_image.content_type = "image/png"
            end
            @user_category_relations = UserCategoryRelation.where(:user_id => params[:user_id], :user_category_id => @user_category_create.id, :friend_user_id => params[:user_id]).first
             if @user_category_relations.present?
             @user_category_relations.update_attributes(:is_active => "1")
             @user_category_relations.save
             else
              @user_category_relationss = UserCategoryRelation.new
              @user_category_relationss.update_attributes(:master_category_id=> params[:master_category_id],:is_active => "1" , :user_id => params[:user_id], :user_category_id => @user_category_create.id, :friend_user_id => params[:user_id])
              @user_category_relationss.save
             end
            @user_entity_create.update_attributes(:artist => params[:artist],:caputredDeviceOrientation => params[:caputredDeviceOrientation],:ycody => params[:ycody],:xcody => params[:xcody],:def => params[:def],:position =>params[:position],:coordinates => Geocoder.coordinates(params[:address]),:city => params[:city],:user_id =>@user_category_create.user_id, :user_category_id => @user_category_create.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => params[:sub_category],:entity_image => @entity_image, :is_active => params[:is_active],:comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1",:entity_image_url => @user_entity_create.entity_image)
            @user_entity_create.save
            if @email_list.present?
               @email_list.each do |email_list|
                  PostMailer.post_mailers(email_list).deliver
               end
            end
          if !(params[:receiver_id]).blank?
             message
          end
          if !(params[:group_id]).blank?
             group_message
          end
          ct = cat.merge(:artist => @user_entity_create,:caputredDeviceOrientation => @user_entity_create.caputredDeviceOrientation,:user_id =>@user_entity_create.user_id, :user_category_id => @user_entity_create.id,:entity_name => @user_entity_create.entity_name,:address => @user_entity_create.entity_name,:lat => @user_entity_create.lat, :longitude => @user_entity_create.longitude,:sub_category => @user_entity_create.sub_category,:entity_image => @entity_image, :entity_image_url => @user_entity_create.entity_image, :is_active => params[:is_active],:comment => @user_entity_create.comment,:rating_count => @user_entity_create.rating_count,:is_public => "1")
          @cat << ct
          format.json {render :json => @cat }
        end
      else
        @user_category = UserCategory.where(:master_category_id => master_category_check.id, :user_id => params[:user_id]).first# ,:user_id =>params[:user_id])
        if @user_category.present?
          @user_category.update_attributes(:is_active => "1")
           @api_entity = UserEntity.where(:api_id => params[:api_id], :user_id => params[:user_id])
           if @api_entity.present?
              @api_entity.each do |en|
                 @post_create = Post.create
                 if params[:entity_image]
                    post_image = (params[:entity_image]).gsub(" ", "+")
                    @post_image = StringIO.new(Base64.decode64(post_image))
                    @post_image.class.class_eval { attr_accessor :original_filename, :content_type }
                    @post_image.original_filename = "post_image.png"
                    @post_image.content_type = "image/png"
                 end
                 @post_create.update_attributes(:artist => params[:artist],:caputredDeviceOrientation => params[:caputredDeviceOrientation], :api_id => params[:api_id],:ycody => params[:ycody],:xcody => params[:xcody],:def => params[:def],:position =>params[:position],:rating_count=> params[:rating_count],:city => params[:city],:user_entity_id =>en.id, :comment_text => params[:comment],:user_id => params[:user_id], :is_active => params[:is_active],:is_public => "1", :all_tag => "ok", :all_user_name_tag => ".........OK",:is_new_comment => "1", :post_image => @post_image, :post_image_url => @post_create.post_image)
                 @post_create.save
                 en.update_attributes(:created_at => Time.now)
                 en.save
               end
               
             if @email_list.present?
                @email_list.each do |email_list|
                   PostMailer.post_mailers(email_list).deliver
                end
             end
             if !(params[:receiver_id]).blank?
                message
             end
             if !(params[:group_id]).blank?
                group_message
             end
            format.json {render :json =>@post_create }
          else
             @api_entity_create = UserEntity.create
             if params[:entity_image]
                entity_image = (params[:entity_image]).gsub(" ", "+")
                @entity_image = StringIO.new(Base64.decode64(entity_image))
                @entity_image.class.class_eval { attr_accessor :original_filename, :content_type }
                @entity_image.original_filename = "entity_image.png"
                @entity_image.content_type = "image/png"
             end
            location << params[:lat].to_f
            location << params[:longitude].to_f
            @api_entity_create.update_attributes(:artist => params[:artist],:caputredDeviceOrientation => params[:caputredDeviceOrientation],:ycody => params[:ycody],:xcody => params[:xcody],:def => params[:def],:position =>params[:position],:coordinates => Geocoder.coordinates(params[:address]),:city => params[:city],:feed => params[:feed],:api_id => params[:api_id],:user_id =>@user_category.user_id, :user_category_id => @user_category.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => params[:sub_category],:entity_image => @entity_image, :is_active => params[:is_active],:comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1", :entity_image_url => @api_entity_create.entity_image,:comment_text => params[:comment_text])
            @api_entity_create.save
            @user_relations = UserCategoryRelation.where(:user_id => params[:user_id],:is_active => "true")
            @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
            end
            @category_relations.push(params[:user_id])
            @poster = Post.where(:api_id => params[:api_id]).in(:user_id => @category_relations)
            if @poster.present?
              
            else
              @post_create = Post.new
              @post_create.update_attributes(:artist => params[:artist],:caputredDeviceOrientation => params[:caputredDeviceOrientation],:api_id => params[:api_id],:ycody => params[:ycody],:xcody => params[:xcody],:def => params[:def],:position =>params[:position],:rating_count=> params[:rating_count],:city => params[:city],:user_entity_id =>@api_entity_create.id, :comment_text => params[:comment],:user_id => params[:user_id], :is_active => "0",:is_public => "1", :all_tag => "ok", :all_user_name_tag => ".........OK",:is_new_comment => "1", :post_image => @api_entity_create.entity_image,:post_image_url => @api_entity_create.entity_image)
             @post_create.save
            end
         if @email_list.present?
            @email_list.each do |email_list|
               PostMailer.post_mailers(email_list).deliver
            end
         end
        if !(params[:receiver_id]).blank?
           message
        end
        if !(params[:group_id]).blank?
           group_message
        end
       format.json {render :json => @api_entity_create}
      end
      else
        @user_category_create = UserCategory.create
        @user_category_create.update_attributes(:user_id => params[:user_id],:master_category_id => params[:master_category_id], :is_active => "1")
        @user_category_create.save
        @user_entity_create = UserEntity.create
        if params[:entity_image]
           entity_image = (params[:entity_image]).gsub(" ", "+")
           @entity_image = StringIO.new(Base64.decode64(entity_image))
           @entity_image.class.class_eval { attr_accessor :original_filename, :content_type }
           @entity_image.original_filename = "entity_image.png"
           @entity_image.content_type = "image/png"
        end
        location << params[:lat].to_f
        location << params[:longitude].to_f
        @user_entity_create.update_attributes(:artist => params[:artist],:caputredDeviceOrientation => params[:caputredDeviceOrientation],:ycody => params[:ycody],:xcody => params[:xcody],:def => params[:def],:position =>params[:position],:coordinates => Geocoder.coordinates(params[:address]), :city => params[:city],:api_id => params[:api_id],:user_id =>@user_category_create.user_id, :user_category_id => @user_category_create.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => params[:sub_category],:entity_image => @entity_image, :is_active => params[:is_active],:comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1", :entity_image_url => @user_entity_create.entity_image)
        @user_entity_create.save
        @user_category_relations = UserCategoryRelation.where(:user_id => params[:user_id], :user_category_id => @user_category_create.id, :friend_user_id => params[:user_id]).first
             if @user_category_relations.present?
             @user_category_relations.update_attributes(:is_active => "1")
             @user_category_relations.save
             else
              @user_category_relationss = UserCategoryRelation.new
              @user_category_relationss.update_attributes(:master_category_id => params[:master_category_id],:is_active => "1" , :user_id => params[:user_id], :user_category_id => @user_category_create.id, :friend_user_id => params[:user_id])
              @user_category_relationss.save
             end
        if @email_list.present?
           @email_list.each do |email_list|
             PostMailer.post_mailers(email_list).deliver
           end
        end
        if !(params[:receiver_id]).blank?
            message
        end
        if !(params[:group_id]).blank?
            group_message
        end
        enti = en.merge(:artist => params[:artist],:caputredDeviceOrientation => @user_entity_create.caputredDeviceOrientation,:user_id =>@user_entity_create.user_id, :user_category_id => @user_entity_create.id,:entity_name => @user_entity_create.entity_name,:address => @user_entity_create.entity_name,:lat => @user_entity_create.lat, :longitude => @user_entity_create.longitude,:sub_category => @user_entity_create.sub_category,:entity_image => @entity_image,:entity_image_url => @user_entity_create.entity_image, :is_active => params[:is_active],:comment => @user_entity_create.comment,:rating_count => @user_entity_create.rating_count,:is_public => "1")
        @entitys << enti
        format.json {render :json => @entitys}
       end
         format.json {render :json => @cat}
      end
   end
  end
 end
 
def group_message
    if !@post_create.nil?
      @sv = @post_create.id
    elsif !@api_entity_create.nil?
      @sv = @api_entity_create.id
    elsif !@user_entities_create.nil?
      @sv = @user_entities_create.id
    elsif !@user_entity_create.nil?
      @sv = @user_entity_create.id
    elsif !@posts.nil?
      @sv = @posts.id
    elsif !@entities.nil?
      @sv = @entities.id
    end
  @read_state = Array.new
  @groups_member = Array.new
  group_ids = (params[:group_id]).split(",")
  group_ids.each do |group_member|
    @groups = GroupMembers.where(:group_id => group_member)
    @groups.each do |group|
      @groups_member << group.member_user_id
    end
  end
  gm = @groups_member.uniq
  @message_s = Message.last
  if @message_s.present?
     rand_num = @message_s.thread_id.to_i
     ch = rand_num += 1
  else
     ch = 1
  end
  @users = User.where(:id => params[:user_id]).first
  @message = Message.new
  @message.update_attributes(:sender_id => params[:user_id],:message_body => "Hi #{@users.first_name} #{@users.last_name} share Entity Image", :is_active => "1", :thread_id => ch, :user_entity_id => @sv)
  @read_state << @message.sender_id
  gm.each do |receive_user|
    @read_state << receive_user
  end
  if @message.save
     @read_state.each do |read|
        @thread_participant = ThreadParticipant.new
        @thread_participant.update_attributes(:sender_id => @message.sender_id, :thread_id => @message.thread_id, :user_id => read, :is_new => "1")
        @thread_participant.save
        @message_read_state = MessageReadState.new
        if (read == @message.sender_id)
            @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "1" )
        else
            @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "0" )
        end
     end
  else
  end
 end

  def message
    if !@post_create.nil?
      @sv = @post_create.id
    elsif !@api_entity_create.nil?
      @sv = @api_entity_create.id
    elsif !@user_entities_create.nil?
      @sv = @user_entities_create.id
    elsif !@user_entity_create.nil?
      @sv = @user_entity_create.id
    elsif !@posts.nil?
      @sv = @posts.id
    elsif !@entities.nil?
      @sv = @entities.id
    end
    @read_state = Array.new
      @message_s = Message.last
      if @message_s.present?
        rand_num = @message_s.thread_id.to_i
        ch = rand_num += 1
      else
        ch = 1
      end
      @users = User.where(:id => params[:user_id]).first
      @recivers = (params[:receiver_id]).split(",")
      @recivers.each do |re|
         @message = Message.new
         @message.update_attributes(:sender_id =>re,:message_body => "Hi #{@users.first_name} #{@users.last_name} share Entity Image", :is_active => "1", :thread_id => ch, :user_entity_id => @sv)
         @read_state << @message.sender_id
      end
      @read_state << params[:user_id]
      if @message.save
         @read_state.each do |read|
            @thread_participant = ThreadParticipant.new
            @thread_participant.update_attributes(:sender_id => @message.sender_id, :thread_id => @message.thread_id, :user_id => read, :is_new => "1")
            @thread_participant.save
            @message_read_state = MessageReadState.new
            if (read == @message.sender_id)
               @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "1" )
            else
               @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "0" )
            end
         end
      else
      end
  end

  def suggested_entity
      @cat = {}
      @cati = Array.new
      location = Array.new
      @user_category_check = UserCategory.where(:user_id => params[:user_id], :master_category_id => params[:master_category_id]).first
      respond_to do |format|
        if @user_category_check.present?
           @user_entity_suggested = UserEntity.create
           if params[:entity_image]
              entity_image_suggested = (params[:entity_image]).gsub(" ", "+")
              @entity_image_suggested = StringIO.new(Base64.decode64(entity_image_suggested))
              @entity_image_suggested.class.class_eval { attr_accessor :original_filename, :content_type }
              @entity_image_suggested.original_filename = "entity_image.jpg"
              @entity_image_suggested.content_type = "image/jpg"
             # @user_entity_suggested.entity_image = @entity_image_suggested
           end
           location << params[:lat].to_f
           location << params[:latitude].to_f
           @user_entity_suggested.update_attributes(:artist => params[:artist],:coordinates => Geocoder.coordinates(params[:address]),:city => params[:city],:information => params[:information],:user_id => params[:user_id], :user_category_id => @user_category_check.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => params[:sub_category],:is_active => "1",:comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1", :entity_image => @entity_image_suggested, :loc => location)
           @user_entity_suggested.save
           cl = @cat.merge(:artist => @user_entity_suggested.artist,:entity_image =>@user_entity_suggested.entity_image ,:master_category_id => params[:master_category_id],:information =>@user_entity_suggested.information,:user_id => params[:user_id], :user_category_id => @user_category_check.id,:entity_name => @user_entity_suggested.entity_name,:address => @user_entity_suggested.address,:lat => @user_entity_suggested.lat, :longitude => @user_entity_suggested.longitude,:sub_category => params[:sub_category], :is_active => "1",:comment => @user_entity_suggested.comment,:rating_count => @user_entity_suggested.rating_count,:is_public => "1")
           @cati << cl
           format.json {render :json => @cati }
        else
           sugg= {}
           @sugg = Array.new
           @user_category = UserCategory.create
           @user_category.update_attributes(:user_id => params[:user_id],:master_category_id => params[:master_category_id], :is_active => "1")
           if @user_category.save
              @user_entity_suggested = UserEntity.create
              if params[:entity_image]
                 entity_image_suggested = (params[:entity_image]).gsub(" ", "+")
                 @entity_image_suggested = StringIO.new(Base64.decode64(entity_image_suggested))
                 @entity_image_suggested.class.class_eval { attr_accessor :original_filename, :content_type }
                 @entity_image_suggested.original_filename = "entity_image.jpg"
                 @entity_image_suggested.content_type = "image/jpg"
              end
              location << params[:lat].to_f
              location << params[:latitude].to_f
              @user_entity_suggested.update_attributes(:artist => params[:artist],:def => params[:def],:coordinates => Geocoder.coordinates(params[:address]),:city => params[:city],:entity_image_url => @user_entity_suggested.entity_image,:information => params[:information],:user_id => params[:user_id], :user_category_id => @user_category.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => params[:sub_category],:entity_image => @entity_image_suggested, :is_active => "1",:comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1", :loc => location)
              @user_entity_suggested.save
              su = sugg.merge(:artist => @user_entity_suggested.artist,:user_id => @user_category.user_id, :user_category_id => @user_category.id, :entity_image => @user_entity_suggested.entity_image,:entity_name => @user_entity_suggested.entity_name,:longitude => @user_entity_suggested.longitude, :lat => @user_entity_suggested.lat, :address => @user_entity_suggested.address, :rating_count =>@user_entity_suggested.rating_count, :comment => @user_entity_suggested.comment,:information => @user_entity_suggested.information)
              @sugg << su
            format.json {render :json => @sugg}
          end
      end
     end
 end

  def entity_list
    @entity_list = UserEntity.where(:user_id => params[:entity][:user_id]).first
    respond_to do |format|
      format.json {render :json => @entity_list}
    end
  end


 def get_entity_by_category_id
   @entity = Array.new
   entity = {}
   @rating = Array.new
   @ratingss = Array.new
   @user_categ = UserCategory.where(:user_id => params[:user_id],:master_category_id => params[:master_category_id]).order_by(:created_at => "desc")#
   if @user_categ.present?
         @user_categ.each do |cat|
           @user_cate = UserCategory.where(:master_category_id => params[:master_category_id]).excludes(:id => cat.id)
           @user_cate.each do |categ|
             @get_entity = UserEntity.where(:user_category_id =>categ.id, :is_active => "true").paginate(:page => params[:page], :per_page => 10)###.all#.uniq {|p|  p.id && p.entity_name}
     @get_entity.each do |entities|
        ent_id = entities.id
        @ratings = Rating.where(:user_entity_id => ent_id.to_s).uniq {|p|  p.id}
        if @ratings.present?
           @ratings.each do |rat|
             @rating << rat.rating_count
           end
           cd = (entities.rating_count).to_i
           @rating << cd
           total = 0
           average = 0
           @rating.each do |item|
              total += item
           end
           average = total / @rating.length
        else
           if entities.rating_count == "0"
              average = "0"
           else
              @rating << (entities.rating_count).to_i
              total = 0
              average = 0
              @rating.each do |item|
                 total += item
              end
             average = total / @rating.length
          end
       end
      @user = User.where(:id => entities.user_id)
      @user.each do |user|
        en = entity.merge(:artist => entities.artist,:master_category_id=>params[:master_category_id],:user_category_id => entities.user_category_id, :entity_name=> entities.entity_name, :address => entities.address,:entity_id => entities.id,:entity_image => entities.entity_image, :user_id => entities.user_id, :user_name => user.first_name, :user_profile_picture => user.profile_picture, :rating_count => average )
        @entity << en
      end
     end
           end
     
    end

   else
@user_categ = UserCategory.where(:master_category_id => params[:master_category_id]).order_by(:created_at => "desc").paginate(:page => params[:page], :per_page => 12)
        @user_categ.each do |cat|

     @get_entity = UserEntity.where(:user_category_id => cat.id, :is_active => "true").uniq {|p|  p.id && p.entity_name}
     @get_entity.each do |entities|
        ent_id = entities.id
        @ratings = Rating.where(:user_entity_id => ent_id.to_s).uniq {|p|  p.id}
        if @ratings.present?
           @ratings.each do |rat|
             @rating << rat.rating_count
           end
           cd = (entities.rating_count).to_i
           @rating << cd
           total = 0
           average = 0
           @rating.each do |item|
              total += item
           end
           average = total / @rating.length
        else
           if entities.rating_count == "0"
              average = "0"
           else
              @rating << (entities.rating_count).to_i
              total = 0
              average = 0
              @rating.each do |item|
                 total += item
              end
             average = total / @rating.length
          end
       end
      @user = User.where(:id => entities.user_id)
      @user.each do |user|
        en = entity.merge(:artist => entities.artist,:master_category_id=>params[:master_category_id],:user_category_id => entities.user_category_id, :entity_name=> entities.entity_name, :address => entities.address,:entity_id => entities.id,:entity_image => entities.entity_image, :user_id => entities.user_id, :user_name => user.first_name, :user_profile_picture => user.profile_picture, :rating_count => average )
        @entity << en
      end
     end
    end
   end

   arrays = @entity.sort{|a,b| [a[:user_entity_id]] <=> [b[:user_entity_id]]} && @entity.sort_by { |k| k["created_at"]}
   respond_to do |format|
     if arrays.empty?
       format.json {render :json =>{:message => "This category does't have any entity"}}
     else
       format.json {render :json => arrays}
     end
   end
end


#  def entity_info
#    @rating = Array.new
#    @comments = Array.new
#    coome = {}
#    en_po = {}
#    #average = 0
#    @en_po = Array.new
#    user_entity = {}
#     @entity_info = Array.new
#     @entity_user =  UserEntity.where(:id => params[:user_entity_id], :user_id => params[:user_id]).first
#     ue = @entity_user.id
#     @categories = UserCategory.where(:id => @entity_user.user_category_id).first
#     @categ = MasterCategory.where(:id =>@categories.master_category_id).first
#     @entity_users = User.where(:id => @entity_user.user_id).first
#     @comment = Comment.where(:user_entity_id => @entity_user.id ).limit(2).order_by(:created_at => "desc")
#     @comment.each do |comm|
#       cd1 =  Comment.comment_text(comm.comment_text, params[:user_id],comm.user_entity_id)
#       cd2 = cd1.join(" ")
#       coomes = coome.merge(:comment_text => cd2,:created_time => comm.created_at)
#       @ratingss = Rating.where(:comment_id => comm.id)
#       @ratingss.each do |coom|
#         coomes = coomes.merge( :comment_rating => coom.rating_count)
#       end
#       @user = User.where(:id => comm.self_user_id)
#      @user.each do |user|
#        coomes = coomes.merge(:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url, :comment_count => @comment.count)
#        @comments << coomes
#      end
#       end
#       @ratings = Rating.where(:user_entity_id =>  ue.to_s )
#       if @ratings.present?
#           @ratings.each do |rat|
#             @rating << rat.rating_count
#           end
#          cd = (@entity_user.rating_count).to_i
#          @rating << cd
#          total = 0
#
#        @rating.each do |item|
#           total += item
#        end
#        average = total / @rating.length
#      else
#        if @entity_user.rating_count == "0"
#          average = "0"
#        else
#          @rating << (@entity_user.rating_count).to_i
#          total = 0
#          average = 0
#          @rating.each do |item|
#           total += item
#        end
#        average = total / @rating.length
#        end
#
#     end
#     if @entity_user.comment.nil?
#       ch = user_entity.merge(:caputredDeviceOrientation => @entity_user.caputredDeviceOrientation,:api_id => @entity_user.api_id,:ycody => @entity_user.ycody,:xcody => @entity_user.xcody,:def => @entity_user.def,  :city => @entity_user.city,:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name=> @entity_users.first_name,:comment_text => @entity_user.comment, :user_entity_id => @entity_user.id, :user_id => @entity_user.user_id,:user_entity_name => @entity_user.entity_name,:user_entity_image => @entity_user.entity_image,:latitute => @entity_user.lat, :longitude => @entity_user.longitude, :information => @entity_user.information, :address => @entity_user.address, :comment =>@comments, :rating_count => average)
#     else
#       cd4 =  Comment.comment_text(@entity_user.comment, params[:user_id],@entity_user.id)
#       cd5 = cd4.join(" ")
#       ch = user_entity.merge(:caputredDeviceOrientation => @entity_user.caputredDeviceOrientation,:api_id => @entity_user.api_id,:ycody => @entity_user.ycody,:xcody => @entity_user.xcody,:def => @entity_user.def,  :city => @entity_user.city,:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name=> @entity_users.first_name,:comment_text => cd5, :user_entity_id => @entity_user.id, :user_id => @entity_user.user_id,:user_entity_name => @entity_user.entity_name,:user_entity_image => @entity_user.entity_image,:latitute => @entity_user.lat, :longitude => @entity_user.longitude, :information => @entity_user.information, :address => @entity_user.address, :comment =>@comments, :rating_count => average)
#     end
#
#   @entity_info << ch
#   post_info = {}
#   @post_info = Array.new
#   @entity_post = Post.where(:user_entity_id => @entity_user.id, :is_active => "true")
#   @entity_post.each do |post|
#     @comments_post = Comment.where(:post_id => post.id).limit(2).order_by(:created_at => "desc")
#
#      @comments_post.each do |post_comments|
#        cd1 =  Comment.comment_text(post_comments.comment_text, params[:user_id],post_comments.user_entity_id)
#        cd2 = cd1.join(" ")
#        post_info_comment = post_info.merge(:post_id => post_comments.post_id ,:comment_text => cd2, :created_time => post_comments.created_at,:comment_count => @comments_post.count)
#         @rating_post = Rating.where(:comment_id => post_comments.id)
#         @rating_post.each do |rat_post|
#            post_info_comment = post_info_comment.merge(:rating_count => rat_post.rating_count)
#         end
#         @comment_user = User.where(:id =>post_comments.self_user_id )
#         @comment_user.each do |user|
#            post_info_comment = post_info_comment.merge(:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url)
#         @post_info << post_info_comment
#         end
#      end
#      cd1 =  Comment.comment_text(post.comment_text, params[:user_id],post.user_entity_id)
#        cd2 = cd1.join(" ")
#      post_en = en_po.merge(:caputredDeviceOrientation => post.caputredDeviceOrientation,:ycody => post.ycody,:xcody => post.xcody,:def => @entity_user.def,:comment_text => cd2,:post_id => post.id ,:user_entity_id => post.user_entity_id, :user_id => post.user_id,:user_entity_name => @entity_user.entity_name,:post_image => post.post_image_url,:latitute => post.lat, :longitude => post.longitude, :address => @entity_user.address, :rating_count => post.rating_count.to_s)#, :comment => @post_info)
#      @en_po << post_en
#     end
#      respond_to do |format|
#        format.json {render :json=> {:entity_info => @entity_info , :post_info => @en_po, :commentss => @post_info}}
#      end
# end



 def entity_info
      @relas = Array.new
    @rating = Array.new
    @detai = Array.new
    @comments =  Array.new
    @posst_info =  Array.new
    detai = {}
    @post_idd = Array.new
     @post_info = Array.new
    post_infos = {}
    post_en = {}
    @post_other = Array.new
    @post_id = Array.new
    post_info = {}
    en_po = {}
    @en_po =  Array.new
    @enq_po =  Array.new
    coome = {}
    @post = Array.new
    @entity_detailss = UserCategoryRelation.where(:user_id => params[:user_id], :is_active => "true")
    @entity_detailss.each do |rela|
      @relas << rela.friend_user_id
    end
    respond_to do |format|
      if @entity_detailss.present?
      @relas.push(params[:user_id])
      if !(params[:api_id]).nil?
    @user_enti = UserEntity.in(:user_id => @relas).where(:api_id => params[:api_id]).last#.order_by(:created_at => "desc")
    @categories = UserCategory.where(:id => @user_enti.user_category_id).first
    @categ = MasterCategory.where(:id =>@categories.master_category_id).first
    @users = User.where(:id => @user_enti.user_id).first
    @comment = Comment.where(:user_entity_id => @user_enti.id ).order_by(:created_at => "desc")
    @comment.each do |comm|
      start_time =  comm.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
       cd1 =  Comment.comment_text(comm.comment_text, @user_enti.user_id,comm.user_entity_id)
       cd2 = cd1.join(" ")
       coomes = coome.merge(:comment_text => cd2,:created_time => comm.created_at)
       @ratingss = Rating.where(:comment_id => comm.id)
       @ratingss.each do |coom|
         coomes = coomes.merge( :rating_count => coom.rating_count)
       end
       @user = User.where(:id => comm.self_user_id)
       @user.each do |user|
         coomes = coomes.merge(:time => @times,:other_user => "No",:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url, :comment_count => @comment.count)
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
     start_time =  @user_enti.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
   @post_entityy = Post.where(:api_id => @user_enti.api_id , :user_id => @user_enti.user_id,:is_public => "true").last

    if @user_enti.comment.nil?
      ent = detai.merge(:sub_category => @user_enti.sub_category,:comment_count => @comment.count,:artist =>@user_enti.artist ,:comment => @comments,:time => @times, :other_user => "No",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_enti.api_id,:ycody => @user_enti.ycody,:xcody => @user_enti.xcody,:def => @user_enti.def,  :city => @user_enti.city,:comment_text => @user_enti.comment, :user_entity_id => @user_enti.id, :user_id => @user_enti.user_id,:user_entity_name => @user_enti.entity_name,:user_entity_image => @user_enti.entity_image,:latitute => @user_enti.lat, :longitude => @user_enti.longitude, :information => @user_enti.information, :address => @user_enti.address, :rating_count => average.to_s)
    else
       cd4 =  Comment.comment_text(@user_enti.comment, @user_enti.user_id,@user_enti.id)
       cd5 = cd4.join(" ")
       ent = detai.merge(:sub_category => @user_enti.sub_category,:comment_count => @comment.count,:artist =>@user_enti.artist ,:comment => @comments,:time => @times,:other_user => "No",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_enti.api_id,:ycody => @user_enti.ycody,:xcody => @user_enti.xcody,:def => @user_enti.def,  :city => @user_enti.city,:comment_text => cd5, :user_entity_id => @user_enti.id, :user_id => @user_enti.user_id,:user_entity_name => @user_enti.entity_name,:user_entity_image => @user_enti.entity_image,:latitute => @user_enti.lat, :longitude => @user_enti.longitude, :information => @user_enti.information, :address => @user_enti.address, :rating_count => average.to_s)
    end
@detai << ent

 

   @entity_post = Post.in(:user_id => @relas).where(:api_id => params[:api_id], :is_active => "true").order_by(:created_at => "desc")
   @entity_post.each do |post|
    @comments_post = Comment.where(:post_id => post.id).order_by(:created_at => "desc")
@post_id << post.id
      cd1 =  Comment.comment_text(post.comment_text, post.user_id,post.user_entity_id)
        cd2 = cd1.join(" ")
      post_en = post_en.merge(:sub_category => @user_enti.sub_category,:artist =>@user_enti.artist ,:other_user => "No",:ycody => post.ycody,:xcody => post.xcody,:def => @user_enti.def,:comment_text => cd2,:post_id => post.id ,:user_entity_id => post.user_entity_id, :user_id => post.user_id,:user_entity_name => @user_enti.entity_name,:post_image => post.post_image_url,:latitute => post.lat, :longitude => post.longitude, :address => @user_enti.address, :rating_count => average.to_s,:comment_count => @comments_post.count)
      @en_po << post_en
     end
     @post_id.uniq
     @post_id.each do |post_id|
      @comments_postss = Comment.where(:post_id => post_id).order_by(:created_at => "desc")

      @comments_postss.each do |post_comments|
         start_time =  post_comments.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
        cd1 =  Comment.comment_text(post_comments.comment_text, post_comments.user_id,post_comments.user_entity_id)
        cd2 = cd1.join(" ")
        post_info_comment = post_info.merge(:post_id => post_comments.post_id ,:comment_text => cd2, :created_time => post_comments.created_at,:comment_count => @comments_postss.count)
         @rating_post = Rating.where(:comment_id => post_comments.id)
         @rating_post.each do |rat_post|
            post_info_comment = post_info_comment.merge(:rating_count => rat_post.rating_count)
         end
         @comment_user = User.where(:id =>post_comments.self_user_id )
         @comment_user.each do |user|
            post_info_comment = post_info_comment.merge(:comment_count => @comments_postss.count,:time => @times,:other_user => "No",:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url)
         @post_info << post_info_comment
         end
      end
     end
      @postss =  Post.where(:api_id => params[:api_id],:is_active => "true")
    @postss.each do |post_other|
      @post_other << post_other.id
    end

   @poste =  @post_other -  @post_id
        @other_postss =  Post.in(:id => @poste).where(:is_active => "true")
    @other_postss.each do |post|
      start_time =  post.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
      @conne = Comment.where(:post_id => post.id)

    @post_idd << post.id
      cd1 =  Comment.comment_text(post.comment_text, post.user_id,post.user_entity_id)
        cd2 = cd1.join(" ")
      post_en = en_po.merge(:sub_category => @user_enti.sub_category,:artist =>@user_enti.artist ,:time => @times,:other_user => "Yes",:ycody => post.ycody,:xcody => post.xcody,:def => @user_enti.def,:comment_text => cd2,:post_id => post.id ,:user_entity_id => post.user_entity_id, :user_id => post.user_id,:user_entity_name => @user_enti.entity_name,:post_image => post.post_image_url,:latitute => post.lat, :longitude => post.longitude, :address => @user_enti.address, :rating_count => average.to_s, :comment_count => @conne.count)
      @enq_po << post_en
     end
     @post_idd.uniq
     @post_idd.each do |post_idd|
      @comments_postp = Comment.where(:post_id =>post_idd).order_by(:created_at => "desc")
      @comments_postp.each do |post_comments|
        start_time =  post_comments.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
        cd1 =  Comment.comment_text(post_comments.comment_text, post_comments.user_id,post_comments.user_entity_id)
        cd2 = cd1.join(" ")
        post_info_comment = post_infos.merge(:time => @times,:post_id => post_comments.post_id ,:comment_text => cd2, :created_time => post_comments.created_at)
         @rating_post = Rating.where(:comment_id => post_comments.id)
         @rating_post.each do |rat_post|
            post_info_comment = post_info_comment.merge(:rating_count => rat_post.rating_count)
         end
         @comment_user = User.where(:id =>post_comments.self_user_id )
         @comment_user.each do |user|
            post_info_comment = post_info_comment.merge(:other_user => "Yes",:comment_count => @comments_postp.count,:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url)
         @post_info << post_info_comment
         end
      end
     end
   else
     @user_entis = UserEntity.where(:id => params[:user_entity_id]).first#.order_by(:created_at => "desc")
    @categories = UserCategory.where(:id => @user_entis.user_category_id).first
    @categ = MasterCategory.where(:id =>@categories.master_category_id).first
    @users = User.where(:id => @user_entis.user_id).first
    @comment = Comment.where(:user_entity_id => @user_entis.id ).order_by(:created_at => "desc")
    @comment.each do |comm|
      start_time =  comm.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
       cd1 =  Comment.comment_text(comm.comment_text, @user_entis.user_id,comm.user_entity_id)
       cd2 = cd1.join(" ")
       coomes = coome.merge(:comment_text => cd2,:created_time => comm.created_at)
       @ratingss = Rating.where(:comment_id => comm.id)
       @ratingss.each do |coom|
         coomes = coomes.merge( :rating_count => coom.rating_count)
       end
       @user = User.where(:id => comm.self_user_id)
       @user.each do |user|
         coomes = coomes.merge(:time => @times,:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url, :comment_count => @comment.count)
         @comments << coomes
       end
   end
    if @user_entis.rating_count.nil?
       @ratings = Rating.where(:user_entity_id => @user_entis.id )
       if @ratings.present?
           @ratings.each do |rat|
             @rating << rat.rating_count
           end
           cd = (@user_entis.rating_count).to_i
           @rating << cd
           total = 0
           @rating.each do |item|
             total += item
           end
           average = total / @rating.length
        else
           if @user_entis.rating_count == "0"
              average = "0"
           else
               @rating << (@user_entis.rating_count).to_i
               total = 0
               average = 0
               @rating.each do |item|
                  total += item
               end
               average = total / @rating.length
           end

        end
      else
           average = @user_entis.rating_count
    end
     start_time =  @user_entis.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
    if @user_entis.comment.nil?
      ent = detai.merge(:comment_count => @comments.count,:sub_category => @user_entis.sub_category,:artist =>@user_entis.artist ,:time => @times,:other_user => "No",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_entis.api_id,:ycody => @user_entis.ycody,:xcody => @user_entis.xcody,:def => @user_entis.def,  :city => @user_entis.city,:comment_text => @user_entis.comment, :user_entity_id => @user_entis.id, :user_id => @user_entis.user_id,:user_entity_name => @user_entis.entity_name,:user_entity_image => @user_entis.entity_image,:latitute => @user_entis.lat, :longitude => @user_entis.longitude, :information => @user_entis.information, :address => @user_entis.address, :comment => @comments, :rating_count => average.to_s)
    else
       cd4 =  Comment.comment_text(@user_entis.comment, @user_entis.user_id,@user_entis.id)
       cd5 = cd4.join(" ")
       ent = detai.merge(:comment_count => @comments.count,:sub_category => @user_entis.sub_category,:artist =>@user_entis.artist ,:time => @times,:other_user => "No",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_entis.api_id,:ycody => @user_entis.ycody,:xcody => @user_entis.xcody,:def => @user_entis.def,  :city => @user_entis.city,:comment_text => cd5, :user_entity_id => @user_entis.id, :user_id => @user_entis.user_id,:user_entity_name => @user_entis.entity_name,:user_entity_image => @user_entis.entity_image,:latitute => @user_entis.lat, :longitude => @user_entis.longitude, :information => @user_entis.information, :address => @user_entis.address, :comment => @comments, :rating_count => average.to_s)
    end
    @detai << ent
    end
   
      @en_po.sort_by! { |thing| thing["created_at"] }
    @results = Kaminari.paginate_array(@en_po).page(params[:page]).per(10)
    format.json {render :json=> {:entity_info => @detai, :post_info => (@results+ @enq_po), :commentss => @post_info}   }
    else
    if !(params[:api_id]).nil?
    @user_enti = UserEntity.where(:api_id => params[:api_id]).last#.order_by(:created_at => "desc")
    @categories = UserCategory.where(:id => @user_enti.user_category_id).first
    @categ = MasterCategory.where(:id =>@categories.master_category_id).first
    @users = User.where(:id => @user_enti.user_id).first
    @comment = Comment.where(:user_entity_id => @user_enti.id ).ordedr_by(:created_at => "desc")
    @comment.each do |comm|
      start_time =  comm.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
       cd1 =  Comment.comment_text(comm.comment_text, @user_enti.user_id,comm.user_entity_id)
       cd2 = cd1.join(" ")
       coomes = coome.merge(:time => @times,:comment_text => cd2,:created_time => comm.created_at)
       @ratingss = Rating.where(:comment_id => comm.id)
       @ratingss.each do |coom|
         coomes = coomes.merge( :rating_count => coom.rating_count)
       end
       @user = User.where(:id => comm.self_user_id)
       @user.each do |user|
         coomes = coomes.merge(:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url, :comment_count => @comment.count)
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
    start_time =  @user_enti.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
    if @user_enti.comment.nil?
      ent = detai.merge(:comment_count => @comments.count,:sub_category => @user_enti.sub_category,:artist =>@user_enti.artist ,:time => @times,:other_user => "Yes",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_enti.api_id,:ycody => @user_enti.ycody,:xcody => @user_enti.xcody,:def => @user_enti.def,  :city => @user_enti.city,:comment_text => @user_enti.comment, :user_entity_id => @user_enti.id, :user_id => @user_enti.user_id,:user_entity_name => @user_enti.entity_name,:user_entity_image => @user_enti.entity_image,:latitute => @user_enti.lat, :longitude => @user_enti.longitude, :information => @user_enti.information, :address => @user_enti.address, :rating_count => average.to_s,  :comment =>@comments)
    else
       cd4 =  Comment.comment_text(@user_enti.comment, @user_enti.user_id,@user_enti.id)
       cd5 = cd4.join(" ")
       ent = detai.merge(:comment_count => @comments.count,:sub_category => @user_enti.sub_category,:artist =>@user_enti.artist ,:time => @times,:other_user => "Yes",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_enti.api_id,:ycody => @user_enti.ycody,:xcody => @user_enti.xcody,:def => @user_enti.def,  :city => @user_enti.city,:comment_text => cd5, :user_entity_id => @user_enti.id, :user_id => @user_enti.user_id,:user_entity_name => @user_enti.entity_name,:user_entity_image => @user_enti.entity_image,:latitute => @user_enti.lat, :longitude => @user_enti.longitude, :information => @user_enti.information, :address => @user_enti.address, :comment =>@comments, :rating_count => average.to_s)
    end
    @detai << ent

 @post_info = Array.new
   @entity_post = Post.where(:api_id => params[:api_id], :is_public => "true").order_by(:created_at => "desc")
   @entity_post.each do |post|
     @post_id << post.id
      start_time =  post.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
     @commentttt = Comment.where(:post_id => post.id)
      cd1 =  Comment.comment_text(post.comment_text, post.user_id,post.user_entity_id)
        cd2 = cd1.join(" ")
      post_en = en_po.merge(:sub_category => @user_enti.sub_category,:artist =>@user_enti.artist ,:time => @time,:other_user => "Yes",:ycody => post.ycody,:xcody => post.xcody,:def => @user_enti.def,:comment_text => cd2,:post_id => post.id ,:user_entity_id => post.user_entity_id, :user_id => post.user_id,:user_entity_name => @user_enti.entity_name,:post_image => post.post_image_url,:latitute => post.lat, :longitude => post.longitude, :address => @user_enti.address, :rating_count => average.to_s, :comment_count => @commentttt.count)
      @en_po << post_en
     end
     @post_id.uniq
     @post_id.each do |post_id|
     @comments_possst = Comment.where(:post_id => post_id ).order_by(:created_at => "desc")

      @comments_possst.each do |post_comments|
         start_time =  post_comments.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
        cd1 =  Comment.comment_text(post_comments.comment_text, post_comments.user_id,post_comments.user_entity_id)
        cd2 = cd1.join(" ")
        post_info_comment = post_info.merge(:time => @time,:post_id => post_comments.post_id ,:comment_text => cd2, :created_time => post_comments.created_at)
         @rating_post = Rating.where(:comment_id => post_comments.id)
         @rating_post.each do |rat_post|
            post_info_comment = post_info_comment.merge(:rating_count => rat_post.rating_count)
         end
         @comment_user = User.where(:id =>post_comments.self_user_id )
         @comment_user.each do |user|
            post_info_comment = post_info_comment.merge(:other_user => "Yes",:comment_count => @comments_possst.count,:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url)
         @post_info << post_info_comment
         end
      end
     end
   else
     @user_enti = UserEntity.where(:id => params[:user_entity_id]).first
    @categories = UserCategory.where(:id => @user_enti.user_category_id).first
    @categ = MasterCategory.where(:id =>@categories.master_category_id).first
    @users = User.where(:id => @user_enti.user_id).first
    @comment = Comment.where(:user_entity_id => @user_enti.id ).order_by(:created_at => "desc")
    @comment.each do |comm|
       start_time =  comm.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
       cd1 =  Comment.comment_text(comm.comment_text, @user_enti.user_id,comm.user_entity_id)
       cd2 = cd1.join(" ")
       coomes = coome.merge(:time => @time,:comment_text => cd2,:created_time => comm.created_at)
       @ratingss = Rating.where(:comment_id => comm.id)
       @ratingss.each do |coom|
         coomes = coomes.merge( :rating_count => coom.rating_count)
       end
       @user = User.where(:id => comm.self_user_id)
       @user.each do |user|
         coomes = coomes.merge(:user_id => user.id, :user_name => user.first_name,:profile_picture => user.profile_picture_url, :comment_count => @comment.count)
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
    start_time =  @user_enti.created_at
          end_time   =  Time.now
   @times =  distance_of_time_in_words(start_time, end_time)
    if @user_enti.comment.nil?
      ent = detai.merge(:comment_count => @comments.count,:sub_category => @user_enti.sub_category,:artist =>@user_enti.artist ,:time => @time,:other_user => "Yes",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_enti.api_id,:ycody => @user_enti.ycody,:xcody => @user_enti.xcody,:def => @user_enti.def,  :city => @user_enti.city,:comment_text => @user_enti.comment, :user_entity_id => @user_enti.id, :user_id => @user_enti.user_id,:user_entity_name => @user_enti.entity_name,:user_entity_image => @user_enti.entity_image,:latitute => @user_enti.lat, :longitude => @user_enti.longitude, :information => @user_enti.information, :address => @user_enti.address, :comment => @comments, :rating_count => average.to_s)
    else
       cd4 =  Comment.comment_text(@user_enti.comment, @user_enti.user_id,@user_enti.id)
       cd5 = cd4.join(" ")
       ent = detai.merge(:comment_count => @comments.count,:sub_category => @user_enti.sub_category,:artist =>@user_enti.artist ,:time => @time,:other_user => "Yes",:master_category_name => @categ.category_name, :master_category_id =>@categ.id,:user_name => @users.first_name, :api_id => @user_enti.api_id,:ycody => @user_enti.ycody,:xcody => @user_enti.xcody,:def => @user_enti.def,  :city => @user_enti.city,:comment_text => cd5, :user_entity_id => @user_enti.id, :user_id => @user_enti.user_id,:user_entity_name => @user_enti.entity_name,:user_entity_image => @user_enti.entity_image,:latitute => @user_enti.lat, :longitude => @user_enti.longitude, :information => @user_enti.information, :address => @user_enti.address, :comment => @comments, :rating_count => average.to_s)
    end
    @detai << ent
    end
    @en_po.sort_by! { |thing| thing["created_at"] }
    @results = Kaminari.paginate_array(@en_po).page(params[:page]).per(20)
        format.json {render :json=> {:entity_info => @detai, :post_info => @results, :commentss => @post_info}   }

    end

    end
 end


 def entity_search_sign_up
   @entity = Array.new
    entity = {}
   @user_categ = UserCategory.where(:master_category_id => params[:master_category_id])
   @user_categ.each do |cat|
   @get_entity = UserEntity.where(:user_category_id => cat.id, :entity_name => /.*#{params[:entity][:char]}*./i).uniq {|p| p.entity_name}
   @get_entity.each do |entities|
     @user = User.where(:id => entities.user_id)
     @user.each do |user|
       en = entity.merge(:master_category_id=>params[:master_category_id],:user_category_id => entities.user_category_id, :entity_name=> entities.entity_name, :address => entities.address,:entity_id => entities.id,:entity_image => entities.entity_image, :user_id => entities.user_id, :user_name => user.first_name, :user_profile_picture => user.profile_picture, :rating_count => entities.rating_count )
   @entity << en
   end
   end
   end
   respond_to do |format|
     if @entity.empty?
       format.json {render :json =>{:message => "This category does't have any entity"}}
     else
       format.json {render :json => @entity}
     end
   end
end

# curl -X POST -d "entity[char]=&master_category_id=" http://localhost:3000/user_entity/entity_search_sign_up.json

 def entity_search
   @entity_search = Array.new
   entity_search = {}
  @entity = UserEntity.where(:entity_name => /.*#{params[:entity][:char]}*./).all
  @entity.each do |entity|
    @user_entity = User.where(:id => entity.user_id)
    @user_entity.each do |users|
      es = entity_search.merge(:user_entity_id => entity.id ,:user_id => users.id, :profile_picture => users.profile_picture_url, :first_name => users.first_name,:address => entity.address, :comment => entity.comment, :entity_image => entity.entity_image, :entity_name => entity.entity_name,  :rating_count => entity.rating_count, :sub_category => entity.sub_category, :lat => entity.lat , :longitude => entity.longitude, :user_category_id =>  entity.user_category_id)
      @entity_search << es
    end
  end
    respond_to do |format|
      if @entity.present?
        format.json {render :json => @entity_search}
      else
      end
  end
end

 def repost
   @posts = UserEntity.new
   respond_to do |format|
   if params[:post] == "1"
     @post = Post.where(:id => params[:post_id]).first
     @posts.update_attributes(:ycody => params[:ycody],:xcody => params[:xcody],:entity_name => params[:entity_name],:entity_image_url => @post.post_image_url, :user_id => params[:user_id], :lat => params[:lat],:address => params[:address], :longitude => params[:longitude], :is_public => "1",:is_active => "1",:sub_category => params[:sub_category],:comment => params[:comment],:rating_count => params[:rating_count])
     if @posts.save
       if @email_list.present?
        @email_list.each do |email_list|
          PostMailer.post_mailers(email_list).deliver
        end
      end
      if !(params[:receiver_id]).nil?
        message
      end
      if !(params[:group_id]).nil?
        group_message
      end
       format.json {render :json => {:message => "Add Entity Sucessfully"}}
     else
       format.json {render :json => {:errors => "Some error during post"}}
     end
   else
     @entities = UserEntity.new
     @entity = UserEntity.where(:id => params[:user_entity_id]).first
     @entities.update_attributes(:ycody => params[:ycody],:xcody => params[:xcody],:city => @entity.city,:entity_image_url => @entity.entity_image,:information => params[:information],:user_id => params[:user_id], :user_category_id => @entity.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => @entity.sub_category, :is_active => params[:feed],:comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1")
     if @entities.save
       if @email_list.present?
        @email_list.each do |email_list|
          PostMailer.post_mailers(email_list).deliver
        end
      end
      if !(params[:receiver_id]).nil?
        message
      end
      if !(params[:group_id]).nil?
        group_message
      end
       format.json {render :json => {:message => "Add Entity Sucessfully"}}
     else
       format.json {render :json => {:errors => "Some error during post"}}
     end
   end
end
end

 def remove_entity
    @user_entity = UserEntity.where(:id => params[:user_entity_id]).first
    respond_to do |format|
      if @user_entity.present?
        @user_entity.destroy
        format.json {render :json => {:message => "entity_delete successfully"}}
      else
        format.json {render :json => {:message => "Some errors during deletion"}}
    end
  end
 end

 def sort_entity
     narrow_sub_category = params[:narrow_by_sub_cateogy].split(",")
     narrow_city = (params[:narrow_by_city]).split(",")
     @user_entity_setting = EntitySetting.where(:user_id => params[:user_id]).first
     respond_to do |format|
     if @user_entity_setting.present?
        @user_entity_setting.update_attributes(:user_id => params[:user_id], :narrow_by_sub_category => narrow_sub_category, :narrow_by_city => narrow_city , :sort_by => params[:sort_by])
        if @user_entity_setting.save
          format.json {render :json => {  :message =>"Update Setting Successfully"} }
        else
          format.json {render :json => {  :message =>"Some error during setting"} }
       end
     else
       @sorting_entity = EntitySetting.new
       @sorting_entity.update_attributes(:user_id => params[:user_id], :narrow_by_sub_category => narrow_sub_category, :narrow_by_city => narrow_city , :sort_by => params[:sort_by])
       if @sorting_entity.save
         format.json {render :json => {  :message =>"Add Setting Successfully"} }
       else
         format.json {render :json => {  :message =>"Some error during setting"} }
       end
  end
 end
end


    def sort_and_narrow
     rating = {}
     @rating = Array.new
     @sorts = EntitySetting.where(:user_id => params[:user_id]).first
     respond_to do |format|
     if @sorts.sort_by == "rating"
       @category = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => @sorts.user_id)
      @category.each do |categ|
        @entity_ratings = UserEntity.where(:user_category_id => categ.id, :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sorts.narrow_by_city  || {:sub_category => @sorts.narrow_by_sub_category}).order_by(:rating_count => "desc")
          @entity_ratings.each do |user_ent|
          @users = User.where(:id =>  user_ent.user_id)
          @users.each do |users|
            rat = rating.merge(:user_id => users.id, :user_name => users.first_name, :profile_picture => users.profile_picture_url,:entity_image => user_ent.entity_image_url, :entity_name => user_ent.entity_name, :rating_count => user_ent.rating_count, :address =>user_ent.address , :city => user_ent.city , :entity_id => user_ent.id, :sub_category => user_ent.sub_category)
           @rating << rat
         end
        end
        end
       format.json {render :json => @rating}
    elsif @sorts.sort_by == "recent"
       @category = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => @sorts.user_id)
      @category.each do |categ|
        @entity_ratings = UserEntity.where(:user_category_id => categ.id, :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sorts.narrow_by_city  || {:sub_category => @sorts.narrow_by_sub_category}).order_by(:created_at => "desc")
          @entity_ratings.each do |user_ent|
          @users = User.where(:id =>  user_ent.user_id)
          @users.each do |users|
           rat = rating.merge(:user_id => users.id, :user_name => users.first_name, :profile_picture => users.profile_picture_url,:entity_image => user_ent.entity_image_url, :entity_name => user_ent.entity_name, :rating_count => user_ent.rating_count,:address =>user_ent.address , :city => user_ent.city , :entity_id => user_ent.id, :sub_category => user_ent.sub_category)
           @rating << rat
         end
        end
      end
      format.json {render :json => @rating}

    elsif @sorts.sort_by == "friend"
      @user_c = UserCategory.where(:id => params[:user_category_id]).first
      @friends = Relatoinship.where(:user_id => @sorts.user_id)
      @friends.each do |friend|
        cds = friend.friend_user_id
        @categories = UserCategory.where(:master_category_id => params[:master_category_id], :user_id => cds.to_s).uniq {|p| p.user_id}
        @categories.each do |cate|
          @user_enti = UserEntity.where(:user_category_id => cate.id, :entity_name => /.*#{params[:entity_name][:char]}*./i).in(:city => @sorts.narrow_by_city  || {:sub_category => @sorts.narrow_by_sub_category})
          @user_enti.each do |user_ent|
          @users = User.where(:id =>  user_ent.user_id)
          @users.each do |users|
            rat = rating.merge(:user_id => users.id, :user_name => users.first_name, :profile_picture => users.profile_picture_url,:entity_image => user_ent.entity_image_url, :entity_name => user_ent.entity_name, :rating_count => user_ent.rating_count, :address =>user_ent.address , :city => user_ent.city , :entity_id => user_ent.id, :sub_category => user_ent.sub_category)
           @rating << rat
         end
        end
        end
      end
      format.json {render :json => @rating}
      elsif @sorts.sort_by == "proxy"
      loc = Array.new
      loc << params[:longitude].to_f
         loc << params[:lattitude].to_f
      @category = UserCategory.where(:user_id => @sorts.user_id)
      @category.each do |categ|
# @entity_ratings = UserEntity.geocoded
        @entity_ratings = UserEntity.where(:user_category_id => categ.id, :entity_name => /.*#{params[:entity_name][:char]}*./i)
        @entity_ratings.each do |user_ent|
          @users = User.where(:id =>  user_ent.user_id)
          @users.each do |users|
           rat = rating.merge(:user_id => users.id, :user_name => users.first_name, :profile_picture => users.profile_picture_url,:entity_image => user_ent.entity_image_url, :entity_name => user_ent.entity_name, :rating_count => user_ent.rating_count)
           @rating << rat
         end
        end
      end
      format.json {render :json => @rating}
       end
   end
   end


   def sorting_setting
     sort = {}
     @sort_data = Array.new
      @sorts = EntitySetting.where(:user_id => params[:user_id]).first
      respond_to do |format|
      if @sorts.present?
        format.json {render :json => @sorts}
      else
        sort_data = sort.merge(:sort_by => "proxy", :narrow_by_city => "city", :narrow_by_sub => "sub_category")
        @sort_data << sort_data
        format.json {render :json => @sort_data}
      end
      end
   end

 def get_city_and_sub_category
   @test = UserCategory.where(:id => params[:user_category_id]).first
   @city = Array.new
   @sub_category = Array.new
   @final = Array.new
   respond_to do |format|
     if params[:search] == "i_liike"
       @get_entity_user =  UserEntity.where(:user_category_id => params[:user_category_id], :user_id => params[:user_id]).order_by(:sub_category => "asc")
       @get_entity_user.each do |user_entity|
          @city << user_entity.city
          @sub_category << user_entity.sub_category
       end
       format.json {render :json => {:city => @city.uniq, :sub_category => @sub_category.uniq}}
     elsif params[:search] == "weliike"
       @category_relations = Array.new
       @categ = Array.new
       @user_relations = UserCategoryRelation.where(:user_id => params[:user_id], :user_category_id => params[:user_category_id])
       @user_relations.each do |user_relation|
          @category_relations << user_relation.friend_user_id
       end

       @category_relations.push(params[:user_id])
          @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id]).in(:user_id => @category_relations)
          @user_category_id.each do |cat|
              @categ << cat.id
         end

            @user_entity = UserEntity.in(:user_category_id => @categ)#.order_by(:sub_category => "asc")#.uniq {|p|  p.entity_name}
           @user_entity.each do |user_entity|
               @city << user_entity.city
                @sub_category << user_entity.sub_category
            end
            

       format.json {render :json => {:city => @city.uniq, :sub_category => @sub_category.uniq}}
     elsif params[:search] == "friend"
       @category_relations = Array.new

       @user_relations = Relatoinship.where(:user_id => params[:user_id],:is_active => "true")
         @user_relations.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         @user_category_ids = UserCategory.where(:master_category_id => params[:master_category_id],:is_active => "true")
         @user_category_ids.each do |cat|
           @user_Cate_re = UserCategoryRelation.where(:user_id => params[:user_id],:user_category_id => cat.id, :is_active => "true")
         @user_Cate_re.each do |user_relation|
             @category_relations << user_relation.friend_user_id
         end
         end

         @category_relations.uniq
            @category_relations.each do |user_re|
            @user_category_id = UserCategory.where(:master_category_id => params[:master_category_id],:user_id => user_re)
            @user_category_id.each do |cat|
               @friend_entity = UserEntity.where(:user_category_id => cat.id , :user_id => cat.user_id).order_by(:sub_category => "asc")
            @friend_entity.each do |user_entity|
              @city << user_entity.city
              @sub_category << user_entity.sub_category
            end
            end
            end
       format.json {render :json => {:city => @city.uniq, :sub_category => @sub_category.uniq}}
      elsif params[:search] == "trends"
        my_user = Array.new
        user_category = UserCategory.where(:master_category_id => params[:master_category_id])
        user_category.each do |category|
           @user_relations = UserCategoryRelation.where(:user_category_id => category.id).uniq {|p|  p.user_id}
           @user_relations.each do |user_relation|
              my_user << user_relation.user_category_id
           end
        end
        my_user.each do |urs|
          @user_entity = UserEntity.where(:user_category_id => urs ).order_by(:sub_category => "asc")
          @user_entity.each do |user_entity|
             @city << user_entity.city
             @sub_category << user_entity.sub_category
          end
        end
        format.json {render :json => {:city => @city.uniq, :sub_category => @sub_category.uniq}}
     end
    end
 end



  def double_tab_entity
   @double_en = UserEntity.where(:id => params[:user_entity_id]).first
   @double_cat = UserCategory.where(:id => @double_en.user_category_id).first
    respond_to do |format|
      if @double_en.user_id ==  params[:user_id]
      else
        if @double_en.present?
     @user_cat = UserCategory.where(:master_category_id => @double_cat.master_category_id, :user_id => params[:user_id]).first
     if @user_cat.present?
       @user_category_relations = UserCategoryRelation.where(:user_id => params[:user_id], :user_category_id => @user_cat.id, :friend_user_id => params[:user_id]).first
       if @user_category_relations.present?
          @user_category_relations.update_attributes(:is_active => "1")
          @user_category_relations.save
       else
          @user_category_relationss = UserCategoryRelation.new
          @user_category_relationss.update_attributes(:is_active => "1" , :user_id => params[:user_id], :user_category_id => @user_cat.id, :friend_user_id => params[:user_id])
          @user_category_relationss.save
       end
        @user_entitiess = UserEntity.where(:other_entity_id => @double_en.id, :user_id => params[:user_id]).first
        if @user_entitiess.present?
           @user_entitiess.update_attributes(:is_public => "1", :is_liikes => "1")
           @user_entitiess.save
            @likes = ILiikes.where(:friend_user_id => params[:friend_user_id], :user_id => params[:user_id] , :user_entity_id => @double_en.id).first
            if @likes.present?
               @likes.update_attributes(:is_liikes => "1")
               @likes.save
            else
              @iliikes = ILiikes.new
              @iliikes.update_attributes(:friend_user_id => params[:friend_user_id], :user_id => params[:user_id] , :user_entity_id => @double_en.id,:is_liikes => "1")
              @iliikes.save
            end
            format.json {render :json => {:message => "Successfully Like entity"}}
        else
          if @double_en.api_id == ""

          end
            @user_ent11 =UserEntity.new
            @user_ent11.update_attributes(:caputredDeviceOrientation => @double_en.caputredDeviceOrientation,:artist=> @double_en.artist,:xcody => @double_en.xcody, :ycody => @double_en.ycody,:rating_count =>@double_en.rating_count,:is_public => "1",:api_id =>@double_en.api_id, :user_id => params[:user_id],:user_category_id => @user_cat.id , :entity_name => @double_en.entity_name, :entity_image => @double_en.entity_image, :entity_image_url => @double_en.entity_image_url, :is_active => "1",:is_liike => "1", :other_entity_id => @double_en.id,:sub_category => @double_en.sub_category,:city => @double_en.city,:address => @double_en.address )
          @user_ent11.save
           @likes = ILiikes.where(:friend_user_id => params[:friend_user_id], :user_id => params[:user_id] , :user_entity_id => @double_en.id).first
            if @likes.present?
               @likes.update_attributes(:is_liikes => "1")
               @likes.save
            else
              @iliikes = ILiikes.new
              @iliikes.update_attributes(:friend_user_id => params[:friend_user_id], :user_id => params[:user_id] , :user_entity_id => @double_en.id,:is_liikes => "1")
              @iliikes.save
            end
          format.json {render :json => {:message => "Successfully Like entity"}}

        end
     else
       @user_cate = UserCategory.new
         @user_cate.update_attributes(:master_category_id => @double_cat.master_category_id, :user_id => params[:user_id], :is_active => "1")
         if @user_cate.save
           @user_category_relations = UserCategoryRelation.where(:user_id => params[:user_id], :user_category_id => @user_cate.id, :friend_user_id => params[:user_id]).first
             if @user_category_relations.present?
             @user_category_relations.update_attributes(:is_active => "1")
             @user_category_relations.save
             else
              @user_category_relationss = UserCategoryRelation.new
              @user_category_relationss.update_attributes(:is_active => "1" , :user_id => params[:user_id], :user_category_id => @user_cate.id, :friend_user_id => params[:user_id])
              @user_category_relationss.save
             end
             @user_entii = UserEntity.new
           @user_entii.update_attributes(:caputredDeviceOrientation => @double_en.caputredDeviceOrientation,:artist=> @double_en.artist,:xcody => @double_en.xcody, :ycody => @double_en.ycody,:rating_count =>@double_en.rating_count,:is_public => "1",:api_id =>@double_en.api_id, :user_id => params[:user_id],:user_category_id => @user_cate.id , :entity_name => @double_en.entity_name, :entity_image => @double_en.entity_image, :entity_image_url => @double_en.entity_image_url, :is_active => "1",:is_liike => "1",:other_entity_id => @double_en.id,:sub_category => @double_en.sub_category,:city => @double_en.city,:address => @double_en.address)
           if @user_entii.save
            @likes = ILiikes.where(:friend_user_id => params[:friend_user_id], :user_id => params[:user_id] , :user_entity_id => params[:user_entity_id]).first
             if @likes.present?
               @likes.update_attributes(:is_liikes => "1")
               @likes.save
             else
               @iliikes = ILiikes.new
               @iliikes.update_attributes(:friend_user_id => params[:friend_user_id], :user_id => params[:user_id] , :user_entity_id => params[:user_entity_id],:is_liikes => "1")
               @iliikes.save
             end
              format.json {render :json => {:message => "Successfully Like entity"}}
          else
           format.json {render :json => {:message => "Error during Like entity"}}
           end
         end
     end
   else
     format.json {render :json => {:message => "There is no data"}}
   end
      end
    
 
 end

 end
 
 def update_sort_setting
   @entity_setting = EntitySetting.where(:user_id => params[:user_id]).first
   @entity_setting.update_attributes(:sort_by => "Recent",:narrow_by_city => "" , :narrow_by_sub_category => "")
   respond_to do |format|
    if @entity_setting.save
      format.json {render :json => {:message => "Success"}}
    else
      format.json {render :json => {:message => "Failed"}}
    end
   end

 end

  def unlikes_entity
    @entities = UserEntity.where(:other_entity_id => params[:user_entity_id],:user_id => params[:user_id]).first
    respond_to do |format|
    if @entities.present?
     # @entities.other_entity_id = ""
      @entities.is_public = "0"
      @entities.is_liike = "0"
      if @entities.save
        @likes = ILiikes.where(:friend_user_id => params[:friend_user_id], :user_id => params[:user_id] , :user_entity_id => params[:user_entity_id]).first
             if @likes.present?
               @likes.update_attributes(:is_liikes => "0")
               @likes.save
               format.json {render :json => {:message => "Successfully unfollow"}}
             
             end
        
      else
        format.json {render :json => {:message => "No Follow"}}
      end
    else
       format.json {render :json => {:message => "First Follow This Category"}}
    end
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


def sign_up_entity_remove
  entity = (params[:user_entity_id]).split(",")
  @user_entity_sign_up = UserEntity.in(:id => entity).where(:user_id => params[:user_id])
  respond_to do |format|
    if @user_entity_sign_up.present?
      @user_entity_sign_up.each do |entity_rm|
        entity_rm.delete
      end
     format.json {render :json => {:message => "Successfully Deleted"}}
    else
      format.json {render :json => {:message => "There is No Entity"}}

    end
   end

end


def sign_up_category_remove
  category = (params[:user_category_id]).split(",")
  @user_category_sign_up = UserCategory.in(:id => category).where(:user_id => params[:user_id])
  respond_to do |format|
    if @user_category_sign_up.present?
      @user_category_sign_up.each do |category_rm|
        category_rm.delete
      end
     format.json {render :json => {:message => "Successfully Deleted"}}
    else
      format.json {render :json => {:message => "There is No Entity"}}

    end
   end

end


def delete_null_entity
  @user_entity = UserEntity.where(:city => "")
  respond_to do |format|
    if @user_entity.present?
      format.json {render :json => @user_entity}
    end
  end

end

def get_entity_id
  @entity = Array.new
  @get_entity =  UserEntity.where(:user_category_id =>params[:user_category_id], :user_id => params[:user_id])
  @get_entity.each do |user_entity|
    @entity << user_entity.id
  end
  respond_to do |format|
    format.json {render :json => @entity}
  end
end

end
