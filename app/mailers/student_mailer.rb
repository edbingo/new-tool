class StudentMailer < ApplicationMailer
  def login_mail(student)
    @student = student
    subject = "MA#{Time.new.year - 2000} - Elektronische Anmeldung fpr den Besuch der Präsentationen der Maturaarbeiten MA#{Time.new.year - 2001}"
    mail to: @student.mail, subject: subject
  end

  def mahn_mail(student)
    @student = student
    m = "MA#{Time.new.year - 2000}"
    mail to: @student.mail, subject: "WICHTIG: #{m} - Elektronische Anmeldung"
  end

  def final_mail(student)
    @student = student
    mail to: @student.mail, subject: "Gewählte Präsenationen"
  end

  def list_mail(teacher)
    @teacher = teacher
    @pres = Presentation.where(betreuer: @teacher.number)
    mail to: @teacher.mail, subject: "Mündliche Maturapräsentationen"
  end

  def test_mail
    mail to: 'elancaster4@gmail.com', subject: "Testing 1, 2, 1, 2"
  end

end
