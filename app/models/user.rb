class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Hierarchy
  include Mongoid::MultiParameterAttributes
  
  has_many :user_categories
  has_many :user_category_relation
  has_many :user_entities
  has_many :ratings
  has_many :comments
#  has_many :relationshipss

#  has_many :posts

  attr_accessor :password
  before_save :encrypt_password
  has_mongoid_attached_file :profile_picture,
     :storage => :s3,
  :default_url => '/images/missing.jpg',
  #:styles => {:medium    => '200x350'},
  :path => "user/:id/profile_picture/:style.:extension",
  :bucket => "welike1",
  :s3_credentials => {
    :access_key_id => "AKIAI7HDALY47WENY3RQ",
    :secret_access_key => "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"
  }
  has_mongoid_attached_file :cover_photo,
     :storage => :s3,
  :default_url => '/images/missing.jpg',
  #:styles => {:medium    => '320x200'},
  :path => "user/:id/cover_photo/:medium.:extension",
  :bucket => "welike1",
  :s3_credentials => {
    :access_key_id => "AKIAI7HDALY47WENY3RQ",
    :secret_access_key => "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"
  }
    validates_uniqueness_of :email, :on =>:create, :message => "Email Already Exists"

    field :first_name, :type => String
  field :last_name, :type => String
  field :email, :type => String
  field :name, :type => String
  field :phone, :type => String
  field :fb_token, :type => String
  field :provider, :type => String
  field :profile_picture_url, :type => String
  field :cover_photo_url, :type => String
  field :is_suggessted, :type => Boolean
  field :facebook_id, :type => String
  field :bio, :type => String
  field :city, :type => String
  field :country, :type => String
  field :currunt_lat, :type => String
  field :current_long, :type => String
  field :gender, :type => String
  field :birthday, :type => Date
  field :website, :type => String
  field :mobile_no, :type => String
  field :twitter_id,:type => String
  field :is_active, :type => Boolean
  field :registration_id, :type => String
  field :last_login_time, :type => Time
  field :created_time, :type => Time
  field :deleted_time, :type => Time
  field :password_salt, :type => String
  field :password_hash, :type => String
  field :screen_name, :type => String
  field :privacy, :type => Boolean
  field :friend_like_my_activity_for_pn, :type => Boolean
  field :friend_like_my_activity_for_mail, :type => Boolean
  field :any_one_like_my_activity_for_pn, :type => Boolean
  field :any_one_like_my_activity_for_mail, :type => Boolean
  field :friend_mention_me_in_comment_for_pn, :type => Boolean
  field :friend_mention_me_in_comment_for_mail, :type => Boolean
  field :any_one_mention_me_in_comment_for_pn, :type => Boolean
  field :any_one_mention_me_in_comment_for_mail, :type => Boolean
  field :a_friend_follow_my_category_for_pn, :type => Boolean
  field :a_friend_follow_my_category_for_mail, :type => Boolean
  field :any_one_friend_follow_my_category_for_pn, :type => Boolean
  field :any_one_friend_follow_my_category_for_mail, :type => Boolean
  field :a_friend_shares_a_place_tip_or_entity_with_me_for_pn, :type => Boolean
  field :a_friend_shares_a_place_tip_or_entity_with_me_for_mail, :type => Boolean
  field :any_one_shares_a_place_tip_or_entity_with_me_for_pn, :type => Boolean
  field :any_one_shares_a_place_tip_or_entity_with_me_for_mail, :type => Boolean
  field :i_receive_a_friend_request_of_friend_confirmation_for_pn, :type => Boolean
  field :i_receive_a_friend_request_of_friend_confirmation_for_mail, :type => Boolean
  field :a_new_friend_from_facebook_join_we_like_for_pn, :type => Boolean
  field :keep_me_up_to_date_with_welike_news_and_update_for_pn, :type => Boolean
  field :keep_me_up_to_date_with_welike_news_and_update_for_mail, :type => Boolean
  field :send_me_weekly_updates_about_whats_my_friends_are_up_to_for_pn, :type => Boolean
  field :send_me_weekly_updates_about_whats_my_friends_are_up_to_for_mail, :type => Boolean
  field :save_photo_phone, :type =>Boolean
  field :geotag_post, :type => Boolean
  field :post_are_private,:type => Boolean

  def encrypt_password
    if password.present?
     self.password_salt = BCrypt::Engine.generate_salt
     self.password_hash = BCrypt::Engine.hash_secret(password,password_salt)
    end
  end
   def self.authenticate(email, password)
    user = User.where(:email => email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
   end

   def self.authenticate_password(email, password)
    user = User.where(:email => email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
   end


   def self.user_category_id(key)
     key.each{|k| delete(k)}
  end
end
