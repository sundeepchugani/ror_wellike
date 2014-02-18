class PostEntityController < ApplicationController
def post_remove
  @post = Post.where(:id => params[:post_id])
  respond_to do |format|
    if @post.destroy
      format.json {render :json => {:message => "Your Media successfully Deleted"}}
    else
      format.json {render :json => {:message => "Some error during  media delete"}}
    end
  end
end


def search_en
  @category_relations = Array.new
  @cate = Array.new
  @sort_setting = EntitySetting.where(:user_id => params[:user_id]).first
  @sort_setting.sort_by == "Recent"
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
              @cate.uniq
  @user_entity_with_recent = UserEntity.where(:is_active => "true",:sub_category => /.*#{params[:entity_name][:char]}*./i  ).in(:user_category_id => @cate).order_by(:created_at => "desc").group_by { |t| t.api_id } #|| @user_entity_with_recent = UserEntity.where(:is_active => "true",:sub_category => /.*#{params[:entity_name][:char]}*./i).in(:user_category_id => @cate).order_by(:created_at => "desc").group_by { |t| t.api_id }
  respond_to do |format|
    format.json {render :json => @user_entity_with_recent}
  end
end
end
