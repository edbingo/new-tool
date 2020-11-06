class SelectController < ApplicationController
    def list
        if current_student.select.count == Pref.first.req
            redirect_to confirm_selection_path
        end
        @presentations = []
        Presentation.all.each do |p|
            if Pref.first.free - p.visit.count > 0 || current_student.select.include?(p.id)
                @presentations << p
            else
            end
        end
    end

    def success

    end

    def add
        pres = Presentation.find_by_id(params_allow)
        pres.save
        current_student.select << pres.id
        current_student.save
        redirect_to registrieren_path
    end

    def remove
        pres = Presentation.find_by_id(params_allow)
        pres.save
        current_student.select.delete(pres.id)
        current_student.save
        redirect_to registrieren_path
    end

    def confirm
        @presentations = []
        current_student.select.each do |p|
            pres = Presentation.find_by_id(p)
            @presentations << pres
        end
    end

    def sending     
        count = 0        
        current_student.select.each do |s|
            pres = Presentation.find_by_id(s)
            if Pref.first.free - pres.visit.count <= 0
                current_student.select.delete(s)
                current_student.save
                count += 1
            end
        end
        if count == 0
            current_student.select.each do |s|
                p = Presentation.find_by_id(s)
                p.visit << current_student
                p.save
            end
            current_student.register = true
            current_student.save
            StudentMailer.final_mail(current_student).deliver_now
            session[:student_id] = nil
            if logged_ad?
              redirect_to list_students_path
            else
              redirect_to success_url, notice: "Session beendet"
            end
        else
            redirect_to registrieren_path
            if count == 1
                flash[:error] = "#{count} Präsentation sind nicht mehr verfügbar, sie wurden entfernt. Bitte versuchen Sie es nocheinmal."
            else
                flash[:error] = "#{count} Präsentationen sind nicht mehr verfügbar, sie wurden entfernt. Bitte versuchen Sie es nocheinmal."
            end     
        end
    end
    private

    def params_allow
        params.require(:id)
    end
end
