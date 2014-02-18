class GroupMemberController < ApplicationController
  def create
   members = params[:group_members][:member_id].split(",")
    members.each do |f|
      @group_members = GroupMembers.create
      @group_members.update_attribute(:group_id => params[:group_members][:group_id],:member_id => f, :notification =>"1", :is_active => "1")
      @group_members.save
    end
    respond_to do |format|
      if !@group_members.blank?
       format.json {render :json=>{:message=>"Data Saved."}}
      else
        format.json {render :json=>{:message=>"Data Not Saved."}}
      end
    end
  end
  def all
    @group_members=GroupMembers.where(:group_id => params[:group_members][:group_id])
    respond_to do |format|
    if !@group_members.blank?
      format.json {render :json=>@group_members}
      format.xml {render :xml=>@group_members}
    else
      format.json {render :json=>"No Data found"}
      format.xml {render :xml=>"No Data found"}
    end
    end

  end
end
