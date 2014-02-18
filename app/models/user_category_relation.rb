class UserCategoryRelation
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  field :user_id, :type=> String
  field :friend_user_id, :type => String
  field :user_category_id, :type => String
  field :master_category_id, :type => String
  field :is_active, :type => Boolean

#validates_uniqueness_of :user_id, :scope => [:friend_user_id, :user_category_id], :message => "Already Exists"
#validates_uniqueness_of :user_id, :scope => :master_category_id

end
