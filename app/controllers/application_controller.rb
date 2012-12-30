class ApplicationController < ActionController::Base
  before_filter :authorize, :except => [:login, :checkbrainmailbox]
  
  protect_from_forgery
  
  protected
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to :controller => "auth", :action => "login"
    end
  end
  
end
