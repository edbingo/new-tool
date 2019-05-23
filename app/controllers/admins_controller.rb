class AdminsController < ApplicationController
  require 'csv'
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_action :only_auth, except: [:list_teachers_view_path]

  def only_auth
    if !logged_ad?
      redirect_to login_path
      flash[:error] = "Diese Seite ist nur für Administratoren verfügbar"
    end
  end

# Dashboard --------------------------------------------------------------------

  def dashboard
    if Student.first == nil && Presentation.first == nil && Teacher.first == nil
      redirect_to upload_teachers_path
    elsif Student.first == nil && Presentation.first == nil && Teacher.first != nil
      redirect_to upload_students_path
    elsif Presentation.first == nil && Student.first != nil && Teacher.first != nil
      redirect_to upload_presentations_path
    else
      @studrec = Student.where(rec: true).count.to_f / Student.all.count.to_f
    end
  end

# Setup ------------------------------------------------------------------------

  # Teachers
  def import_teachers
    if params[:file].nil?
      flash[:error] = "Sie haben keine Datei hochgeladen"
      redirect_to upload_teachers_path
      return
    end
    conv = lambda { |header| header.downcase }
    items = []
    CSV.foreach(params[:file].path,headers: true, col_sep: ";", header_converters: conv) do |row|
      unless row["name"] == nil
        items << Teacher.new(row.to_h)
      end
    end
    Teacher.import(items)
    redirect_to upload_students_path
  end

  # Students
  def import_students
    if params[:file].nil?
      flash[:error] = "Sie haben keine Datei hochgeladen"
      redirect_to upload_students_path
      return
    end
    conv = lambda { |header| header.downcase }
    file = params[:file].path
    table = CSV.read(file, headers: true, col_sep: ";")
    table.each do |row|
      pass = rand.to_s[2..6]
      row["code"] = pass
      row["password"] = pass
      row["password_confirmation"] = pass
      row["register"] = false
      row["rec"] = false
      row["mahn_rec"] = 0
    end

    CSV.open('new.csv', "w", col_sep: ";") do |f|
      f << ["name", "vorname", "number", "mail", "klasse", "code", "password", "password_confirmation", "register", "rec", "mahn_rec"]
      table.each do |row|
         f << row
      end
    end

    stud = []
    CSV.foreach('new.csv', headers: true, col_sep: ";", header_converters: conv) do |row|
      unless row["name"] == nil
        stud << Student.new(row.to_h)
      end
    end
    Student.import(stud)
    redirect_to upload_presentations_path
  end

  # Presentations
  def import_presentations
    if params[:file].nil?
      flash[:error] = "Sie haben keine Datei hochgeladen"
      redirect_to upload_presentations_path
      return
    end
    conv = lambda { |header| header.downcase }
    items = []
    CSV.foreach(params[:file].path, headers: true, col_sep: ";", header_converters: conv) do |row|
      unless row["name"] == nil
        items << Presentation.new(row.to_h)
      end
    end
    Presentation.import(items)
    redirect_to upload_settings_path
  end

  # Preferences
  def prefs_upd
    r = params[:req]
    f = params[:free]
    t = params[:time].to_i * 60
    d = params[:pres_date]
    if Student.all.count * r.to_i > Presentation.all.count * f.to_i
      flash[:error] = "Error 2: Diese Kombination ist ungültig."
      redirect_to upload_settings_path
    else
      Pref.create(time: t, req: r, free: f, login: false, log_data: false, mahn_count: 0, pres_date: d)
      redirect_to process_path
    end
  end

  def processor
    Teacher.all.each do |t|
      t.rec = false
      t.save
    end
    Student.all.each do |s|
      s.select = []
      s.save
    end
    Presentation.all.each do |row|
      row.frei = Pref.first.free
      row.von = "#{Time.parse(row.von).seconds_since_midnight}"
      row.bis = "#{Time.parse(row.bis).seconds_since_midnight}"
      row.visit = []
      row.save
    end
    redirect_to dashboard_path
  end

