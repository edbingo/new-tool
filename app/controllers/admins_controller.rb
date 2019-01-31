class AdminsController < ApplicationController
  require 'csv'
  before_action :set_admin, only: [:show, :edit, :update, :destroy]


  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.all
    @admin = Admin.new
  end

  def list_teac
    @teachers = Teacher.all
    @teacher = Teacher.new
  end

  def settings
    #code
  end

  def view_teac
    @teac = Teacher.first
    respond_to do |format|
      format.js
    end
  end

  def list_stud
    @students = Student.all
  end

  def list_pres
    @presentations = Presentation.all
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  def clear
    [Student, Admin, Presentation, Teacher].each { |model| model.truncate! }
    Rails.application.load_seed
    flash[:success] = "Datenbank wurde zurückgesetzt"
    redirect_to root_path
  end

  # POST /admins
  # POST /admins.json
  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      redirect_to admins_path
    else
      redirect_to admins_path
      flash["error"] = "Es ist ein Fehler passiert. Bitte überprüfen Sie Ihre Eingabe."
    end
  end

  def new_teac
    @teacher = Teacher.new(teac_params)
    @teacher.nv = "#{@teacher.name} #{@teacher.vorname}"
    @teacher.vn = "#{@teacher.vorname} #{@teacher.name}"
    if @teacher.save
      redirect_to list_teachers_path
    else
      redirect_to list_teachers_path
      flash["error"] = "Bitte überprüfen Sie Ihre Eingabe."
    end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: 'Admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import_presentations
    conv = lambda { |header| header.downcase }
    items = []
    CSV.foreach(params[:file].path, headers: true, col_sep: ";", header_converters: conv) do |row|
      items << Presentation.new(row.to_h)
    end
    Presentation.import(items)
    redirect_to dashboard_path
  end

  def import_teachers

    items = []
    CSV.foreach(params[:file].path,headers: true, col_sep: ";") do |row|
      items << Teacher.new(row.to_h)
    end
    Teacher.import(items)

    t = Teacher.all
    t.each do |f|
      f["rec"] = false
      f.nv = "#{f.name} #{f.vorname}"
      f.vn = "#{f.vorname} #{f.name}"
    end
    redirect_to upload_students_path
    flash[:success] = "Import erfolgreich"
  end

  def import_students
    file = params[:file].path
    table = CSV.read(file, headers: true, col_sep: ";")
    table.each do |row|
      pass = rand.to_s[2..6]
      row["code"] = pass
      row["password"] = pass
      row["password_confirmation"] = pass
      row["register"] = false
      row["rec"] = false
      row["login"] = true
    end

    CSV.open('new.csv', "w", col_sep: ";") do |f|
      f << table.headers
      table.each{ |row| f << row }
    end

    stud = []
    CSV.foreach('new.csv',headers: true, col_sep: ";") do |row|
      stud << Student.new(row.to_h)
    end
    Student.import(stud)
    flash["success"] = "Studenten importiert"
    redirect_to upload_presentations_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_params
    params.require(:admin).permit(:handle, :password, :password_confirmation)
  end

  def teac_params
    params.require(:teacher).permit(:vorname, :name, :number, :mail)
  end
end
