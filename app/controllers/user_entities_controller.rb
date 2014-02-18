class UserEntitiesController < ApplicationController

    def suggested_entity
      @cat = {}
      @cati = Array.new
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
        @user_entity_suggested.update_attributes(:entity_image_url =>@user_entity_suggested.entity_image,:information => params[:information],:user_id => params[:user_id], :user_category_id => @user_category_check.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => params[:sub_category],:is_active => "1",:comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1", :entity_image => @entity_image_suggested)
        @user_entity_suggested.save
        cl = @cat.merge(:entity_image =>@user_entity_suggested.entity_image ,:master_category_id => params[:master_category_id],:information =>@user_entity_suggested.information,:user_id => params[:user_id], :user_category_id => @user_category_check.id,:entity_name => @user_entity_suggested.entity_name,:address => @user_entity_suggested.address,:lat => @user_entity_suggested.lat, :longitude => @user_entity_suggested.longitude,:sub_category => params[:sub_category], :is_active => "1",:comment => @user_entity_suggested.comment,:rating_count => @user_entity_suggested.rating_count,:is_public => "1")
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
              entity_image_suggested = StringIO.new(Base64.decode64(entity_image_suggested))
              entity_image_suggested.class.class_eval { attr_accessor :original_filename, :content_type }
              entity_image_suggested.original_filename = "entity_image.jpg"
              entity_image_suggested.content_type = "image/jpg"
           end
         @user_entity_suggested.update_attributes(:entity_image_url =>@user_entity_suggested.entity_image, :information => params[:information],:user_id => params[:user_id], :user_category_id => @user_category.id,:entity_name => params[:entity_name],:address => params[:address],:lat => params[:lat], :longitude => params[:longitude],:sub_category => params[:sub_category],:entity_image => @entity_image_suggested, :is_active => "1",:comment => params[:comment],:rating_count => params[:rating_count],:is_public => "1")
         @user_entity_suggested.save
         su = sugg.merge(:user_id => @user_category.user_id, :user_category_id => @user_category.id, :entity_image => @user_entity_suggested.entity_image,:entity_name => @user_entity_suggested.entity_name,:longitude => @user_entity_suggested.longitude, :lat => @user_entity_suggested.lat, :address => @user_entity_suggested.address, :rating_count =>@user_entity_suggested.rating_count, :comment => @user_entity_suggested.comment,:information => @user_entity_suggested.information)
        @sugg << su
        format.json {render :json => @sugg}
          end

        end
     end
       
      end

    def test_search
      @sort_setting = EntitySetting.where(:user_id => params[:user_id]).first
      @category_relations = Array.new
      @cate = Array.new
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
q = "#{params[:entity_name][:char]}"

 @user_entities_with_sub_category_and_city = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc])|UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city, :sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc])).group_by { |t| t.api_id }
         @user_entities_with_only_city = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc])|UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:city => @sort_setting.narrow_by_city).order_by([:rating_count,:desc])).group_by { |t| t.api_id }
         @user_entities_with_only_sub_category = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc])| UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).in(:sub_category => @sort_setting.narrow_by_sub_category).order_by([:rating_count,:desc])).group_by { |t| t.api_id }
         @user_entity_with_recent = (UserEntity.where(:is_active => "true",:entity_name => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).order_by([:rating_count,:desc])|UserEntity.where(:is_active => "true",:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE)).in(:user_category_id => @cate).order_by([:rating_count,:desc])).group_by { |t| t.api_id }

         



       @user_entity_with_recent = (UserEntity.where(:entity_name =>  Regexp.new((".*"+q+".*"), Regexp::IGNORECASE), :is_active => "true").in(:user_category_id => @cate).order_by(:created_at => "desc") | UserEntity.where(:sub_category => Regexp.new((".*"+q+".*"), Regexp::IGNORECASE), :is_active => "true").in(:user_category_id => @cate).order_by(:created_at => "desc") ).group_by { |t| t.api_id }
     # @user_entity_with_recent = UserEntity.where( "name LIKE '%#{params[:search]}%"])#.to_sql#.in(:user_category_id => @cate).order_by(:created_at => "desc").group_by { |t| t.api_id }
      
#    end
respond_to do |format|
        format.json {render :json => @user_entity_with_recent}
     end
    end

end

 

#
