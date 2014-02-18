class MessageController < ApplicationController
  def create
    r = Random.new
    @read_state = Array.new
    respond_to do |format|
    if params[:is_new_message] == "1"
      @message_s = Message.last
       @users = User.where(:email => params[:email]).first
       @message = Message.new
       @message.update_attributes(:sender_id => params[:sender_id],:message_body => params[:message_body], :is_active => "1", :thread_id => 2, :user_entity_id => params[:user_entity_id])
       @read_state << @message.sender_id
       @read_state << params[:receiver_id]

      if @message.save
        @read_state.each do |read|
        @thread_participant = ThreadParticipant.new
        @thread_participant.update_attributes(:thread_id => @message.thread_id, :user_id => read, :is_new => "1")
        @thread_participant.save
          @message_read_state = MessageReadState.new
          if (read == @message.sender_id)
            @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "1" )
          else
            @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "0" )
          end
        end
        format.json {render :json => @message}
      else
        format.json {render :json => { :message => "Error During Message sending"}}
      end
    end
    @users = User.where(:email => params[:email]).first
    @message = Message.new
    @message.update_attributes(:sender_id => params[:sender_id],:message_body => params[:message_body], :is_active => "1", :thread_id => 2, :user_entity_id => params[:user_entity_id])
    @read_state << @message.sender_id
    @read_state << params[:receiver_id]
     
      if @message.save
        @read_state.each do |read|
        @thread_participant = ThreadParticipant.new
        @thread_participant.update_attributes(:thread_id => @message.thread_id, :user_id => read, :is_new => "1")
        @thread_participant.save
          @message_read_state = MessageReadState.new
          if (read == @message.sender_id)
            @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "1" )
          else
            @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "0" )
          end
        end
        format.json {render :json => @message}
      else
        format.json {render :json => { :message => "Error During Message sending"}}
      end
    end
  end
  
def message_thread
  @thread = Array.new
  @message_thread = ThreadParticipant.where(:thread_id => params[:thread_id], :is_new => "1")
  @message_thread.each do |threads|
    @messagess = ThreadParticipant.where(:thread_id => threads.thread_id).first
    threads.is_new = "0"
    threads.save
    @thread << threads.user_id
 end

 @cd = @thread.uniq
  
  @messages = Message.new
  @messages.update_attributes(:thread_id=> params[:thread_id], :sender_id => params[:sender_id],:message_body => params[:message_body], :is_active => "1")
  if @messages.save
    @cd.each do |participents|
      @thread_participant = ThreadParticipant.new
        @thread_participant.update_attributes(:thread_id => @messages.thread_id, :user_id => participents, :is_new => "1")
         @message_read_state = MessageReadState.new
          if (participents == @messages.sender_id)
            @message_read_state.update_attributes(:message_id => @messages.id, :user_id => participents, :status => "1" )
          else
            @message_read_state.update_attributes(:message_id => @messages.id, :user_id => participents, :status => "0" )
          end
          if @thread_participant.save
            @message_threads = ThreadParticipant.where(:thread_id => params[:thread_id], :is_new => "0")
            @message_threads.destroy
          end
    end
 end
end

#def get_all_message_threads
#  message_thread = {}
#  @message_thread = Array.new
#  @thread_id = Array.new
#  @get_message_chain = ThreadParticipant.where(:user_id => params[:user_id])
#  @get_message_chain.each do |m_chain|
#    @thread_id << m_chain.thread_id
#  end
#  thr = @thread_id.uniq
#  thr.each do |thre|
#    @messages = Message.where(:thread_id => thre).last
#    @user = User.where(:id => @messages.sender_id)
#    @user.each do |user|
#      ms = message_thread.merge(:user_id => user.id, :profile_picture => user.profile_picture_url, :user_name => user.first_name, :thread_id => @messages.thread_id, :message_body => @messages.message_body)
#      @message_thread << ms
#    end
#  end
#  respond_to do |format|
#    format.json {render :json => @message_thread}
#  end
#end

