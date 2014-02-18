LikeWelikes::Application.routes.draw do

## message


  ##### Admin
post 'tag/all_tag' => 'tag#all_tag'
post 'entity_info/details' => 'entity_info#details'
post 'user_entity/double_tab_entity' => 'user_entity#double_tab_entity'
post 'user_entity/unlikes_entity' => 'user_entity#unlikes_entity'
post 'user_entity/sign_up_entity_remove' => 'user_entity#sign_up_entity_remove'
post 'user_entity/sign_up_category_remove' => 'user_entity#sign_up_category_remove'
post 'user_entity/get_entity_id' => 'user_entity#get_entity_id'
post 'user_entity/delete_null_entity' => 'user_entity#delete_null_entity'




post "comment/comments_for_test" => "comment#comments_for_test"
post "comment/suggested_friends_name" => "comment#suggested_friends_name"
post "weliikes/weliikes" => "weliikes#weliikes"
  get 'admin/search_user' => 'admin#search_user'
  post 'admin/search_user_result' => 'admin#search_user_result', :as => :search
  get 'admin/admin' => 'admin#admin'
  get 'admin/sign_up' => 'admin#sign_up', :as => :admin_sign_up
  post 'admin/admin_create' => 'admin#admin_create', :as => :admin_sign_up
  get 'admin/all_user' => 'admin#all_user', :as=> :all_user_list

post 'message/create' => 'message#create'
post 'message/message_thread' => 'message#message_thread'
post 'message/get_message' => 'message#get_message'
post 'message/group_message' => 'message#group_message'
post 'message/messages' => 'message#messages'
post 'message/get_all_message_threads' => 'message#get_all_message_threads'
post 'message/get_message_detail_by_thread_id' => 'message#get_message_detail_by_thread_id'
post 'message/all_notifications' => 'message#all_notifications'

  post 'friends/delete_user' => 'friends#delete_user'
  post 'friends/other_friends_relations' => 'friends#other_friends_relations'
  post 'friends/unfollow_all' => 'friends#unfollow_all'
  post 'friends/following_search' => 'friends#following_search'
  post 'friends/entity_likers' => 'friends#entity_likers'




  post 'friends/check_facebook' => 'friends#check_facebook'
  post 'feedback/invite_user' => 'feedback#invite_user'

  post 'search/geocode' => 'search#geocode'
  post 'search/search_all' => 'search#search_all'
  post 'i_liikes/i_liike_sort' => 'i_liikes#i_liike_sort'
  post 'i_liikes/i_liike_sort_other' => 'i_liikes#i_liike_sort_other'

  post 'weliikes/weliike_sort' => 'weliikes#weliike_sort'
  post 'trends/trends_sort' => 'trends#trends_sort'
  post 'friends_sort/friend_sort' => 'friends_sort#friend_sort'
  post 'sort/demo' => 'sort#demo'
  post 'user_entity/update_sort_setting' => 'user_entity#update_sort_setting'
  post 'user/delete_user' => 'user#delete_user'
  post 'user/friend_feed' => 'user#friend_feed'
  post 'user/ago_time_for' => 'user#ago_time_for'




  # search

  post 'user/friend_search' => 'user#friend_search'
  post 'user/search_friend_on_people' => 'user#search_friend_on_people'
  post 'friends/all_friends_search' => 'friends#all_friends_search'
  post 'search/search_all' => 'search#search_all'
  post 'search/i_liike_sort' => 'search#i_liike_sort'



# rating
post 'rating/rating_entity' => 'rating#rating_entity'
post 'rating/unfollow_entity' => 'rating#unfollow_entity'

  ## post
  #
  post "post_entity/post_remove" => "post_entity#post_remove"
  post "post_entity/search_en" => "post_entity#search_en"

  # For Admin

  get "admin/new"
  post "admin/user_create" => "admin#user_create", :as => :user_create_admin
  get 'welcome/:id' => 'admin#welcome'
  get 'admin/user_entity' => 'admin#user_entity'
  post 'admin/user_entity_create' => 'admin#user_entity_create', :as => :user_entity_create_admin
  get "entity_show_admin/:id" => "admin#entity_show_admin"

# for user_entities
post "user_entities/suggested_entity" => "user_entities#suggested_entity"
post "user_entities/save_media" => "user_entities#save_media"
post "user_entities/get_entity_by_user_id_cat_id" => "user_entities#get_entity_by_user_id_cat_id"
post "user_entities/test_search" => "user_entities#test_search"


# For groups

 post "group/group_create" => "group#group_create"
 post "group/get_group_by_owner_id" => "group#get_group_by_owner_id"
 post "group/edit_group" => "group#edit_group"
 post "group/group_details" => "group#group_details"


  get "post_entity/new"
  post "post_entity/entity_search" => "post_entity#entity_search"
  post "post_entity/post_create" => "post_entity#post_create"
  get "master_entity/new" => "master_entity#new"
  post "master_entity/create" => "master_entity#create", :as => :entity_create
  get "master_entity/entity" => "master_entity#entity" , :as => :entity_list
  post "master_entity/master_entity_list" => "master_entity#master_entity_list"
  post "master_entity/create_other_entity" => "master_entity#create_other_entity"

  ## For feedback User
  get "feedback/new"
  post "feedback/feedback_user" => "feedback#feedback_user" , :as => :feedback_user
  get "show" => "feedback#show"

