class StudentMailer < ApplicationMailer
  def login_mail
    @student = params[:user]
    mail to: @student.mail, subject: 'Anmeldedaten Präsentation'
  end


end
