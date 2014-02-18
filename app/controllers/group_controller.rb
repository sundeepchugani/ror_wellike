require 'will_paginate/array'
class GroupController < ApplicationController
  def group_create
      @groups = Group.new
    if params[:group_image]
      group_picture = (params[:group_image]).gsub(" ","+")
      @data = StringIO.new(Base64.decode64(group_picture))
      @data.class.class_eval { attr_accessor :original_filename, :content_type }
      @data.original_filename = "group_picture.jpg"
      @data.content_type = "image/jpg"
    end
    @groups.update_attributes(:group_name => params[:group_name], :group_images => @data , :group_owner_id => params[:group_owner_id], :notification => params[:notification], :is_active => "1", :group_image_url => @groups.group_images)
     if @groups.save
      member = params[:member_user_id].split(",")
       member.each do |groups|
           group_members = @groups.group_memberss.build(:group_id => @groups.id , :member_user_id =>groups , :notification =>params[:notification],:is_active => "1")
           group_members.save
           end
     end
     respond_to do |format|
       format.json {render :json => {:message => "Group Successfully Created"}}
     end
  end

    def get_group_by_owner_id
      @get_group = Group.where(:group_owner_id => params[:group_owner_id])
      respond_to do |format|
        format.json {render :json => @get_group}
      end
    end

    def group_details
      group = {}
      @mem = Array.new
      friends_user = Array.new
      @group = Array.new
      group_members = {}
      @group_members = Array.new
      @reltionships = Group.where(:id => params[:group_id]).first
      @group_member = GroupMembers.where(:group_id => @reltionships.id)
      @group_member.each do |members|
        @group_user = User.where(:id => members.member_user_id)
         gr = group_members.merge(:group_id => members.group_id, :notifications => members.notification)
         
        @group_user.each do |group_user|
          gr = group_members.merge(:user_id => group_user.id, :profile_picture => group_user.profile_picture_url,:user_name => group_user.first_name, :status => "YES" )
          @group_members << gr
          end
          @mem << members.member_user_id
      end
    use = {}
   @user = Array.new
   @friends1 = Relatoinship.where(:user_id => params[:user_id])
   @friends1.each do |f|
  friends_user <<  f.friend_user_id
   end
    edit_friends  = (friends_user - @mem).uniq
    
      edit_friends.each do |userss|
        @users = User.where(:id => userss).paginate(:per_page => 3, :page => params[:page])
     @users.each do |users|
        gr = group_members.merge(:user_id => users.id, :profile_picture => users.profile_picture_url,:user_name =>  users.first_name, :status => "NO" )
          @group_members << gr
    end
      end
  gm = group.merge(:group_image => @reltionships.group_image_url, :notification => @reltionships.notification, :group_name => @reltionships.group_name, :group_owner_id => @reltionships.group_owner_id)
      @group << gm
      respond_to do |format|
        format.json {render :json => {:group => @group, :group_mambers => @group_members} }
      end
    end

 def edit_group
   @reltionships = Group.where(:id => params[:group_id]).first
   respond_to do |format|
    if @reltionships.present?
   if params[:group_image]
      group_picture = (params[:group_image]).gsub(" ","+")
      @data = StringIO.new(Base64.decode64(group_picture))
      @data.class.class_eval { attr_accessor :original_filename, :content_type }
      @data.original_filename = "group_picture.jpg"
      @data.content_type = "image/jpg"
  end
   @reltionships.update_attributes(:group_name => params[:group_name], :group_images => @data,:group_image_url => @reltionships.group_images , :group_owner_id => params[:group_owner_id], :notification => params[:notification], :is_active => "1")
       @group_member = GroupMembers.where(:group_id => @reltionships.id)
        @group_member.each do |mamberss|
           mamberss.delete
         end
          if params[:member_id]
       mamber = (params[:member_id]).split(",")
          mamber.each do |mam|
           group_members = @reltionships.group_memberss.build(:group_id => @reltionships.id , :member_user_id =>mam , :notification =>params[:notification],:is_active => "1")
           group_members.save
     end
       end
       format.json {render :json => {:message => "update Group Successfuuly"}}
    else
      format.json {render :json => {:errors => "Error during update"}}
     end
  end

  end
end

