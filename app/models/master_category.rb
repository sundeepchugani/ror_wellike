class MasterCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  #has_many :master_categories , :dependent => :destroy
  has_many :user_categories , :dependent => :destroy
  belongs_to :user


  has_mongoid_attached_file :category_image,
  :storage => :s3,
  :default_url => '/images/missing.jpg',
  :styles => {:medium    => '200x200'},
 # "#{<s3 path>/thumb/#{image_name}.{image_file_type}"
  :path => "master_category/:id/category_image/:medium.:extension",
  :bucket => "welike1",
  :s3_credentials => {
    :access_key_id => "AKIAI7HDALY47WENY3RQ",
    :secret_access_key => "XsKpqluuDd40wj/FgZlw5tMNlXgiK9XWjJHTp9i3"
  }
 # :url => ":s3_alias_url" # These two are only required when you alias S3 - e.g. want to use cdn.example.com rather than s3.amazonaws.com
  #:s3_host_alias => "my.aws.alias"


  field :category_name, :type => String
  field :category_image_url, :type => String
  field :entity_name_obligatory, :type => Boolean
  field :is_active, :type => Boolean

end
