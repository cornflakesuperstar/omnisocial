module Omnisocial
  class AuthController < ApplicationController
  
    unloadable
  
    def new
      if current_user?
        flash[:notice] = 'You are already signed in. Please sign out if you want to sign in as a different user.'
        redirect_to(root_path)
      end
    end
  
    def callback    
      @account = case request.env['rack.auth']['provider']
        when 'twitter' then
          Omnisocial::TwitterAccount.find_or_create_from_auth_hash(request.env['rack.auth'])
        when 'facebook' then
          Omnisocial::FacebookAccount.find_or_create_from_auth_hash(request.env['rack.auth'])
      end
      if current_user && @account.user != current_user
        @account.update_attributes(:user => current_user) 
      end
      if @account.user
        self.current_user = @account.user
        flash[:message] = 'You have logged in successfully.'
        redirect_back_or_default(root_path)
      else
        @user = User.new(:display_name => @account.name)
      end
    end
    
    def confirm
      @account = Omnisocial::LoginAccount.find(params[:account_id])
      @user = User.new(params[:omnisocial_user].merge(:picture_url => @account.picture_url))
      if @user.save
        @account.update_attributes(:user => @user)
        self.current_user = @user
        flash[:message] = 'You have logged in successfully.'
        redirect_back_or_default(root_path)
      else
        render :action => "callback"
      end
    end
  
    def failure
      flash[:error] = "We had trouble signing you in. Did you make sure to grant access? Please select a service below and try again."
      render :action => 'new'
    end
  
    def destroy
      logout!
      redirect_to(session['return_to'] || root_path)
    end
  end
end
