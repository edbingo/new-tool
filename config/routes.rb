Rails.application.routes.draw do

  get 'teacher/view'
  # Dashboard -----------------------------------------------

  get 'teachers/list_teac'
  resources :students
  root 'static_pages#index'

  get 'signup', to: 'admins#new', as: 'signup'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get 'admin/login', to: 'sessions#new'
  post 'admin/login', to: 'sessions#create'

  get 'login', to: 'sessions#new_stud'
  post 'login', to: 'sessions#studcreate'

  get 'teacher/list', to: 'teacher#view'

  get 'help', to: 'static_pages#help'

  get 'list/students/view/send/login', to: 'admins#send_login_single'
  get 'list/students/view/send/punish', to: 'admins#punishmail_single'

  get 'process', to: 'admins#processor'

  get 'registrieren', to: 'select#list'

  get 'send/testmail', to: 'admins#testmail'
  get 'send/punishmail', to: 'admins#punishmail'
  get 'send/finallist', to: 'admins#finalmail'

  get 'confirm/selection', to: 'select#confirm'

  get 'force', to: 'sessions#force'
  get 'return', to: 'sessions#back'
  get 'choose', to: 'select#add'
  get 'remove', to: 'select#remove'
  get 'confirm/selection', to: 'select#confirm'

  get 'list/presentations', to: 'admins#list_pres'
  get 'list/teachers', to: 'admins#list_teac'
  get 'list/students', to: 'admins#list_stud'
  get 'list/teachers/all', to: 'admins#list_teac_all'

  get 'list/teachers/view', to: 'admins#view_teac'
  get 'list/students/view', to: 'admins#view_stud'

  post 'admin/new', to: 'admins#create'
  post 'teacher/new', to: 'admins#new_teac'
  post 'student/new', to: 'admins#new_stud'
  post 'presentation/new', to: 'admins#new_pres'

  get 'update/teacher', to: 'admins#edit_teac'
  get 'update/presentation', to: 'admins#edit_pres'
  get 'update/student', to: 'admins#edit_stud'
  post 'presentation/update', to: 'admins#update_presentation'
  post 'student/update', to: 'admins#update_student'

  get 'list/presentations/view', to: 'admins#view_pres'

  get 'send/loginmail', to: 'admins#send_login'

  get 'registration/send', to: 'select#sending'

  post 'admin/update', to: 'admins#update_admin'
  patch 'teacher/update', to: 'admins#update_teacher'
  post 'teacher/update', to: 'admins#update_teacher'


  get 'dashboard', to: 'admins#dashboard'

  get 'settings', to: 'admins#settings'
  get 'settings/activate', to: 'admins#act'
  get 'settings/deactivate', to: 'admins#deact'
  post 'settings/update', to: 'admins#update_set'

  get 'mailer', to: 'admins#mailer'

  get 'upload/teachers', to: 'admins#upload_teac'
  post 'upload/teachers', to: 'admins#import_teachers'

  get 'upload/error', to: 'admins#error_page_upload'

  get 'upload/students', to: 'admins#upload_stud'
  post 'upload/students', to: 'admins#import_students'

  get 'upload/presentations', to: 'admins#upload_pres'
  post 'upload/presentations', to: 'admins#import_presentations'

  get 'upload/settings', to: 'admins#prefs'
  post 'upload/settings', to: 'admins#prefs_upd'

  get 'upload/help', to: 'admins#upload_help'

  get 'reset', to: 'admins#reset'
  get 'confirm', to: 'admins#clear'

  get 'delete/teacher', to: 'admins#del_teac'
  get 'delete/teacher/confirm', to: 'admins#del_teac_conf'

  get 'delete/presentation', to: 'admins#del_pres'
  get 'delete/presentation/confirm', to: 'admins#del_pres_conf'

  get 'delete/student', to: 'admins#del_stud'
  get 'delete/student/confirm', to: 'admins#del_stud_conf'
  resources :admins
  resources :students
  resources :presentations
  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
