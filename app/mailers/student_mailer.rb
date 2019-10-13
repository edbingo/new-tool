class StudentMailer < ApplicationMailer
  def login_mail(student)
    @student = student
    if Pref.first.pres_type == 0
      subject = "MA#{Time.new.year - 2000} - Elektronische Anmeldung für den Besuch der Präsentationen der Maturaarbeiten MA#{Time.new.year - 2000}"
    elsif Pref.first.pres_type == 1
      subject = "FMS#{Time.new.year - 2000} - Elektronische Anmeldung für den Besuch der Präsentationen der FMS Arbeiten FMS#{Time.new.year - 2000}"
    end
    mail to: @student.mail, subject: subject
  end

  def mahn_mail(student)
    @student = student
    if Pref.first.pres_type == 0
      m = "MA#{Time.new.year - 2000}"
    elsif Pref.first.pres_type == 1
      m = "FMS#{Time.new.year - 2000}"
    end
    mail to: @student.mail, subject: "WICHTIG: #{m} - Elektronische Anmeldung"
  end

  def final_mail(student)
    @student = student
    mail to: @student.mail, subject: "Gewählte Präsentationen"
  end

  def list_mail(teacher)
    @teacher = teacher
    @pres = Presentation.where(betreuer: @teacher.number)
    if Pref.first.pres_type == 0
      mail to: @teacher.mail, subject: "Mündliche Maturapräsentationen"
    elsif Pref.first.pres_type == 1
      mail to: @teacher.mail, subject: "Mündliche FMS Präsentationen"
    end
  end

  def test_mail
    mail to: 'elancaster4@gmail.com', subject: "Testing 1, 2, 1, 2"
  end

end
