module FriendsHelper
   def time_ago_in_words(from_time, include_seconds = false, options = {})
      distance_of_time_in_words(from_time, Time.now, include_seconds, options)
  end
end
