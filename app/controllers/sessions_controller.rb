class SessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by_handle(params[:handle])
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to dashboard_path, notice: "Anmeldung erfolgreich"
    else
      flash.now[:alert] = "Name oder Passwort falsch"
      render "new"
    end
  end

  def destroy
    session[:admin_id] = nil
    session[:student_id] = nil
    redirect_to root_url, notice: "Session beendet"
  end

  def studcreate
    student = Student.find_by_number(params[:number])
    admin = Admin.find_by_handle(params[:number])
    prefs = Pref.first
    if student && student.authenticate(params[:password]) && prefs.login && !student.register
      session[:student_id] = student.id
      redirect_to registrieren_path
      flash["success"] = "Willkommen, #{student.vorname} #{student.name}"
    elsif admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to dashboard_path
      flash["success"] = "Anmeldung als Admin erfolgreich"
    elsif !prefs.login
      redirect_to login_path
      flash["alert"] = "Anmeldungen sind deaktiviert. Bitte versuchen Sie später nochmals."
    elsif student.register
      redirect_to login_path
      flash["alert"] = "Sie haben sich schon registriert."
    else
      redirect_to login_path
      flash["error"] = "Diese Kombination wurde in der Datenbank nicht gefunden"
    end
  end

  def force
    student = Student.find_by_id(params[:id])
    session[:student_id] = student.id
    redirect_to registrieren_path
  end

  def back
    session[:student_id] = nil
    redirect_to list_students_path
  end

end
