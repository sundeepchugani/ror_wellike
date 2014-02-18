class ThreadParticipant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :thread_id , :type => String
  field :user_id , :type => String
  field :sender_id, :type => String
  field :is_new , :type => String
end
