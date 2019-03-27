class SelectController < ApplicationController
    def list
        if current_student.select.count == Pref.first.req
            redirect_to confirm_selection_path
        end
        @presentations = Presentation.where("frei > ?", 0)
    end

    def add
        pres = Presentation.find_by_id(params_allow)
        pres.frei = pres.frei - 1
        pres.save
        current_student.select << pres.id
        current_student.save
        redirect_to registrieren_path
    end

    def remove
        pres = Presentation.find_by_id(params_allow)
        pres.frei += 1
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

    def time_check
        current_student.select.each do |i|
            pres = Presentation.find_by_id(i)
            if pres.bis + Pref.first.time > newpres.von
            end
        end
    end

    private

    def params_allow
        params.require(:id)
    end
end
