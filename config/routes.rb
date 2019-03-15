Rails.application.routes.draw do

  # Dashboard -----------------------------------------------

  get 'teachers/list_teac'
  resources :students
  root 'static_pages#index'

  get 'signup', to: 'admins#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get 'process', to: 'admins#processor'

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

  get 'upload/students', to: 'admins#upload_stud'
  post 'upload/students', to: 'admins#import_students'

  get 'upload/presentations', to: 'admins#upload_pres'
  post 'upload/presentations', to: 'admins#import_presentations'

  get 'upload/settings', to: 'admins#prefs'
  post 'upload/settings', to: 'admins#prefs_upd'

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
