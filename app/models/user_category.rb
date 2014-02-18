class UserCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  belongs_to :master_category
  has_many :user_entities ,:dependent => :destroy
  has_many :user_category_relations ,:dependent => :destroy
  validates_uniqueness_of :user_id, :scope => :master_category_id


  field :user_id, :type=> String
  field :master_category_id, :type => String
  field :is_active, :type => Boolean
end