# for Facebook user creation
  get "twitter/new"
  post "twitter/twitters" => "twitter#twitters"

# for twitter user Creation
  get "facebook/new" => "facebook#new"
  post "facebook/create" => "facebook#create"
  post "facebook/facebook_friend_counts" => "facebook#facebook_friend_counts"

# user created by email
  post "user/create" => "user#create", :as => :user_create
  post "user/update" => "user#update", :as => :update_user
  post "user/change_password" => "user#change_password"
  post "user/update_notifications" => "user#update_notifications"
  post "user/other_user" => "user#other_user"
  post "user/user_feed" => "user#user_feed"
  post "user/peoples" => "user#peoples"
  post "user/news_feed" => "user#news_feed"
  post "user/add_facebook_id" => "user#add_facebook_id"
# user Login via username and password
  get "login/new" => "login#new"
  post "login/create" => "login#create" , :as => :login_create

# for facebook Friends

  get "friends/new" => "friends#new"
  post "friends/create" => "friends#create", :as => :friends_create
  post "friends/email_friends" => "friends#email_friends"
  post "friends/category_friends_sign_up" => "friends#category_friends_sign_up"
  post "friends/category_friends" => "friends#category_friends"
  post "friends/all_friends" => "friends#all_friends"
  post "friends/following" => "friends#following"
  post "friends/followers" => "friends#followers"
  post "friends/following_data" => "friends#following_data"
  post "friends/followers_data" => "friends#followers_data"
  post "friends/friend_clouds" => "friends#friend_clouds"
  post "friends/traids" => "friends#traids"
  post "friends/all_friend_for_welike" => "friends#all_friend_for_welike"
  post "friends/suggested_friends" => "friends#suggested_friends"
  post "friends/group_friend" => "friends#group_friend"
  post 'friends/likers' => 'friends#likers'
  post 'friends/unfollow' => 'friends#unfollow'
  post 'friends/add_friend_form_facebook_and_email' => 'friends#add_friend_form_facebook_and_email'


  post "comment/comment_text" => "comment#comment_text"
  post "comment/all_entity_comments" => "comment#all_entity_comments"
  post "comment/all_post_comments" => "comment#all_post_comments"




  # for User Category
  get "user_category/new" => "user_category#new"
  post "user_category/create" => "user_category#create", :as => :user_category_create
  post "user_category/get_friend" => "user_category#get_friend"
  post "user_category/aggrigrator" => "user_category#aggrigrator"
  post "user_category/add_friend_by_category_id" => "user_category#add_friend_by_category_id"
  post "user_category/all_category" => "user_category#all_category"
  post "user_category/remove_category" => "user_category#remove_category"
  post "user_category/follow_category" => "user_category#follow_category"
  post "user_category/unfollow_category" => "user_category#unfollow_category"

  post "user_category/is_active" => "user_category#is_active"



  


  #for user entity
  post "user_entity/create" => "user_entity#create"
    get "user_entity/entity_list" =>  "user_entity#entity_list"
     get "user_entity/media" =>  "user_entity#media"
    post "user_entity/save_media" => "user_entity#save_media", :as => :save_media
    get "show/:id" => "user_entity#show"
    post "user_entity/get_entity_by_user_id_cat_id" => "user_entity#get_entity_by_user_id_cat_id"
    post "user_entity/entity_info" => "user_entity#entity_info"
    post "user_entity/welike" => "user_entity#welike"
    post "user_entity/check_entity" => "user_entity#check_entity"
    post "user_entity/get_entity_by_category_id" => "user_entity#get_entity_by_category_id"
    post "user_entity/entity_search" => "user_entity#entity_search"
    post "user_entity/repost" => "user_entity#repost"
    post "user_entity/sorting" => "user_entity#sorting"
    post "user_entity/narrowing" => "user_entity#narrowing"
    post "user_entity/remove_entity" => "user_entity#remove_entity"
    post "user_entity/sort_entity" => "user_entity#sort_entity"
    post "user_entity/sort_and_narrow" => "user_entity#sort_and_narrow"
    post "user_entity/sorting_setting" => "user_entity#sorting_setting"
    post 'user_entity/search_all' => 'user_entity#search_all'
    post 'user_entity/entity_search_sign_up' => 'user_entity#entity_search_sign_up'
    post 'user_entity/following' => 'user_entity#following'
    post 'user_entity/following_data' => 'user_entity#following_data'
    post 'user_entity/get_city_and_sub_category' => 'user_entity#get_city_and_sub_category'






  # for comment
  post "comment/post_comment" => "comment#post_comment"
  post "comment/entity_comment" => "comment#entity_comment"


  # for tagging
  post "tag/post_tag" => "tag#post_tag"

  get "category/new" => "category#new"
  get "category/list" => "category#list", :as =>:list
  match "edit_category" => "category#edit_category"
  match "category/create" => "category#create", :as => :create_category
   match "edit_cate" => "category#edit_cate"
  get "category/category_list" => "category#category_list", :as => :category_list


    root :to => 'category#new'

  
end
