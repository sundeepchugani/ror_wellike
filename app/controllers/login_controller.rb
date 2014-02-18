class LoginController < ApplicationController
  # Controller & Method Name : Login Controller Create Method.
  # Summary : This method used to authenticate user.
  # Status : Active
  # Parameters : login[email]= Email of user ,login[password]= Password
  # Output : User Details.
  def create 
    user = User.authenticate(params[:login][:email], params[:login][:password])#....the authenticate method check user id and passord
     respond_to do |format|
    if user
      session[:user_id] = user.id
     format.json { render :json => user, :status => :created}
    else
      format.json  { render :json => { :errors => "Invalid User"}}
    end
    end
  end
end