# Settings ---------------------------------------------------------------------

  # Mailer

  def mailer
    @studrec = Student.where(rec: true).count.to_f / Student.all.count.to_f
    n = 0
    o = 0
    Teacher.all.each do |t|
      if Presentation.where(betreuer: t.number).count != 0 && t.rec == true
        o = o + 1
      end
      if Presentation.where(betreuer: t.number).count != 0
        n = n + 1
      end
    end
    @teacrec = o.to_f / n.to_f
    @num = n
  end

  def send_login
    n = 0
    s = Student.all.where(rec: false)
    p = Pref.first
    s.each do |stud|
      StudentMailer.login_mail(stud).deliver_now
      stud.rec = true
      stud.save
      n += 1
    end
    p.login = true
    p.log_data = true
    p.save
    flash[:success] = "#{n} Mails wurden versendet"
    redirect_to mailer_path
  end

  def send_login_single
    s = Student.find_by_id(params[:id])
    p = Pref.first
    StudentMailer.login_mail(s).deliver_now
    s.rec = true
    s.save
    p.login = true
    p.log_data = true
    p.save
    redirect_to list_students_view_path(:id => s.id)
  end

  # Login Activation
  def act
    Pref.first.update_attribute("login", true)
    render 'settings'
  end

  def deact
    Pref.first.update_attribute("login", false)
    render 'settings'
  end

  # Preferences
  def update_set
    Pref.first.update_attribute("time", params[:time].to_i * 60)
    Pref.first.update_attribute("req", params[:req])
    Pref.first.update_attribute("free", params[:free])
    Pref.first.update_attribute("pres_date", params[:pres_date])
    redirect_to settings_path
  end


