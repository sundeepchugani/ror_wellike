class Message
  include Mongoid::Document
  include Mongoid::Timestamps


  field :thread_id, :type => String
  field :sender_id, :type => String
  field :message_body, :type => String
  field :message_image, :type => String
  field :user_entity_id, :type => String
  field :is_active,:type=> Boolean
end
