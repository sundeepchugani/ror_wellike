class GroupMembers
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :group

  field :group_id, :type => String
  field :member_user_id, :type => String
  field :notification, :type =>String
  field :is_active, :type => Boolean
end
