class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

   has_mongoid_attached_file :post_image,
     :storage => :s3,
  :default_url => '/images/missing.jpg',
  :path => "post/:id/post_image/:style.:extension",
  :bucket => "welike1",
  :s3_credentials => {
    :access_key_id => "AKIAI7HDALY47WENY3RQ",
    :secret_access_key => "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"
  }

  belongs_to :user
  belongs_to :user_entity
  has_many :comments  ,:dependent => :destroy
  has_many :ratings , :dependent => :destroy
  
  

  field :caputredDeviceOrientation , :type => String
  field :user_id, :type => String
  field :api_id, :type => String
  field :user_entity_id, :type => String
  field :lat, :type => String
  field :longitude, :type => String
  field :city, :type => String
  field :post_video, :type => String
  field :pin_url, :type => String
  field :is_public, :type => Boolean
  field :def, :type => Boolean
  field :comment_text, :type => String
  field :post_image_url, :type => String
  field :is_active, :type => Boolean
  field :xcody, :type => Float
  field :ycody, :type => Float
  field :address , :type => String
  field :rating_count, :type => String
  



end
