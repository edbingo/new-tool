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
    session[:studen]
    redirect_to root_url, notice: "Logged out!"
  end

  def studcreate
    student = Student.find_by_number(params[:number])
    if student && student.authenticate(params[:password]) && student.login && !student.register
      session[:student_id] = student.id
      redirect_to registrieren_path
      flash["success"] = "Willkommen, #{student.vorname} #{student.name}"
    elsif !student.login
      redirect_to root_path
      flash["alert"] = "Anmeldungen sind deaktiviert. Bitte versuchen Sie später nochmals."
    elsif student.register
      redirect_to root_path
      flash["alert"] = "Sie haben sich schon registriert."
    else
      redirect_to root_path
      flash["error"] = "Diese Kombination wurde in der Datenbank nicht gefunden"
    end
  end
end
