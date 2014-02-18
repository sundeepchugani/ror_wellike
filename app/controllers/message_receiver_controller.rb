class MessageReceiverController < ApplicationController
  def get_receivers_by_messageid

    @message_receiver = Array.new
    # Gatting Message
    @message = Message.new
    @message = Message.where(:id=>params[:message_receiver][:message_id])
   # Gatting Message Receivers
    @message_id=params[:message_receiver][:message_id]
    @receiver= MessageReceiver.where(:message_id => @message_id)
    i = 0
    @receiver.each do |receiver|
      @message_receiver[i] = @message
      @message_receiver[i] = @message_receiver[i]<<receiver
      i=i+1
    end
    if !@message_receiver.blank?
      format.json{render :json => @message_receiver}
    else
      format.json{render :json =>{:message =>"No message Found"} }
    end
  end
end
