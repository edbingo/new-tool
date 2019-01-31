class SessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by_handle(params[:handle])
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to dashboard_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Handle or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  def studcreate
    student = Students.find_by_number(params[:number]) && student.register == false && student.login == true
    if student && student.authenticate(params[:password])
      stud_in student
      redirect_to root_path, notice: "Student signed in"
    elsif student && student.register == true
      flash.now[:alert] = "Registration already complete"
      redirect_to root_path
    elsif student && student.login == false
      flash.now[:alert] = "Registrations are currently unavailable"
      redirect_to root_path
    end

  end
end
