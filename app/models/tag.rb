class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :tag_name, :type => String
  field :comment_id, :type => String
  field :post_id, :type => String
  field :user_entity_id, :type => String
end
#curl -X GET http://localhost:3000/user_category/all_category.json