# Model Management -------------------------------------------------------------

  # Admins

    # List
    def index
      @admins = Admin.all
      @admin = Admin.new
    end

    # Create
    def create
      @admin = Admin.new(admin_params)
      if @admin.save
        redirect_to admins_path
      else
        redirect_to admins_path
        flash["error"] = "Es ist ein Fehler passiert. Bitte überprüfen Sie Ihre Eingabe."
      end
    end

    # Edit
    def update_admin
      t = Admin.find_by(id: params[:id])
      t.handle = params[:handle]
      t.password = params[:password]
      t.password_confirmation = params[:password_confirmation]
      redirect_to admins_path
    end

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

    # Destroy
    def destroy
      @admin.destroy
      respond_to do |format|
        format.html { redirect_to admins_url, notice: 'Admin was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

  # Teachers

    # List
    def list_teac
      @teachers = Teacher.all
      @teacher = Teacher.new
    end

    def list_teac_all
      @teachers = Teacher.all
      @teacher = Teacher.new
    end

    # Create
    def new_teac
      @teacher = Teacher.new(teac_params)
      if @teacher.save
        redirect_to list_teachers_all_path
      else
        redirect_to list_teachers_path
        flash["error"] = "Bitte überprüfen Sie Ihre Eingabe."
      end
    end

    # Edit
    def edit_teac
      @teacher = Teacher.find_by(id: params[:id])
    end

    def update_teacher
      t = Teacher.find_by(id: params[:id])
      p = Presentation.where(betreuer: t.number)
      p.each do |r|
        r.betreuer = params[:number]
        r.save
      end
      t.update(teac_edit_params)
      redirect_to list_teachers_all_path
    end

    # Delete
    def del_teac
      @teac = Teacher.find_by_id(params[:id])
      @presentations = Presentation.where(betreuer: @teac.number)
    end

    def del_teac_conf
      teac = Teacher.find_by_id(params[:id])
      pres = Presentation.where(betreuer: teac.number)
      teac.destroy
      pres.each do |r|
        r.destroy
      end
      redirect_to list_teachers_path
      flash[:info] = "Lehrer erfolgreich gelöscht"
    end

    # View
    def view_teac
      if params[:id] != nil && params[:number] == nil
        @teacher = Teacher.find_by(id: params[:id])
        @presentations = Presentation.where(betreuer: @teacher.number)
      elsif params[:number] != nil && params[:id] == nil
        @teacher = Teacher.find_by(number: params[:number])
        @presentations = Presentation.where(betreuer: @teacher.number)
      end
    end

  # Presentations

    # List
    def list_pres
      @presentations = Presentation.all
      @presentation = Presentation.new
    end

    # Create
    def new_pres
      @presentation = Presentation.new(pres_params)
      if @presentation.save
        @presentation.update_attribute("frei", Pref.first.free)
        @presentation.update_attribute("von", Time.parse(@presentation.von).seconds_since_midnight)
        @presentation.update_attribute("bis", Time.parse(@presentation.bis).seconds_since_midnight)
        redirect_to list_presentations_path
      else
        redirect_to list_presentations_path
        flash["error"] = "Bitte überprüfen Sie Ihre Eingabe"
      end
    end

    # Edit
    def edit_pres
      if params[:id] == nil
        redirect_to list_presentations_path
      else
        @presentation = Presentation.find_by(id: params[:id])
      end
    end

    def update_presentation
      p = Presentation.find_by_id(params[:id])
      if Teacher.where(number: params[:betreuer]).count == 0
        flash["error"] = "Dieser Lehrer sollte es nicht geben"
        redirect_to update_presentation_path
      elsif Teacher.where(number: params[:betreuer]).count > 0
        p.update(pres_edit_params)
        p.von = Time.parse(p.von).seconds_since_midnight
        p.bis = Time.parse(p.bis).seconds_since_midnight
        p.save
        redirect_to list_presentations_path
      end
    end

    # Delete
    def del_pres
      @presentation = Presentation.find_by_id(params[:id])
    end

    def del_pres_conf
      pres = Presentation.find_by_id(params[:id])
      pres.destroy
      redirect_to list_presentations_path
      flash[:info] = "Präsentation erfolgreich gelöscht"
    end

    # View
    def view_pres
      @pres = Presentation.find_by_id(params[:id])
    end

  # Students

    # List
    def list_stud
      @students = Student.all
      @student = Student.new
      @pass = rand.to_s[2..6]
    end

    # Create
    def new_stud
      @student = Student.new(stud_params)
      if @student.save
        @student.register = false
        @student.rec = false
        @student.save
        redirect_to list_students_path
      else
        redirect_to list_students_path
        flash["error"] = "Bitte überprüfen Sie Ihre Eingabe"
      end
    end

    # Edit
    def edit_stud
      @student = Student.find_by_id(params[:id])
    end

    def update_student
      s = Student.find_by_id(params[:id])
      if s.mail != params["mail"] || s.number != params["number"]
        s.rec = false
        s.save
      end
      s.update(stud_edit_params)
      redirect_to list_students_path
    end

    # Delete
    def del_stud
      @student = Student.find_by_id(params[:id])
    end

    def del_stud_conf
      stud = Student.find_by_id(params[:id])
      stud.destroy
      redirect_to list_students_path
      flash[:info] = "Schüler erfolgreich gelöscht"
    end

    # View
    def view_stud
      @student = Student.find_by_id(params[:id])
      @presentations = []
      @student.select.each do |p|
        pres = Presentation.find_by_id(p)
        @presentations << pres
      end
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
    [Student, Admin, Presentation, Teacher, Pref].each { |model| model.truncate! }
    Rails.application.load_seed
    flash[:success] = "Datenbank wurde zurückgesetzt"
    redirect_to root_path
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
    params.require(:teacher).permit(:vorname, :name, :number, :mail, :id)
  end

  def teac_edit_params
    params.permit(:vorname, :name, :number, :mail, :id)
  end

  def stud_params
    params.require(:student).permit(:vorname, :name, :number, :mail, :klasse, :code, :password, :password_confirmation)
  end

  def stud_edit_params
    params.permit(:vorname, :name, :number, :mail, :klasse, :code, :password, :password_confirmation)
  end

  def pres_params
    params.require(:presentation).permit(:vorname, :name, :klasse, :titel, :fach, :betreuer, :zimmer, :von, :bis)
  end

  def pres_edit_params
    params.permit(:vorname, :name, :klasse, :titel, :fach, :betreuer, :zimmer, :von, :bis)
  end
end