def get_message_detail_by_thread_id
  message_entities = {}
  @message_entities = Array.new
  message_user = {}
  @message_user = Array.new
  @get_message = Message.where(:thread_id => params[:thread_id])
  @get_message.each do |message_details|
    @message_entity = UserEntity.where(:id => message_details.user_entity_id).first
    @message_post = Post.where(:id =>  message_details.user_entity_id)
    @user_category = UserCategory.where(:id => @message_entity.user_category_id).first
    @master_category = MasterCategory.where(:id => @user_category.master_category_id).first
    if @message_entity.present?
      @users = User.where(:id => message_details.sender_id)
      @users.each do |users|
        mu = message_user.merge(:user_id => users.id, :user_name => users.first_name, :profile_picture => users.profile_picture_url, :created_time => message_details.created_at, :message_body => message_details.message_body )
        @message_user <<  mu
      end
      @userss = User.where(:id => @message_entity.user_id).first
      em = message_entities.merge(:category_name=> @master_category.category_name,:user_entity_image =>@message_entity.entity_image_url,:address => @message_entity.address, :rating_count=> @message_entity.rating_count,:user_id => @userss.id,:profile_picture => @userss.profile_picture_url, :user_name => @userss.first_name,:user_entity_id => @message_entity.id, :entity_name=> @message_entity.entity_name, :message => @message_user)
      @message_entities << em
    else @message_post.present?
      @users = User.where(:id => message_details.sender_id)
      @users.each do |users|
        mu = message_user.merge(:user_id => users.id, :user_name => users.first_name, :profile_picture => users.profile_picture_url, :created_time => message_details.created_at, :message_body => message_details.message_body )
        @message_user <<  mu
      end
      @userss = User.where(:id => @message_post.user_id).first
      em = message_entities.merge(:category_name=> @master_category.category_name,:user_entity_image =>@message_post.entity_image_url,:address => @message_post.address, :rating_count=> @message_post.rating_count,:user_id => @userss.id,:profile_picture => @userss.profile_picture_url, :user_name => @userss.first_name,:user_entity_id => @message_entity.id, :entity_name=> @message_entity.entity_name, :message => @message_user)
      @message_entities << em
    end
    
  end
  respond_to do |format|
    format.json {render :json => @message_entities}
    format.xml {render :xml => @message_entities}
  end
end

def group_message
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
    @message = Message.new
   @message.update_attributes(:sender_id => params[:user_id],:message_body => params[:message_body], :is_active => "1", :thread_id => ch, :user_entity_id => params[:user_entity_id])
   @read_state << @message.sender_id
   gm.each do |receive_user|
    @read_state << receive_user
  end
  respond_to do |format|
   if @message.save
        @read_state.each do |read|
        @thread_participant = ThreadParticipant.new
        @thread_participant.update_attributes(:thread_id => @message.thread_id, :user_id => read, :is_new => "1")
        @thread_participant.save
          @message_read_state = MessageReadState.new
          if (read == @message.sender_id)
            @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "1" )
          else
            @message_read_state.update_attributes(:message_id => @message.id, :user_id => read, :status => "0" )
          end
        end
        format.json {render :json => @message}
      else
        format.json {render :json => { :message => "Error During Message sending"}}
      end
  end
 end

def get_all_message_threads
  @friend_request = Array.new
  @activity = Array.new
  message_thread = {}
  @message_thread = Array.new
  @thread_id = Array.new
  @get_message_chain = ThreadParticipant.where(:user_id => params[:user_id])
  @get_message_chain.each do |m_chain|
    @thread_id << m_chain.thread_id
     puts":::::::::::::::::::::::::::::::#{m_chain.inspect}"
  end
  thr = @thread_id.uniq
  thr.each do |thre|
    @messages = Message.where(:thread_id => thre).last
   
    @user = User.where(:id => @messages.sender_id)
    @user.each do |user|
      ms = message_thread.merge(:user_id => user.id, :profile_picture => user.profile_picture_url, :user_name => user.first_name, :thread_id => @messages.thread_id, :message_body => @messages.message_body)
      @message_thread << ms
    end
  end
  respond_to do |format|
    format.json {render :json => {:message => @message_thread, :activity => @activity , :friend_request => @friend_request } }
  end
end


##  curl -X POST -d "thread_id=1&user_id=1" http://localhost:3000/message/create.json
##  curl -X POST -d "thread_id=2" http://localhost:3000/message/message_thread.json
##  curl -X POST -d "thread_id=2&user_id=51502b8df7e4f3ef9b000002" http://localhost:3000/message/get_message.json
##  curl -X POST -d "thread_id=2&user_id=2" http://localhost:3000/message/group_message.json
## curl -X POST -d "user_id=51502b8df7e4f3ef9b000002" http://localhost:3000/message/get_all_message_threads.json
## curl -X POST -d "thread_id=37&user_id=51502b8df7e4f3ef9b000002" http://localhost:3000/message/get_message_detail_by_thread_id.json


  
end
