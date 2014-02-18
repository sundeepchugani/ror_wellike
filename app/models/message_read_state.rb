class MessageReadState
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message_id, :type => String
  field :user_id, :type => String
  field :status, :type => Boolean
end
