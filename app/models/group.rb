class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  has_many :group_memberss

  has_mongoid_attached_file :group_images,
  :storage => :s3,
  :default_url => '/images/missing.jpg',
  #:styles => {:medium    => '200x200'},
  :path => "group/:id/group_image/:medium.:extension",
  :bucket => "welike1",
  :s3_credentials => {
    :access_key_id => "AKIAI7HDALY47WENY3RQ",
    :secret_access_key => "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"
  }
  field :group_name, :type => String
  field :group_owner_id, :type => String
  field :group_image_url, :type => String
  field :notification, :type =>Boolean
  field :is_active, :type => Boolean
 # curl -X POST -d "group[group_name]=Hi Hello&group[group_owner]=Hay&group[status]=1&is_active=1&member_user_id=&notification=1" http://localhost:3000/group/group_create.json
 #curl -X POST -d "group_owner_id=513471b2f7e4f330e9000097" http://localhost:3000/group/get_group_by_user_id.json
end
