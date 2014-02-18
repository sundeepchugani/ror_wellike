class UserEntity
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Geocoder::Model::Mongoid
  include ActionView::Helpers::DateHelper

        # can also be an IP address
         # auto-fetch coordinates
geocoded_by :address, :skip_index => true
after_validation :geocode
#geocoded_by :address, :latitude  => :lat, :longitude => :lon

reverse_geocoded_by :coordinates
after_validation :reverse_geocode  # auto-fetch
  has_mongoid_attached_file :entity_image,
  :storage => :s3,
  # :styles => { :big => "437x354!" },

  :default_url => '/images/missing.jpg',
  :path => "entity/:id/entity_image/:style.:extension",
  :bucket => "welike1",
  :s3_credentials => {
    :access_key_id => "AKIAI7HDALY47WENY3RQ",
    :secret_access_key => "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"
  }

  belongs_to :user
  belongs_to :user_category
  has_many :comments, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :ratings  , :dependent => :destroy


  #validates_uniqueness_of  :scope => [:user_id, :api_id], :message => "Already Exists"
  field :caputredDeviceOrientation , :type => String
  field :artist , :type => String
  field :api_id, :type => String
  field :def, :type => Boolean
  field :xcody, :type => Float
  field :ycody, :type => Float
  field :user_category_id, :type => String
  field :entity_name, :type => String
  field :information, :type => Array
  field :user_id, :type => String
  field :address, :type => String
  field :city, :type => String
  field :lat, :type => Float
  field :longitude, :type => Float
  field :sub_category, :type => String
  field :entity_image_url, :type => String
  field :is_active, :type => Boolean
  field :comment, :type => String
  field :rating_count, :type => String
  field :is_public, :type => Boolean
  field :is_liike, :type => Boolean
  field :other_entity_id , :type => String
  field :address, :type => String
  field :coordinates, :type => Array


#   index [[ :coordinates, Mongo::GEO2D ]]

  

  validates :entit_name, :presence =>  {:case_sensitive => false}, :on => :search_all
  # validates_presence_of :entity_name, :case_sensitive => false
end
