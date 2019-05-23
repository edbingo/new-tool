# Preview all emails at http://localhost:3000/rails/mailers/student_mailer
class StudentMailerPreview < ActionMailer::Preview
  def login_mail
    student = Student.first
    StudentMailer.login_mail(student)
  end

    def mahn_mail
      student = Student.first
      StudentMailer.mahn_mail(student)
    end

    def final_mail
      student = Student.first
      StudentMailer.final_mail(student)
    end

    def list_mail
      @teacher = Teacher.find_by_number(20)
      StudentMailer.list_mail(@teacher)
    end

end
