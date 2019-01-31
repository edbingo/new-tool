module SessionsHelper
  def current_admin
    if session[:admin_id]
      @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
  end

  def current_student
    if session[:student_id]
      @current_student ||= Student.find_by_id(session[:student_id])
    end
  end

  def stud_in(student)
    session[:student_id] = student.id
  end

  def logged_ad?
    !current_admin.nil?
  end

  def logged_stud?
    !current_student.nil?
  end
end
