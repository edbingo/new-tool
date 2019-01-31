class ApplicationController < ActionController::Base
  helper_method :current_user
  include SessionsHelper

  def current_user
    if session[:admin_id]
      @current_user ||= Admin.find(session[:admin_id])
    else
      @current_user = nil
    end
  end
end
