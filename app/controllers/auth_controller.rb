class AuthController < ApplicationController

def callback
    provider_user = request.env['omniauth.auth']
    @facebook_image = provider_user.info.image

    #find create a user
    user = User.find_or_initialize_by(provider_id: provider_user['uid'], provider: params[:provider]) do |u|
      u.provider_hash = provider_user['credentials']['token']
      u.name = provider_user['info']['name']
      u.email = if provider_user['info']['email'] != nil then provider_user['info']['email'] else 'test@test.com' end
      u.password_digest = "fb_authenticated" 
      u.save
    end
    #create user session
    session[:user_id] = user.id
    #send them home
     redirect_to user
  end
v
  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  def failure
    #TODO: display error page
    render plain: "this is a failure"
  end

end