class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :post
  belongs_to :user_entity
  field :post_id, :type=> String
  field :comment_text, :type=> String
  field :user_id, :type=> String
  field :self_user_id, :type=> String
  field :is_public, :type =>  Boolean
  field :all_tag, :type=> String
  field :all_user_name_tag, :type=> String
  field :is_new_comment, :type =>  Boolean
  field :is_active, :type =>  Boolean
  field :user_entity_id , :type => String

  def self.comment_text(emial,id, entity_id)
    cms = Array.new
    if emial.nil?
    else
      cd = emial.split(" ")
    cd.each do |test|
       color = "#3399FF"
       if test.start_with?("@")
        # <font face='Helvetica'  size=16 color='gray'>
         p1 = "<a href='#{id.to_s}'><font color='#{color}'>"
         p1= p1.concat(test).concat("</font>").concat("</a>")
         test.gsub!(test,p1 )
       elsif  test.start_with?("#")
         p2 = "<a href='#{entity_id.to_s}'><font color='#{color}'>"
         p2= p2.concat(test).concat("</font>").concat("</a>")
         test.gsub!(test,p2 )
       else
         cms << test
       end
   end
    end
    
 end
end

