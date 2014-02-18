class EntitySetting
  include Mongoid::Document
  include Mongoid::Timestamps

  field :sort_by, :type=> String
  field :user_id, :type=> String
  field :narrow_by_city, :type=> Array
  field :narrow_by_sub_category, :type=> Array


end
