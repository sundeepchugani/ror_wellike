class ILiikes
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, :type => String
  field :friend_user_id, :type => String
  field :user_entity_id, :type => String
  field :is_liikes, :type => Boolean


end
