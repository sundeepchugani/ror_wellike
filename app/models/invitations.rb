class Invitations
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, :type => String
  field :email_id, :type => String
  field :providers, :type => String
  field :status, :type => String
end