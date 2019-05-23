class TeacherController < ApplicationController
  def view
    @teacher = Teacher.find_by_number(params[:id])
    @presentations = Presentation.where(betreuer: @teacher.number)
  end
end
