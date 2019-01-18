class SessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by_handle(params[:handle])
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now[:alert] = "Handle or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
