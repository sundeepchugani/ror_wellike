class Relatoinship
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, :type =>String
  field :friend_user_id, :type => String
  field :status, :type => String
  field :is_active, :type => Boolean
  belongs_to :user

#validates_uniqueness_of :user_id, :scope => :friend_user_id
end
